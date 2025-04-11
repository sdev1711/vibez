class MessageModel {
  MessageModel({
    required this.read,
    required this.fromId,
    required this.msg,
    required this.sent,
    required this.toId,
    required this.type,
    this.fileName,
  });

  late final String toId;
  late final String msg;
  late final String read;
  late final Type type;
  late final String fromId;
  late final String sent;
   String? fileName;


   MessageModel.fromJson(Map<String, dynamic>json){
    toId= json['toId'].toString();
    msg= json['msg'].toString();
    read= json['read'].toString();
    final typeString = json['type'].toString();
    if (typeString == Type.image.name) {
      type = Type.image;
    } else if (typeString == Type.document.name) {
      type = Type.document;
    } else {
      type = Type.text;
    }
    fromId= json['fromId'].toString();
    sent= json['sent'].toString();
    fileName = json['fileName']?.toString();
  }

  Map<String,dynamic>toJson(){
     final data=<String,dynamic>{};
     data['toId']=toId;
     data['msg']=msg;
     data['read']=read;
     data['type']=type.name;
     data['fromId']=fromId;
     data['sent']=sent;
     if (fileName != null) {
       data['fileName'] = fileName;
     }
     return data;
  }
}
enum Type{text,image,document}