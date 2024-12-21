import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:mimir/main.dart';
import 'package:mimir/solar_pro_message.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';

class SOLARPROScreen extends StatefulWidget {
  const SOLARPROScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<SOLARPROScreen> {
  late DatabaseReference _database;
  late TextEditingController textController;
  final ScrollController _scrollController = ScrollController();
  late int indexingNum;
  final List<String> _chatList = [];
  String? uid;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: 'https://mimir-1a487-default-rtdb.firebaseio.com/',
      ).ref('users').child(uid!).child('solar-pro');

      _database.onValue.listen(
        (DatabaseEvent event) {
          if (event.snapshot.exists && event.snapshot.value != null) {
            final data = event.snapshot.value;

            // 데이터를 처리합니다.
            List<String> updatedChatList = [];
            if (data is LinkedHashMap) {
              for (var value in data.values) {
                updatedChatList.add(value[0]['content']);
              }
            } else if (data is List) {
              for (var value in data) {
                updatedChatList.add(value['content']);
              }
            }

            setState(
              () {
                _chatList.clear();
                _chatList.addAll(updatedChatList);
              },
            );
          } else {
            // 데이터가 삭제되었을 경우 처리

            debugPrint("No data available or data was deleted");
            setState(
              () {
                _chatList.clear(); // 데이터 리스트를 초기화
              },
            );
          }

          // 새로운 데이터가 추가되거나 삭제된 경우 스크롤 업데이트
          _scrollToBottom();
        },
      );
    } else {
      // Firebase Auth에 로그인하지 않은 경우 처리
      debugPrint('User is not logged in');
      // Firebase Database 참조를 null로 설정하거나 적절한 기본값을 설정
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SOLARPROMessageService>(
      builder: (context, messageService, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Color.fromARGB(255, 27, 26, 50),
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 50.0,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Color.fromARGB(255, 245, 240, 183),
              ),
            ),
            title: Center(
              child: Text(
                'Test',
                style: TextStyle(
                  color: Color.fromARGB(255, 245, 240, 183),
                  fontSize: 18,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  messageService.clearMessageList();
                  _chatList.clear();

                  indexingNum = 0;
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Color.fromARGB(255, 245, 240, 183),
                ),
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: _chatList.isEmpty
                    ? const Center(
                        child: Text(
                          '대화가 없습니다.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 245, 240, 183),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chat = _chatList[index];
                          bool isSender = (index + 1) % 2 != 0;
                          return Messages(isSender: isSender, chat: chat);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0.0),
                child: TextField(
                  onSubmitted: (String userMessage) {
                    if (userMessage.trim().isNotEmpty) {
                      _sendMessage(messageService, userMessage);
                    }
                  },
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: textController,
                  style: TextStyle(
                    color: Color.fromARGB(255, 245, 240, 183),
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                    suffixIcon: CupertinoButton(
                      padding: const EdgeInsets.only(right: 10),
                      onPressed: () {
                        String userMessage = textController.text.trim();
                        if (userMessage.isNotEmpty) {
                          _sendMessage(messageService, userMessage);
                        }
                      },
                      child: const Icon(
                        color: Color.fromARGB(255, 245, 240, 183),
                        CupertinoIcons.arrow_up_circle_fill,
                        size: 30,
                      ),
                    ),
                    hintText: '내용을 입력하세요',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(30, 1, 1, 1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 245, 240, 183)),
                      borderRadius: BorderRadius.circular(38),
                    ),
                  ),
                  maxLines: null,
                  minLines: 1,
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage(SOLARPROMessageService messageService, String userMessage) {
    textController.clear();
    messageService.enterMessage(userMessage, _chatList.length);
    // indexingNum++;
    // _scrollToBottom();
    messageService.getResponseFromOpenAI(userMessage, _chatList.length + 1);
    // indexingNum++;
  }
}

class Messages extends StatelessWidget {
  const Messages({
    super.key,
    required this.isSender,
    required this.chat,
  });

  final bool isSender;
  final String chat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: isSender
            ? BubbleSpecialThree(
                text: chat,
                color: const Color.fromARGB(255, 110, 134, 158),
                tail: true,
                isSender: isSender ? true : false,
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 245, 240, 183),
                  fontSize: 16,
                ),
              )
            : Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child: getReceiverView(
                    ChatBubbleClipper3(type: BubbleType.receiverBubble),
                    context,
                    chat),
              ),
      ),
    );
  }
}

getReceiverView(CustomClipper clipper, BuildContext context, chat) =>
    SelectionArea(
      child: ChatBubble(
        clipper: clipper,
        backGroundColor: const Color.fromARGB(255, 113, 119, 123),
        margin: EdgeInsets.only(top: 1, bottom: 1),
        child: GptMarkdown(
          chat,
          style: TextStyle(
              color: Color.fromARGB(255, 245, 240, 183), fontSize: 16),
        ),
      ),
    );
