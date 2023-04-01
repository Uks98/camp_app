import 'dart:convert';

import 'package:camper/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

import '../data/chat_gpt_model.dart';

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "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";

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      'temperature': 0,
      'max_tokens': 2000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  // Do something with the response
  Map<String, dynamic> newResponse =
      jsonDecode(utf8.decode(response.bodyBytes));

  return newResponse['choices'][0]['text'];
}

class _ChatPageState extends State<ChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_outlined,color: Colors.grey[800],),
        ),
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "AI 캠핑플래너",
            style: TextStyle(color: Colors.black,),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Container(
                    width: 60,
                    height: 20,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseSync, // Required, The loading type of the widget
                        colors: const [Colors.red,Colors.yellow,Colors.blue],       // Optional, The color collections
                        strokeWidth: 2,                     // Optional, The stroke of the line, only applicable to widget which contains line
                        backgroundColor: Colors.white,      // Optional, Background of the widget
                        pathBackgroundColor: Colors.black  // Optional, the stroke backgroundColor
                    ),
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: Color(0xff62CDFF),
        child: IconButton(
          color: ColorBox.backColor,
          icon: const Icon(
            Icons.send_rounded,
            color: Color(0xffF6F1F1)
          ),
          onPressed: () async {
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.black),
        controller: _textController,
        decoration: const InputDecoration(
          fillColor: Color(0xffF6F1F1),
          hintText: "메세지를 입력해주세요",
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  const ChatMessageWidget(
      {super.key, required this.text, required this.chatMessageType});

  final String text;
  final ChatMessageType chatMessageType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        chatMessageType == ChatMessageType.bot
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 16.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'lib/asset/bot.png',
                              //color: Colors.white,
                              scale: 1.5,
                            ),
                          ),
                        ),
                        Text("오늘의 캠핑"),
                      ],
                    ),
                  ),
                  //오류발생
                  //text를 두개쓰고있음
                  //보내는 메세지 위젯
                 // Text(text),
                  getReceiverView(
                      ChatBubbleClipper5(type: BubbleType.receiverBubble), context, text),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10,),
                      getSenderView(
                          ChatBubbleClipper5(type: BubbleType.sendBubble), context,text),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  getSenderView(CustomClipper clipper, BuildContext context, String? text) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20,right: 10),
        backGroundColor: Colors.black,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            text!,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  getReceiverView(CustomClipper clipper, BuildContext context, String bot)=>
    Padding(
      padding: const EdgeInsets.only(left: 50.0),
      child: ChatBubble(
        clipper: clipper,
        backGroundColor: Colors.grey[200],
        margin: EdgeInsets.only(top: 5),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(text, style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );


}
