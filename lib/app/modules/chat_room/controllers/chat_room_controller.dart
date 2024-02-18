import 'dart:async';

import 'package:chatapp/app/data/models/chats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  final isShowEmoji = false.obs;
  int total_unread = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late FocusNode focusNote;
  late TextEditingController chatC;
  late ScrollController scrollC;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chatId) {
    CollectionReference chats = firestore.collection("chats");

    return chats.doc(chatId).collection("chat").orderBy("time").snapshots();
  }

  Stream<DocumentSnapshot<dynamic>> streamFriendData(String friendEmail) {
    CollectionReference siswa = firestore.collection("siswa");

    return siswa.doc(friendEmail).snapshots();
  }

  void addEmojiToChat(Emoji emoji) {
    chatC.text = chatC.text + emoji.emoji;
  }

  void deleteEmoji() {
    chatC.text = chatC.text.substring(0, chatC.text.length - 2);
  }

  void newChat(
    String nisn,
    Map<String, dynamic> argument,
    String text,
  ) async {
    if (text != "") {
      CollectionReference chats = firestore.collection("chats");
      CollectionReference siswa = firestore.collection("siswa");
      String date = DateTime.now().toIso8601String();

      await chats.doc(argument["chat_id"]).collection("chat").add({
        "pengirim": nisn,
        "penerima": argument["friendNisn"],
        "msg": text,
        "time": date,
        "isRead": false,
        "groupTime": DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
      });

      Timer(Duration.zero,
          () => scrollC.jumpTo(scrollC.position.maxScrollExtent));

      chatC.clear();
      await siswa
          .doc(nisn)
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": date,
      });

      final checkFriend = await siswa
          .doc(argument["friendNisn"])
          .collection("chats")
          .doc(argument["chat_id"])
          .get();

      if (checkFriend.exists) {
        final checkTotalUnread = await chats
            .doc(argument["chat_id"])
            .collection("chat")
            .where("isRead", isEqualTo: false)
            .where("pengirim", isEqualTo: nisn)
            .get();
        // total unread for friend
        total_unread = checkTotalUnread.docs.length;

        await siswa
            .doc(argument["friendNisn"])
            .collection("chats")
            .doc(argument["chat_id"])
            .update({
          "lastTime": date,
          "total_unread": total_unread,
        });
      } else {
        //create new for friend db

        await siswa
            .doc(argument["friendNisn"])
            .collection("chats")
            .doc(argument["chat_id"])
            .set({
          "connection": nisn,
          "lastTime": date,
          "total_unread": 1,
        });
      }
    }
  }

  @override
  void onInit() {
    chatC = TextEditingController();
    scrollC = ScrollController();
    focusNote = FocusNode();
    focusNote.addListener(() {
      if (focusNote.hasFocus) {
        isShowEmoji.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    scrollC.dispose();
    focusNote.dispose();
    super.onClose();
  }
}
