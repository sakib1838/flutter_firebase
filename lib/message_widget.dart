import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';


class MessageWidget extends StatefulWidget {
  final String message;
  final DateTime date;

  MessageWidget(this.message, this.date);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final firebaseDatabase = FirebaseDatabase.instance.reference();

  TextEditingController _newmessageController= new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: (){
      },

      menuItems: [
        FocusedMenuItem(title: Text("Edit"),trailingIcon: Icon(Icons.edit) ,backgroundColor: Colors.greenAccent ,onPressed: (){
          print(widget.message);
          FirebaseDatabase.instance.reference().child('Info')
              .orderByChild('text')
              .equalTo(widget.message).once()
              .then((onValue) {
            Map data = onValue.value;
            print(data);
            var key= data.keys.toString();
            print(key.substring(1,key.length-1));
            _newmessageController.text=widget.message;
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                scrollable: true,
                title:Text('Change Text'),
                content: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Write'
                          ),
                          controller: _newmessageController,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(onPressed: (){
                    firebaseDatabase.child('Info').child(key.substring(1,key.length-1)).update(
                        {'text': _newmessageController.text}).then((result){
                      print('Success');
                      Navigator.of(context).pop();
                    }).catchError((error){
                      print('Error');
                    });
                  }, child: Text('Ok'))
                ],
              );
            }

            );

          });


        }),
        FocusedMenuItem(title: Text("Delete"),trailingIcon: Icon(Icons.delete) ,backgroundColor: Colors.redAccent ,onPressed: (){
          print(widget.message);
          FirebaseDatabase.instance.reference().child('Info')
              .orderByChild('text')
              .equalTo(widget.message).once()
              .then((onValue) {
            Map data = onValue.value;
            print(data);
            var key= data.keys.toString();
            print(key.substring(1,key.length-1));
            firebaseDatabase.child('Info').child(key.substring(1,key.length-1)).remove();
          });
        }),

      ],
      child: Padding(
          padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[350]!,
                            blurRadius: 2.0,
                            offset: Offset(0, 1.0))
                      ],
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white),
                  child: MaterialButton(
                      disabledTextColor: Colors.black87,
                      padding: EdgeInsets.only(left: 18),
                      onPressed: null,
                      child: Wrap(
                        children: <Widget>[
                          Container(
                              child: Row(
                                children: [
                                  Text(widget.message),
                                ],
                              )),
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      DateFormat('yyyy-MM-dd, kk:mma').format(widget.date).toString(),
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          )),
    );
  }
}