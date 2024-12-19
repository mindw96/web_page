import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mimir/image_ori_message.dart';
import 'package:mimir/main.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_network/image_network.dart';
import 'dart:collection';

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

  Future<void> saveImageUsingDio(String imageUrl) async {
    try {
      // Dio로 이미지 데이터를 다운로드
      Dio dio = Dio();
      Response<Uint8List> response = await dio.get<Uint8List>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Uint8List 데이터를 Blob으로 변환
      final blob = html.Blob([response.data!]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      // 파일 다운로드
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = 'downloaded_image.jpg'; // 다운로드될 파일 이름
      anchor.click();

      // URL 해제
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error downloading image: $e');
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
            backgroundColor: Colors.white,
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
                  color: Colors.black,
                ),
              ),
              title: Center(
                child: Text('Dall E 3'),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    messageService.clearMessageList();
                    indexingNum = 0;
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
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
                            return ListTile(
                              title: isSender
                                  ? BubbleSpecialThree(
                                      text: chat,
                                      color: const Color.fromARGB(
                                          255, 34, 148, 251),
                                      tail: true,
                                      isSender: true,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        ImageNetwork(
                                          image: chat,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          fitWeb: BoxFitWeb.cover,
                                          onPointer: true,
                                          onLoading:
                                              const CircularProgressIndicator(
                                            color: Colors.indigoAccent,
                                          ),
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  child: Dialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: ImageNetwork(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      image: chat,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      // fullScreen: true,
                                                      onPointer: true,
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onLoading:
                                                          const CircularProgressIndicator(
                                                        color:
                                                            Colors.indigoAccent,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.save_alt),
                                              onPressed: () {
                                                saveImageUsingDio(chat);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 0.0),
                    child: TextField(
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
                          ),
                        ),
                        hintText: '내용을 입력하세요',
                        contentPadding: const EdgeInsets.fromLTRB(30, 1, 1, 1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
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
