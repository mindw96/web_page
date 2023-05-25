import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_gpt/chat_screen.dart';
import 'package:i_gpt/code_screen.dart';
import 'package:i_gpt/image_screen.dart';

class BotList extends StatelessWidget {
  const BotList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.3),
        ),
        elevation: 0.0,
        title: Text(
          'AI ChatBot',
          style: TextStyle(
            color: Color.fromARGB(255, 29, 78, 137),
            fontSize: 40.0,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text('추후 업데이트 예정 입니다.'),
                    insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
                    actions: [
                      TextButton(
                        child: const Text('확인'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.person_add_alt_1_sharp,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.person_2_sharp,
              size: 30.0,
            ),
            title: Text(
              'User',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          Divider(
            indent: 30.0,
            endIndent: 30.0,
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'iGPT',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    '한국어로 대답하는 ChatGPT 입니다.',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ChatScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'iDall-E',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    '영어로 번역해서 이미지를 생성해주는 AI 입니다.',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ImageScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'Code Helper',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    '코드를 작성해주는 AI 입니다.',
                    style: TextStyle(fontSize: 13.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CodeScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
