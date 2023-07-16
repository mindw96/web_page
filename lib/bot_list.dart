import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Mimir/chat_screen.dart';
import 'package:Mimir/code_screen.dart';
import 'package:Mimir/gpt4_screen.dart';
import 'package:Mimir/image_screen.dart';

class BotList extends StatefulWidget {
  const BotList({super.key});

  @override
  State<BotList> createState() => _BotListState();
}

class _BotListState extends State<BotList> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Color selectedColor = Theme.of(context).primaryColor;
    ThemeData lightTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.light,
    );
    ThemeData darkTheme = ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: Brightness.dark,
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // appBar: AppBar(
      //   toolbarHeight: 44.0,
      //   centerTitle: false,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   title: Text(
      //     'Mimir',
      //     style: textTheme.displaySmall!
      //         .copyWith(color: lightTheme.colorScheme.primary),
      //     // style: TextStyle(
      //     //   color: Color.fromARGB(255, 29, 78, 137),
      //     //   fontSize: 48.0,
      //     // ),
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         showDialog(
      //           context: context,
      //           barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
      //           builder: (BuildContext context) {
      //             return AlertDialog(
      //               content: Text('추후 업데이트 예정 입니다.'),
      //               insetPadding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
      //               actions: [
      //                 TextButton(
      //                   child: const Text('확인'),
      //                   onPressed: () {
      //                     Navigator.of(context).pop();
      //                   },
      //                 ),
      //               ],
      //             );
      //           },
      //         );
      //       },
      //       icon: Icon(
      //         Icons.person_add_alt_1_sharp,
      //         color: Colors.black,
      //       ),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.person,
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
                  shape: Theme.of(context).listTileTheme.shape,
                  leading: Image.asset(
                    'assets/images/ChatGPT_logo.png',
                    width: 40,
                    height: 40,
                  ),
                  title: RichText(
                    text: TextSpan(
                      text: 'Chat GPT',
                      style: textTheme.bodyLarge!,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Korean Ver.',
                          style: textTheme.bodySmall!.copyWith(
                              color: lightTheme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '한국어로 대답하는 ChatGPT 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
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
                  title: RichText(
                    text: TextSpan(
                      text: 'Dall-E',
                      style: textTheme.bodyLarge!,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Korean Ver.',
                          style: textTheme.bodySmall!.copyWith(
                              color: lightTheme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    '영어로 번역해서 이미지를 생성해주는 AI 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
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
                    style: textTheme.bodyLarge!,
                  ),
                  subtitle: Text(
                    '코드를 작성해주는 AI 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CodeScreen(),
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
                  title: RichText(
                    text: TextSpan(
                      text: 'GPT 4',
                      style: textTheme.bodyLarge!,
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Korean Ver.',
                          style: textTheme.bodySmall!.copyWith(
                              color: lightTheme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    'ChatGPT 4 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => GPT4Screen(),
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
