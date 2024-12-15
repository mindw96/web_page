import 'package:mimir/bot_list.dart';
import 'package:flutter/material.dart';
import 'chats.dart';

// class ChatApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mimir',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        BotList(),
        ChatList(),
      ].elementAt(currentPageIndex),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 0.0),
      //   child: NavigationBar(
      //     backgroundColor: Colors.white,
      //     onDestinationSelected: (int index) {
      //       setState(() {
      //         currentPageIndex = index;
      //       });
      //     },
      //     selectedIndex: currentPageIndex,
      //     destinations: const <Widget>[
      //       NavigationDestination(
      //         icon: Icon(Icons.assignment_ind_outlined),
      //         selectedIcon: Icon(Icons.assignment_ind_rounded),
      //         label: 'Bot List',
      //       ),
      //       NavigationDestination(
      //         icon: Icon(Icons.chat_bubble_outline_rounded),
      //         selectedIcon: Icon(Icons.chat_bubble_rounded),
      //         label: 'Chat',
      //       ),
      //     ],
      //   ),
      // );
    );
  }
}
