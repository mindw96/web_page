import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController textController = TextEditingController();

  Future<String> sendMessage(String message) async {
    String api = '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';
    String endpoint = 'https://api.openai.com/v1/chat/completions';

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $api',
    };

    Map<String, dynamic> data = {
      'model': 'gpt-3.5-turbo-0301',
      //'model': 'code-davinci-002',
      'messages': [
        {
          'role': 'system',
          'content': 'You are very kind, intelligent, and perceptive',
        },
        {
          'role': 'system',
          'content': 'you are assistant for koreans',
        },
        {'role': 'user', 'content': message},
      ],
      "temperature": 0.3,
    };

    var response = await http.post(
      Uri.parse(endpoint),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(utf8.decode(response.bodyBytes));
      String reply =
          jsonResponse['choices'][0]['message']['content'].toString();
      return reply;
    } else {
      throw Exception('API request failed');
    }
  }

  Future _sendMessage() async {
    String userMessage = textController.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        messages.add(userMessage);
        textController.clear();
      });

      try {
        String response = await sendMessage(userMessage);
        setState(() {
          messages.add(response);
        });
        return response;
      } catch (e) {
        messages.add('API가 유요하지 않습니다.');
      }
    }
    _needScroll = true;
  }

  final ScrollController _scrollController = ScrollController();

  bool _needScroll = false;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    if (_needScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      _needScroll = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 216, 223),
        elevation: 0.1,
        title: const Center(
          child: Column(
            children: [
              Icon(
                CupertinoIcons.smiley,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "iGPT",
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: (index + 1) % 2 == 0
                        ? Column(
                            // Bot Message
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: BubbleSpecialThree(
                                  text: messages[index],
                                  color:
                                      const Color.fromARGB(255, 180, 180, 188),
                                  tail: true,
                                  isSender: false,
                                ),
                              )
                            ],
                          )
                        : Column(
                            // User Message
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: BubbleSpecialThree(
                                  text: messages[index],
                                  color:
                                      const Color.fromARGB(255, 34, 148, 251),
                                  tail: true,
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 20.0),
              child: SizedBox(
                height: 45,
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(38),
                    ),
                    suffixIcon: CupertinoButton(
                      padding: const EdgeInsets.only(right: 10),
                      onPressed: _sendMessage,
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
  }
}
