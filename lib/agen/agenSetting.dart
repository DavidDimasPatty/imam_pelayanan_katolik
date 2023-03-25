import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'messages.dart';

class AgenSetting {
  AgenSetting() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  var dataSetting;
  setDataTampilan(data) {
    dataSetting = data;
  }

  receiverTampilan() {
    return dataSetting;
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data[0][0] == "save data") {
          final directory = await getApplicationDocumentsDirectory();
          var path = directory.path;
          if (await File('$path/loginImam.txt').exists()) {
            final file = await File('$path/loginImam.txt');
            print("found file");
            print(data[1][0][0]);
            print("nama");
            print(data[1][0][0]['name']);
            await file.writeAsString(data[1][0][0]['name']);
            await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
                mode: FileMode.append);

            await file.writeAsString(
                '\n' + data[1][0][0]['idGereja'].toString(),
                mode: FileMode.append);
            print("DONE!!!!!!!!!!!!!");
          } else {
            print("file not found");
            final file =
                await File('$path/loginImam.txt').create(recursive: true);
            await file.writeAsString(data[1][0][0]['name']);
            await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
                mode: FileMode.append);

            await file.writeAsString(
                '\n' + data[1][0][0]['idGereja'].toString(),
                mode: FileMode.append);
          }
        }

        if (data[0][0] == "setting User") {
          var date = DateTime.now();
          var hour = date.hour;
          print(hour);
          await dotenv.load(fileName: ".env");
          await Firebase.initializeApp();
          await MongoDatabase.connect().then((result) async {
            WidgetsFlutterBinding.ensureInitialized();
            var res;
            try {
              final directory = await getApplicationDocumentsDirectory();
              var path = directory.path;
              final file = await File('$path/loginImam.txt');
              res = await file.readAsLines();
              print(await res);
            } catch (e) {
              print(e);
              res = "nothing";
            }
            if (hour >= 5 && hour <= 17) {
              await msg.addReceiver("agenPage");
              await msg.setContent([
                ["Application Setting Ready"],
                [await res],
                ["pagi"]
              ]);
              await msg.send();
            }
            if (hour >= 18 || hour <= 4) {
              await msg.addReceiver("agenPage");
              await msg.setContent([
                ["Application Setting Ready"],
                [await res],
                ["malam"]
              ]);
              await msg.send();
            }
            // runApp(await MaterialApp(
            //   title: 'Navigation Basics',
            //   home: Login(),
            // ));
          });
        }
        if (data[0][0] == "log out") {
          final directory = await getApplicationDocumentsDirectory();
          var path = directory.path;

          final file = await File('$path/loginImam.txt');
          await file.writeAsString("");
          await msg.addReceiver("agenPage");
          await msg.setContent("oke");
          await msg.send();
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
          print("Agen Setting Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
