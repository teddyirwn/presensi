class UsersModel {
  String? uid;
  String? name;
  String? role;
  Map? position;
  String? address;
  String? keyName;
  String? nisn;
  String? createTime;
  String? lastSignInTime;
  String? photoUrl;
  String? status;
  String? updatedTime;
  List<ChatsUser>? chats;

  UsersModel(
      {this.uid,
      this.name,
      this.role,
      this.position,
      this.address,
      this.keyName,
      this.nisn,
      this.createTime,
      this.lastSignInTime,
      this.photoUrl,
      this.status,
      this.updatedTime,
      this.chats});

  UsersModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    role = json['role'];
    position = json['position'];
    address = json['address'];
    keyName = json['keyName'];
    nisn = json['nisn'];
    createTime = json['createTime'];
    lastSignInTime = json['lastSignInTime'];
    photoUrl = json['photoUrl'];
    status = json['status'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['role'] = role;
    data['position'] = position;
    data['address'] = address;
    data['keyName'] = keyName;
    data['nisn'] = nisn;
    data['createTime'] = createTime;
    data['lastSignInTime'] = lastSignInTime;
    data['photoUrl'] = photoUrl;
    data['status'] = status;
    data['updatedTime'] = updatedTime;

    return data;
  }
}

class ChatsUser {
  String? connection;
  String? chatId;
  String? lastTime;
  int? total_unread;

  ChatsUser({
    this.connection,
    this.chatId,
    this.lastTime,
    this.total_unread,
  });

  ChatsUser.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chat_id'];
    lastTime = json['lastTime'];
    total_unread = json['total_unread'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chat_id'] = chatId;
    data['lastTime'] = lastTime;
    data['total_unread'] = total_unread;
    return data;
  }
}
