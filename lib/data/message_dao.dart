import 'package:firebase_database/firebase_database.dart';
import 'message.dart';
class MessageDao{

  final DatabaseReference _messageRef = FirebaseDatabase.instance.reference().child("Info");


  void saveMessage(Message message){
    _messageRef.push().set(message.toJson());
  }

  Query getMessageQuery(){
    return _messageRef;
  }

  void getChild(){

  }

}