import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:Mimir/code_message.dart';
import 'package:provider/provider.dart';

class CodeScreen extends StatefulWidget {
  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _needScroll = false;
  String userMessage = '';

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (_needScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _needScroll = false;
    }

    return Consumer<CodeService>(builder: (context, codeService, child) {
      List<String> messageList = codeService.messageList;
      return Scaffold(
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
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              )),
          title: Center(
            child: Column(
              children: [
                Text(
                  "Code Helper",
                  style: textTheme.bodyLarge!,
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  codeService.clearMessageList();
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
                ))
          ],
        ),
        // appBar: iAppBar(),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: messageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SelectionArea(
                      child: ListTile(
                        title: (index + 1) % 2 == 0
                            ? messageList[index] == ''
                                ? FutureBuilder(
                                    future: codeService.getRespone(userMessage),
                                    builder: (context, snapshot) {
                                      List<Widget> children;
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        messageList.removeLast();
                                        codeService.enterMessage(
                                            snapshot.data.toString());
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                                (_) => _scrollToBottom());
                                        children = <Widget>[
                                          Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                            ),
                                            // child: Markdown(
                                            //   selectable: true,
                                            //   data: messageList[index],
                                            // ),

                                            child: BubbleSpecialThree(
                                              text: messageList[index],
                                              color: const Color.fromARGB(
                                                  255, 180, 180, 188),
                                              tail: true,
                                              isSender: false,
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ];
                                      } else {
                                        children = <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 50.0),
                                              margin: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 180, 180, 188),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SpinKitThreeBounce(
                                                  color: Colors.black,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ];
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: children,
                                      );
                                    },
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          // child: Markdown(
                                          //   selectable: true,
                                          //   data: messageList[index],
                                          // ),

                                          child: BubbleSpecialThree(
                                            text: messageList[index],
                                            color: const Color.fromARGB(
                                                255, 180, 180, 188),
                                            tail: true,
                                            isSender: false,
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                            : Column(
                                // User Message
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: BubbleSpecialThree(
                                      text: messageList[index],
                                      color: const Color.fromARGB(
                                          255, 34, 148, 251),
                                      tail: true,
                                      textStyle: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 20.0),
                child: Container(
                  color: Colors.white,
                  height: 45,
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                      suffixIcon: CupertinoButton(
                        padding: const EdgeInsets.only(right: 10),
                        onPressed: () async {
                          userMessage = textController.text.trim();
                          textController.clear();

                          codeService.enterMessage(userMessage);
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _scrollToBottom());

                          codeService.enterMessage('');
                        },
                        child: const Icon(
                          CupertinoIcons.arrow_up_circle_fill,
                          size: 30,
                        ),
                      ),
                      hintText: '내용을 입력하세요',
                      isDense: false,
                      contentPadding: const EdgeInsets.fromLTRB(30, 1, 1, 1),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                    ),
                    maxLines: 10,
                    minLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
