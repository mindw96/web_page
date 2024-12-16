import 'package:flutter/material.dart';

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
                    Navigator.pushNamed(
                      context,
                      '/gpt4o',
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
                    Navigator.pushNamed(
                      context,
                      '/gpt-o1-preview',
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
                    Navigator.pushNamed(context, '/dall-e3');
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
                    Navigator.pushNamed(
                      context,
                      '/solar',
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
                    Navigator.pushNamed(
                      context,
                      '/solarpro',
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
                  ),
                  subtitle: Text(
                    'Gemini 1.5 Flash 입니다. (Only Single Turn)',
                    style: textTheme.bodySmall!
                        .copyWith(color: lightTheme.disabledColor),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/gemini-1_5-flash',
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
