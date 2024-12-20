import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimir/fg_test_screen.dart';
import 'package:mimir/gemini_1.5_flash_screen.dart';
import 'package:mimir/gpt4_mini_screen.dart';
import 'package:mimir/gpt_o1_screen.dart';
import 'package:mimir/gpt4_ori_screen.dart';
import 'package:mimir/image_ori_screen.dart';
import 'package:mimir/solar_pro_screen.dart';
import 'package:mimir/solar_screen.dart';

class BotList extends StatefulWidget {
  const BotList({super.key});

  @override
  State<BotList> createState() => _BotListState();
}

class _BotListState extends State<BotList> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 26, 50),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero, // ListView의 기본 패딩 제거
              children: [
                ListTile(
                  title: Text(
                    'Chats',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 18,
                    ),
                  ),
                ),
                // ListTile(
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: Text(
                //     'Test Bot',
                //     style: TextStyle(
                //       color: Color.fromARGB(255, 245, 240, 183),
                //       fontSize: 15,
                //     ),
                //   ),
                //   subtitle: Text(
                //     'Test',
                //     style: TextStyle(
                //       color: Color.fromARGB(255, 245, 240, 183),
                //       fontSize: 12,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(builder: (_) => TestScreen()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'GPT 4o mini',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'ChatGPT 4o mini 입니다.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => GPT4MiniScreen()),
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
                    'GPT 4o',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'ChatGPT 4o 입니다.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => GPT4OriScreen()),
                    );
                  },
                ),

                // ListTile(
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: Text(
                //     'GPT o1',
                //   ),
                //   subtitle: Text(
                //     'ChatGPT o1 입니다.',
                //     style: textTheme.bodySmall!,
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(builder: (_) => GPTo1Screen()),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/solar_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'SOLAR Mini',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Solar-Mini 입니다.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => SOLARScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/solar_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'SOLAR Pro',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Solar-Pro 입니다.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => SOLARPROScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/gemini_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'Gemini 1.5 Flash',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Gemini 1.5 Flash 입니다. (Only Single Turn)',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => GeminiFlashScreen()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Image',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 18,
                    ),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: Text(
                    'DALL-E 3',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'DALL-E 3 입니다.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => ImageScreenOri()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
