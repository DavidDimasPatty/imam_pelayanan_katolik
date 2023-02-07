import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'messages.dart';

class AgenAkun {
  AgenAkun() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    print(data.runtimeType);
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari user") {
            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection
                .find({'email': data[1][0], 'password': data[2][0]})
                .toList()
                .then((result) async {
                  if (result != 0) {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                    final directory = await getApplicationDocumentsDirectory();
                    var path = directory.path;

                    if (await File('$path/loginImam.txt').exists()) {
                      final file = await File('$path/loginImam.txt');
                      print("found file");
                      print(result[0]['name']);
                      await file.writeAsString(result[0]['name']);
                      await file.writeAsString(
                          '\n' + result[0]['_id'].toString(),
                          mode: FileMode.append);

                      await file.writeAsString(
                          '\n' + result[0]['idGereja'].toString(),
                          mode: FileMode.append);
                    } else {
                      print("file not found");
                      final file = await File('$path/loginImam.txt')
                          .create(recursive: true);
                      await file.writeAsString(result[0]['name']);
                      await file.writeAsString(
                          '\n' + result[0]['_id'].toString(),
                          mode: FileMode.append);

                      await file.writeAsString(
                          '\n' + result[0]['idGereja'].toString(),
                          mode: FileMode.append);
                    }
                  } else {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  }
                });
          }

          if (data[0][0] == "ganti Status") {
            var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            // print("tessssssssterrr");
            // print(data[2][0].toString());
            // print(data[2][0].runtimeType);
            try {
              // if (data[2][0] == 0) {
              //   data[2][0] = 1;
              // } else {
              //   data[2][0] = 0;
              // }
              var update = await imamCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('statusPemberkatan', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }

          if (data[0][0] == "edit Profile") {
            var gerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);

            var update = await gerejaCollection
                .updateOne(
                    where.eq('_id', data[1][0]),
                    modify
                        .set('nama', data[2][0])
                        .set('address', data[3][0])
                        .set('paroki', data[4][0])
                        .set('lingkungan', data[5][0])
                        .set('deskripsi', data[6][0]))
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent("oke");
              await msg.send();
            });
            ;
          }

          if (data[0][0] == "data Gereja") {
            var gerejaCollection =
                MongoDatabase.db.collection(GEREJA_COLLECTION);
            var conn = await gerejaCollection
                .find({'_id': data[1][0]})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari data user") {
            var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await imamCollection
                .find({'_id': data[1][0]})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "update Notif") {
            var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await imamCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('notif', data[2][0]))
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent("oke");
              await msg.send();
            });
          }

          if (data[0][0] == "find Password") {
            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection
                .find({'_id': data[1][0], 'password': data[2][0]}).toList();
            try {
              print(conn[0]['_id']);
              if (conn[0]['_id'] == null) {
                msg.addReceiver("agenPage");
                msg.setContent("not");
                await msg.send();
              } else {
                msg.addReceiver("agenPage");
                msg.setContent("found");
                await msg.send();
              }
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent("not");
              await msg.send();
            }
          }

          if (data[0][0] == "ganti Password") {
            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('password', data[2][0]))
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent("oke");
              await msg.send();
            });
          }

          if (data[0][0] == "change Picture") {
            DateTime now = new DateTime.now();
            DateTime date = new DateTime(
                now.year, now.month, now.day, now.hour, now.minute, now.second);
            final filename = date.toString();
            final destination = 'files/$filename';
            UploadTask? task = FirebaseApi.uploadFile(destination, data[2][0]);
            final snapshot = await task!.whenComplete(() {});
            final urlDownload = await snapshot.ref.getDownloadURL();

            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('picture', urlDownload))
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent("oke");
              await msg.send();
            });
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Akun Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
