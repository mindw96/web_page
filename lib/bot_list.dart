import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_gpt/chat_screen.dart';
import 'package:i_gpt/image_screen.dart';

class BotList extends StatelessWidget {
  const BotList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Bot List',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.0,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_add_alt_1_sharp,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person_2_sharp),
            title: Text('User'),
          ),
          Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.person_2_sharp,
                    size: 30.0,
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
                  leading: Icon(
                    Icons.person_2_sharp,
                    size: 30.0,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
