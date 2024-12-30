import 'dart:async';
import 'dart:collection';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:mimir/image_ori_message.dart';
import 'package:mimir/main.dart';

class ImageScreenOri extends StatefulWidget {
  const ImageScreenOri({super.key});

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreenOri> {
  late DatabaseReference _database;
  late TextEditingController textController;
  final ScrollController _scrollController = ScrollController();
  late int indexingNum;
  String? uid;
  bool _needScroll = false;

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
      ).ref('users').child(uid!).child('dall-e-3');

      DataSnapshot snapshot = await _database.get();
      if (snapshot.value == null) {
        indexingNum = 0;
      } else {
        List<dynamic> value = snapshot.value as List<dynamic>;
        indexingNum = value.length;
      }
    } else {
      // Firebase Auth에 로그인하지 않은 경우 처리
      debugPrint('User is not logged in');
      // Firebase Database 참조를 null로 설정하거나 적절한 기본값을 설정
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => LoginScreen()));
    }

    setState(() {}); // 상태 업데이트
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void saveImage(String imageUrl) {
    final anchor = html.AnchorElement(href: imageUrl)
      ..target = 'blank'
      ..download = 'downloaded_image.jpg'; // 다운로드될 파일 이름 지정
    anchor.click();
    anchor.remove();
  }

  Future<void> downloadImage(String imageUrl) async {
    // final String proxyUrl = 'https://cors-anywhere.herokuapp.com/';
    final String proxyUrl = 'https://cors.bridged.cc/';
    final String proxiedImageUrl = '$proxyUrl$imageUrl';
    final Dio dio = Dio();
    try {
      final Response<Uint8List> response = await dio.get<Uint8List>(
        proxiedImageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final blob = html.Blob([response.data!]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..download = 'downloaded_image.jpg'
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      debugPrint('Failed to download image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _needScroll = false;
    }

    return Consumer<ImageServiceOri>(
      builder: (context, messageService, child) {
        return GestureDetector(
          child: Scaffold(
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
                  'Dall E 3',
                  style: TextStyle(
                      color: Color.fromARGB(255, 245, 240, 183), fontSize: 18),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    messageService.clearMessageList();
                    indexingNum = 0;
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Color.fromARGB(255, 245, 240, 183),
                  ),
                )
              ],
            ),
            body: GestureDetector(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: _database.onValue,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Error fetching data"));
                        }
                        if (!snapshot.hasData ||
                            snapshot.data?.snapshot.value == null) {
                          return const Center(child: Text("대화가 없습니다."));
                        }

                        final data = snapshot.data!.snapshot.value;
                        List<dynamic> chatList1 = [];
                        List<String> chatList2 = [];

                        if (data is LinkedHashMap<dynamic, dynamic>) {
                          for (var value in data.values) {
                            chatList1.add(value[0]['content']);
                          }
                        } else if (data is List<Object?>) {
                          for (var value in data) {
                            chatList1.add(value);
                          }
                        } else {
                          return Center(child: Text("Invalid data format}"));
                        }

                        for (var value in chatList1) {
                          if (value is List) {
                            chatList2.add(value[0]['content']);
                          } else {
                            chatList2.add(value['content']);
                          }
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: chatList2.length,
                          itemBuilder: (BuildContext context, int index) {
                            var chat = chatList2[index];
                            bool isSender = (index + 1) % 2 != 0;
                            if (isSender) {
                              return UserMessage(chat: chat);
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageMessage(
                                      indexingNum: indexingNum, chat: chat),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35),
                                      IconButton(
                                        icon: Icon(
                                          Icons.save_alt,
                                          color: Color.fromARGB(
                                              255, 245, 240, 183),
                                        ),
                                        onPressed: () {
                                          downloadImage(chat);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0.0),
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromARGB(255, 245, 240, 183),
                      ),
                      onSubmitted: (String userMessage) {
                        if (userMessage.trim().isNotEmpty) {
                          textController.clear();
                          messageService.enterMessage(userMessage, indexingNum);
                          indexingNum++;
                          _needScroll = true;
                          messageService.getResponseFromOpenAI(
                              userMessage, indexingNum);
                          indexingNum++;
                        }
                      },
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      controller: textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(38),
                        ),
                        suffixIcon: CupertinoButton(
                          padding: const EdgeInsets.only(right: 10),
                          onPressed: () {
                            String userMessage = textController.text.trim();
                            if (userMessage.isNotEmpty) {
                              textController.clear();
                              messageService.enterMessage(
                                  userMessage, indexingNum);
                              indexingNum++;
                              _needScroll = true;
                              messageService.getResponseFromOpenAI(
                                  userMessage, indexingNum);
                              indexingNum++;
                            }
                          },
                          child: const Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            size: 30,
                            color: Color.fromARGB(255, 245, 240, 183),
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
            ),
          ),
        );
      },
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.indexingNum,
    required this.chat,
  });

  final int indexingNum;
  final String chat;

  @override
  Widget build(BuildContext context) {
    return BubbleNormalImage(
      id: '$indexingNum',
      bubbleRadius: BUBBLE_RADIUS_IMAGE,
      image: ImageNetwork(
        image: chat,
        height: MediaQuery.of(context).size.width * 0.5,
        width: MediaQuery.of(context).size.width * 0.5,
        fitWeb: BoxFitWeb.cover,
        fullScreen: true,
        onPointer: true,
        onError:
            const Icon(Icons.error, color: Color.fromARGB(255, 245, 240, 183)),
        onLoading: const CircularProgressIndicator(
          color: Color.fromARGB(255, 245, 240, 183),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: ImageNetwork(
                  borderRadius: BorderRadius.circular(18),
                  image: chat,
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  // fullScreen: true,
                  onPointer: true,
                  fullScreen: true,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  onLoading: const CircularProgressIndicator(
                    color: Color.fromARGB(255, 245, 240, 183),
                  ),
                ),
              );
            },
          );
        },
      ),
      color: Colors.transparent,
      isSender: false,
      tail: true,
    );
  }
}

class UserMessage extends StatelessWidget {
  const UserMessage({
    super.key,
    required this.chat,
  });

  final String chat;

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      text: chat,
      color: Color.fromARGB(255, 110, 134, 158),
      tail: true,
      isSender: true,
      textStyle: TextStyle(
        color: Color.fromARGB(255, 245, 240, 183),
        fontSize: 16,
      ),
    );
  }
}
