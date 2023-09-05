class Message {
  Message({
    required this.sentTime,
    required this.ToID,
    required this.type,
    required this.SenderId,
    required this.content,
    required this.readTime,
  });
  late final String sentTime;
  late final String ToID;
  late final Type type;
  late final String SenderId;
  late final String content;
  late final String readTime;

  Message.fromJson(Map<String, dynamic> json) {
    sentTime = json['sent_time'].toString();
    ToID = json['ToID'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    SenderId = json['SenderId'].toString();
    content = json['content'].toString();
    readTime = json['read_time '].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sent_time'] = sentTime;
    data['ToID'] = ToID;
    data['type'] = type.name;
    data['SenderId'] = SenderId;
    data['content'] = content;
    data['read_time '] = readTime;
    return data;
  }
}

enum Type { text, image }
