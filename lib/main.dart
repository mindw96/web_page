// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/firebase_options.dart';

import 'package:provider/provider.dart';
import 'package:mimir/bot_list.dart';
import 'package:mimir/gpt4_ori_message.dart';
import 'package:mimir/solar_message.dart';
import 'package:mimir/solar_pro_message.dart';
import 'package:mimir/gpt4_o1_preview_message.dart';
import 'package:mimir/gemini_1.5_flash_message.dart';
import 'package:mimir/sign_up.dart';
import 'image_ori_message.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ImageServiceOri()),
        ChangeNotifierProvider(create: (context) => GPT4OriMessageService()),
        ChangeNotifierProvider(
            create: (context) => GPT4o1PreviewMessageService()),
        ChangeNotifierProvider(create: (context) => SOLARMessageService()),
        ChangeNotifierProvider(create: (context) => SOLARPROMessageService()),
        ChangeNotifierProvider(
            create: (context) => GeminiFlashMessageService()),
      ],
      child: const MyApp(),
    ),
  );
  setUrlStrategy(PathUrlStrategy());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _storage = FlutterSecureStorage();
  dynamic userInfo = '';
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await _storage.read(key: 'login');

    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      Navigator.push(context, CupertinoPageRoute(builder: (_) => BotList()));
    } else {
      print('로그인이 필요합니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Mimir',
            textAlign: TextAlign.center,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  emailInput(),
                  const SizedBox(height: 16),
                  passwordInput(),
                  const SizedBox(height: 16),
                  loginButton(),
                  const SizedBox(height: 16),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith(
                          (states) => Colors.blue.withAlpha(30)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SignupPage(),
                      ),
                    ),
                    child: const Text(
                      style: TextStyle(color: Colors.black),
                      "Sign Up",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      print('[SECURE_STORAGE] saveRefreshToken: $refreshToken');
      await _storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
    } catch (e) {
      print("[ERR] RefreshToken 저장 실패: $e");
    }
  }

  // 리프레시 토큰 불러오기
  Future<String?> readRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'REFRESH_TOKEN');
      print('[SECURE_STORAGE] readRefreshToken: $refreshToken');
      return refreshToken;
    } catch (e) {
      print("[ERR] RefreshToken 불러오기 실패: $e");
      return null;
    }
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.black, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shadowColor: Colors.blue,
        elevation: 0,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return Colors.blue.withValues(alpha: 0.3);
          }
          return null;
        }),
      ),
      child: Text(
        'Login',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  void _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((_) => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => BotList(),
              )));
      await _storage.write(
        key: 'login',
        value: 'login',
      );
      debugPrint('Login success.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        if (mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('로그인 실패'),
                  content: Text('ID 또는 비밀번호가 일치하지 않습니다.'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
        }

        _emailController.clear();
        _passwordController.clear();
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        if (mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('로그인 실패'),
                  content: Text('ID 또는 비밀번호가 일치하지 않습니다.'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
        }
        _passwordController.clear();
      } else if (e.code == 'invalid-email') {
        debugPrint('The email address is badly formatted.');
        if (mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('로그인 실패'),
                  content: Text('Email 형식이 잘못되었습니다.'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
        }
        _emailController.clear();
        _passwordController.clear();
      } else if (e.code == 'invalid-credential') {
        if (mounted) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Text('로그인 실패'),
                  content: Text('옳바르지 않은 Password 입니다.'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          overlayColor: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '확인',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                );
              });
          _passwordController.clear();
        } else {
          debugPrint('Error: ${e.code}, ${e.message}');
        }
      }
    }
  }

  TextFormField passwordInput() {
    return TextFormField(
      onEditingComplete: () {
        FocusScope.of(context).unfocus(); // 포커스 제거
      },
      controller: _passwordController,
      obscureText: true,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        label: Text(
          style: TextStyle(color: Colors.black),
          'Password',
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: (value) {
        _login();
      },
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      onEditingComplete: () {
        FocusScope.of(context).unfocus(); // 포커스 제거
      },
      autofocus: true,
      controller: _emailController,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        label: Text(
          style: TextStyle(color: Colors.black),
          'Email',
        ),
        border: OutlineInputBorder(),
      ),
    );
  }
}
