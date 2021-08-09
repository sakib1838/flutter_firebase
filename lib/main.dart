import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/message.dart';
import 'data/message_dao.dart';
import 'message_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        appBar: AppBar(
          title: Text('Flutter Firebase'),
        ),
        body: HomePage(),
      )
    );
  }
}

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  final MessageDao messageDao = new MessageDao();
  @override
  _HomePageState createState() => _HomePageState();
}

TextEditingController _messageController = TextEditingController();
class _HomePageState extends State<HomePage> {

  ScrollController _scrollController = ScrollController();
  final databaseReference = FirebaseDatabase.instance.reference();




  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());
    return Center(
      child: Column(
        children: [
          _getMessageList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: _messageController,
                    onChanged: (text)=>setState(() {}),
                    onSubmitted: (input){
                      createRecord();
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                    ),
                  ),
                ),
              ),
              
              IconButton(onPressed: (){
                createRecord();
                  },
                icon: Icon(_canSendMessage()? CupertinoIcons.arrow_right_circle_fill:CupertinoIcons.arrow_right_circle),
              ),
              
            ],
          ),

        ],
      ),
    );
  }

  bool _canSendMessage() => _messageController.text.length > 0;

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.messageDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Message.fromJson(json);
          return MessageWidget(message.text, message.date);
        },
      ),
    );
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void createRecord(){
    // databaseReference.child("Info").push().set({'title':'Mastering EJB',
    // 'description':'Programming Guide for J2EE'}).then((result){
    //   print('Success');
    // }).catchError((error){
    //   print('Error');
    // });
    final message = Message(_messageController.text,DateTime.now());
    widget.messageDao.saveMessage(message);
    _messageController.clear();
  }
}






