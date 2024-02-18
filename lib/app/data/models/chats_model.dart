class TestChats {
  List<String>? connections;

  List<Chat>? chat;
  String? lastTime;

  TestChats({this.connections, this.chat, this.lastTime});

  TestChats.fromJson(Map<String, dynamic> json) {
    connections = json['connections']?.cast<String>();

    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat?.add(Chat.fromJson(v));
      });
    }
    lastTime = json['lastTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connections'] = connections;

    if (chat != null) {
      data['chat'] = chat?.map((v) => v.toJson()).toList();
    }
    data['lastTime'] = lastTime;
    return data;
  }
}

class Chat {
  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  Chat({this.pengirim, this.penerima, this.pesan, this.time, this.isRead});

  Chat.fromJson(Map<String, dynamic> json) {
    pengirim = json['pengirim'];
    penerima = json['penerima'];
    pesan = json['pesan'];
    time = json['time'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pengirim'] = pengirim;
    data['penerima'] = penerima;
    data['pesan'] = pesan;
    data['time'] = time;
    data['isRead'] = isRead;
    return data;
  }
}
