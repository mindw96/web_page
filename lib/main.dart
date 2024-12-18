// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/env.dart';
import 'package:mimir/fb_test_message.dart';
import 'package:mimir/firebase_options.dart';

import 'package:provider/provider.dart';
import 'package:mimir/bot_list.dart';
import 'package:mimir/gpt4_ori_message.dart';
import 'package:mimir/solar_message.dart';
import 'package:mimir/solar_pro_message.dart';
import 'package:mimir/gpt_o1_message.dart';
import 'package:mimir/gemini_1.5_flash_message.dart';
import 'package:mimir/sign_up.dart';
import 'image_ori_message.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  OpenAI.apiKey = Env.openAiApiKey;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TestMessageService()),
        ChangeNotifierProvider(create: (context) => ImageServiceOri()),
        ChangeNotifierProvider(create: (context) => GPT4OriMessageService()),
        ChangeNotifierProvider(create: (context) => GPTo1MessageService()),
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

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    // FocusNode는 반드시 해제해줘야 합니다.
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    userInfo = await _storage.read(key: 'login');

    if (userInfo != null) {
      if (mounted) {
        Navigator.push(context, CupertinoPageRoute(builder: (_) => BotList()));
      }
    } else {
      print('로그인이 필요합니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                SizedBox(
                  width: 300,
                  child: emailInput(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  child: passwordInput(),
                ),
                const SizedBox(height: 16),
                loginButton(),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    overlayColor: Colors.blue.withAlpha(30),
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
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: _login,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
      controller: _passwordController,
      obscureText: true,
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
      controller: _emailController,
      validator: (val) {
        if (val!.isEmpty) {
          return 'The input is empty.';
        } else {
          return null;
        }
      },
      style: TextStyle(color: Colors.black),
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
