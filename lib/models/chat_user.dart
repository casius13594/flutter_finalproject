class ChatUserProfile {
  ChatUserProfile(
      {required this.image,
      required this.birthdate,
      required this.isActive,
      required this.lastSeen,
      required this.name,
      required this.createdAt,
      required this.pushToken,
      required this.email,
      required this.lastMess,
      required this.uid});
  late final String image;
  late final String birthdate;
  late final bool isActive;
  late final String lastSeen;
  late final String name;
  late final String createdAt;
  late final String pushToken;
  late final String email;
  late final String lastMess;
  late final String uid;
  ChatUserProfile.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    birthdate = json['birthdate'] ?? '';
    isActive = json['is_active'] ?? '';
    lastSeen = json['last_seen'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    pushToken = json['push_token'] ?? '';
    email = json['email'] ?? '';
    lastMess = json['lastMess'] ?? '';
    uid = json['uid'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['birthdate'] = birthdate;
    data['is_active'] = isActive;
    data['last_seen'] = lastSeen;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['push_token'] = pushToken;
    data['email'] = email;
    data['lastMess'] = lastMess;
    data['uid'] = uid;
    return data;
  }
}
