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

                    if (await File('$path/login.txt').exists()) {
                      final file = await File('$path/loginImam.txt');
                      print("found file");
                      print(result[0]['name']);
                      await file.writeAsString(result[0]['name']);
                      await file.writeAsString('\n' + result[0]['email'],
                          mode: FileMode.append);

                      await file.writeAsString(
                          '\n' + result[0]['_id'].toString(),
                          mode: FileMode.append);
                    } else {
                      print("file not found");
                      final file =
                          await File('$path/login.txt').create(recursive: true);
                      await file.writeAsString(result[0]['name']);
                      await file.writeAsString('\n' + result[0]['_id'],
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