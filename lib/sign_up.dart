import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text("Sign Up")),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailInput(),
                const SizedBox(height: 15),
                passwordInput(),
                const SizedBox(height: 15),
                submitButton(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      autofocus: true,
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

  TextFormField passwordInput() {
    return TextFormField(
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
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        label: Text(
          style: TextStyle(color: Colors.black),
          'Password',
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: () async {
        // 여기에 작성
        try {
          final _ = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              )
              // ignore: use_build_context_synchronously
              .then((_) => Navigator.pushNamed(context, "/login"));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            if (mounted) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('회원가입 실패'),
                      content: Text('비밀번호는 6자리 이상 입력해주세요.'),
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
          } else if (e.code == 'email-already-in-use') {
            if (mounted) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('회원가입입 실패'),
                      content: Text('이미 사용중인 Email입니다.'),
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
          } else if (e.code == 'invalid-email') {
            if (mounted) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text('회원가입 실패'),
                      content: Text('옳바른 Email 형식을 사용해주세요.'),
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
          }
        }
      },
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
        'Sign Up',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
