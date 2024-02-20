import 'package:chatapp/app/data/models/users_model.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  TextEditingController nisnC = TextEditingController();
  TextEditingController pwC = TextEditingController();

  final isSkipIntro = false.obs;
  final isLoading = false.obs;
  final isAuth = false.obs;
  RxBool mode = false.obs;
  RxInt pageIndex = 0.obs;

  UserCredential? userCredential;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = UsersModel().obs;
  final friendUser = UsersModel().obs;

  Future<void> firstInitializes() async {
    await autoLogin().then(
      (value) {
        if (value) {
          isAuth.value = true;
        }
      },
    );

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
    update();
  }

  Future<bool> skipIntro() async {
    final box = GetStorage();
    if (box.read("skipIntro") != null) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    try {
      final uid = GetStorage().read("uid");
      print("NISNNNNNN");
      print(uid);

      if (uid != null) {
        CollectionReference users = firestore.collection("siswa");

        await users.doc(uid).update({
          "lastSignInTime": DateTime.now().toIso8601String(),
        });

        final currUser = await users.doc(uid).get();
        final currUserData = currUser.data() as Map<String, dynamic>;
        print(currUserData);

        user(UsersModel.fromJson(currUserData));
        user.refresh();
        final listChats = await users.doc(uid).collection("chats").get();
        if (listChats.docs.length != 0) {
          List<ChatsUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatsUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }
        user.refresh();
        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> login() async {
    try {
      if (nisnC.text.isNotEmpty && pwC.text.isNotEmpty) {
        isLoading.value = true;

        CollectionReference siswa = firestore.collection("siswa");
        final checkSiswa =
            await siswa.where('nisn', isEqualTo: nisnC.text).get();

        if (checkSiswa.docs.isNotEmpty) {
          var dataSiswa = checkSiswa.docs.first.data() as Map<String, dynamic>;
          if (dataSiswa['password'] == pwC.text) {
            await siswa.doc(dataSiswa['uid']).update({
              "lastSignInTime": DateTime.now().toIso8601String(),
            });

            // SIMPAN STATUS USER BAHWA SUDAH PERNAH LOGIN DAN TIDAK AKAN MENAMPiLKAN INTRODUCTION KEMBALI
            final box = GetStorage();
            if (box.read("skipIntro") != null) {
              box.remove("skipIntro");
            }
            box.write("skipIntro", true);
            box.write("uid", dataSiswa['uid']);

            final currUser = await siswa.doc(dataSiswa['uid']).get();
            final currUserData = currUser.data() as Map<String, dynamic>;

            user(UsersModel.fromJson(currUserData));

            user.refresh();
            final listChats =
                await siswa.doc(dataSiswa['uid']).collection("chats").get();
            // print(listChats.docs);
            if (listChats.docs.length != 0) {
              List<ChatsUser> dataListChats = [];
              listChats.docs.forEach((element) {
                var dataDocChat = element.data();
                var dataDocChatId = element.id;
                print(element.id);
                dataListChats.add(ChatsUser(
                  chatId: dataDocChatId,
                  connection: dataDocChat["connection"],
                  lastTime: dataDocChat["lastTime"],
                  total_unread: dataDocChat["total_unread"],
                ));
                print("sbdhbh");
                // print(dataDocChatId);
              });
              user.update((user) {
                user!.chats = dataListChats;
              });
            } else {
              user.update((user) {
                user!.chats = [];
              });
            }
            user.refresh();
            isAuth.value = true;
            isLoading.value = false;
            // print(isLoading);
            Get.offAllNamed(Routes.PRESENSI_SISWA);
          } else {
            Get.snackbar("Terjadi esalahan", "ppppp");
          }
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Terjadi esalahan", "Nisn dan password wajib diisi");
      }

      // masukan data ke firebase
    } catch (error) {
      isLoading.value = false;
      print(error);
    }
  }

  void logout() {
    GetStorage().remove('uid');
    Get.toNamed(Routes.LOGIN);
  }

// profile
  void changeProfile(
    String nama,
    String status,
  ) {
    String date = DateTime.now().toIso8601String();
    final uid = GetStorage().read("uid");
    // update firebase
    CollectionReference users = firestore.collection("siswa");

    users.doc(uid).update({
      "name": nama,
      "keyName": nama.substring(0, 1).toUpperCase(),
      "status": status,
      "updateTime": date,
      "lastSignInTime": date,
    });

    // update model
    user.update((data) {
      data!.name = nama;
      data.keyName = nama.substring(0, 1).toUpperCase();
      data.status = status;
      data.lastSignInTime = date;
      data.updatedTime = date;
    });

    user.refresh();
    Get.snackbar("Update data", "update data berhasil",
        duration: Duration(seconds: 2));
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    final uid = GetStorage().read("uid");
    CollectionReference users = firestore.collection("users");

    users.doc(uid).update({
      "status": status,
      "lastSignInTime": date,
    });

    // update model
    user.update((data) {
      data!.status = status;
      data.lastSignInTime = date;
      data.updatedTime = date;
    });

    user.refresh();
    Get.snackbar("Success", "update status berhasil",
        backgroundColor: Colors.white,
        colorText: Colors.black,
        duration: Duration(seconds: 2));
  }

  void updatePhotoUrl(String url) async {
    String date = DateTime.now().toIso8601String();
    final uid = GetStorage().read("uid");
    CollectionReference siswa = firestore.collection("siswa");

    await siswa.doc(uid).update({
      "photoUrl": url,
      "updatedTime": date,
    });

    // update model
    user.update((data) {
      data!.photoUrl = url;
      data.updatedTime = date;
    });

    user.refresh();
    Get.snackbar("Success", "Foto Profile Berhasil Di update",
        duration: Duration(seconds: 2));
  }

//  SEARCH
  void addNewConnection(String friendUid) async {
    final uid = GetStorage().read("uid");
    bool flagNewConnection = false;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference siswa = firestore.collection("siswa");
    var chatId;
    final docChats = await siswa.doc(uid).collection("chats").get();

    if (docChats.docs.length != 0) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await siswa
          .doc(uid)
          .collection("chats")
          .where("connection", isEqualTo: friendUid)
          .get();

      if (checkConnection.docs.length != 0) {
        // sudah pernah buat koneksi dengan friendUid
        flagNewConnection = false;
        chatId = checkConnection.docs[0].id;
      } else {
        // belum pernah chat siapa pun
        flagNewConnection = true;
      }
    } else {
      // belum pernah chat siapa pun
      flagNewConnection = true;
    }
    // FIXXING COLECTION CHAT

    if (flagNewConnection) {
      final chatDocs = await chats.where("connection", whereIn: [
        [
          uid,
          friendUid,
        ],
        [
          friendUid,
          uid,
        ],
      ]).get();

      if (chatDocs.docs.length != 0) {
        // terdapat data chats
        final chatDataId = chatDocs.docs[0].id;
        final chatsData = chatDocs.docs[0].data() as Map<String, dynamic>;

        await siswa.doc(uid).collection("chats").doc(chatDataId).set({
          "connection": friendUid,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats = await siswa.doc(uid).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatsUser> dataListChats = List<ChatsUser>.empty().toList();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatsUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = chatDataId;
        user.refresh();
      } else {
        // buat baru chats(belum ada koneksi )
        final newChatDoc = await chats.add({
          "connection": [
            uid,
            friendUid,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await siswa.doc(uid).collection("chats").doc(newChatDoc.id).set({
          "connection": friendUid,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats = await siswa.doc(uid).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatsUser> dataListChats = List<ChatsUser>.empty().toList();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            print("DATATTATATTAT");
            print(dataListChats);
            print(dataDocChatId);
            print(dataDocChat);
            dataListChats.add(ChatsUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chatId = newChatDoc.id;
        user.refresh();
      }
    }

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

    await siswa.doc(uid).collection("chats").doc(chatId).update({
      "total_unread": 0,
    });
    Get.toNamed(Routes.CHAT_ROOM, arguments: {
      "chat_id": "$chatId",
      "friendUid": friendUid,
      "friendUserModel": friendUser.value,
    });
  }

  void toggleDark() {
    mode.toggle();
    GetStorage().write("darkMode", mode.value);
  }

  void changePage(i) {
    switch (i) {
      case 1:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PRESENSI_SISWA);
    }
  }
}
