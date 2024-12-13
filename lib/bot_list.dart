import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Mimir/chat_screen.dart';
import 'package:Mimir/code_screen.dart';
import 'package:Mimir/gpt4_screen.dart';
import 'package:Mimir/gpt4_o1_preview_screen.dart';
import 'package:Mimir/gpt4_ori_screen.dart';
import 'package:Mimir/image_screen.dart';
import 'package:Mimir/image_ori_screen.dart';
import 'package:Mimir/solar_screen.dart';
import 'package:Mimir/solar_pro_screen.dart';

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

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // ListTile(
                //   shape: Theme.of(context).listTileTheme.shape,
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: RichText(
                //     text: TextSpan(
                //       text: 'Chat GPT',
                //       style: textTheme.bodyLarge!,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: ' Korean Ver.',
                //           style: textTheme.bodySmall!.copyWith(
                //               color: lightTheme.colorScheme.onSurface),
                //         ),
                //       ],
                //     ),
                //   ),
                //   subtitle: Text(
                //     '한국어로 대답하는 ChatGPT 입니다.',
                //     style: textTheme.bodySmall!
                //         .copyWith(color: lightTheme.disabledColor),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (_) => ChatScreen(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: RichText(
                //     text: TextSpan(
                //       text: 'Dall-E',
                //       style: textTheme.bodyLarge!,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: ' Korean Ver.',
                //           style: textTheme.bodySmall!.copyWith(
                //               color: lightTheme.colorScheme.onSurface),
                //         ),
                //       ],
                //     ),
                //   ),
                //   subtitle: Text(
                //     '영어로 번역해서 이미지를 생성해주는 AI 입니다.',
                //     style: textTheme.bodySmall!
                //         .copyWith(color: lightTheme.disabledColor),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (_) => ImageScreen(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: Text(
                //     'Code Helper',
                //     style: textTheme.bodyLarge!,
                //   ),
                //   subtitle: Text(
                //     '코드를 작성해주는 AI 입니다.',
                //     style: textTheme.bodySmall!
                //         .copyWith(color: lightTheme.disabledColor),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (_) => CodeScreen(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Image.asset(
                //     'assets/images/ChatGPT_logo.png',
                //     width: 40,
                //     height: 40,
                //   ),
                //   title: RichText(
                //     text: TextSpan(
                //       text: 'GPT 4',
                //       style: textTheme.bodyLarge!,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: ' Korean Ver.',
                //           style: textTheme.bodySmall!.copyWith(
                //               color: lightTheme.colorScheme.onSurface),
                //         ),
                //       ],
                //     ),
                //   ),
                //   subtitle: Text(
                //     '한국어로 대답하는 ChatGPT 4 입니다.',
                //     style: textTheme.bodySmall!
                //         .copyWith(color: lightTheme.disabledColor),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (_) => GPT4Screen(),
                //       ),
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
                    'GPT 4o',
                  ),
                  subtitle: Text(
                    'ChatGPT 4o 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => GPT4OriScreen(),
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
                    'GPT o1 Preview',
                  ),
                  subtitle: Text(
                    'ChatGPT o1 Preview 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => GPT4o1Screen(),
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
                    'DALL-E 3',
                  ),
                  subtitle: Text(
                    'DALL-E 3 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ImageScreenOri(),
                      ),
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
                    'SOLAR Mini',
                  ),
                  subtitle: Text(
                    'Solar-Mini 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SOLARScreen(),
                      ),
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
                  ),
                  subtitle: Text(
                    'Solar-Pro 입니다.',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SOLARPROScreen(),
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
