import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(String uid) {
    return firestore
        .collection('siswa')
        .doc(uid)
        .collection("chats")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String uid) {
    print(uid);
    return firestore.collection('siswa').doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsHistory(String idChats) {
    return firestore
        .collection('chats')
        .doc(idChats)
        .collection("chat")
        .orderBy("time", descending: true)
        .snapshots();
  }

  void goToChatRoom(String chatId, String uid, String friendUid) async {
    CollectionReference chats = firestore.collection('chats');
    CollectionReference users = firestore.collection('siswa');
    final updateStatusChat = await chats
        .doc(chatId)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: uid)
        .get();
    updateStatusChat.docs.forEach((element) async {
      await chats.doc(chatId).collection("chat").doc(element.id).update({
        "isRead": true,
      });
    });

    await users.doc(uid).collection("chats").doc(chatId).update({
      "total_unread": 0,
    });

    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      "chat_id": chatId,
      "friendUid": friendUid,
    });
  }
}
