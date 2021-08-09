class Message{
  String text;
  DateTime date;

  Message(this.text,this.date);


  Message.fromJson(Map<dynamic,dynamic> json):date = DateTime.parse(json['date'] as String),
  text = json['text'] as String;

  Map<dynamic,dynamic> toJson()=> <dynamic,dynamic>{
    'date': date.toString(),
    'text': text,
  };


}

