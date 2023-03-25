import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'messages.dart';

class AgenPage {
  static var dataTampilan;
  AgenPage() {
    //measure
    ReadyBehaviour();
    //SendBehaviour();
    ResponsBehaviour();
  }
  setDataTampilan(data) async {
    dataTampilan = await data;
  }

  receiverTampilan() async {
    return await dataTampilan;
  }

  ResponsBehaviour() async {
    Messages msg = Messages();
    var data = await msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == String) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == List<dynamic>) {
          await setDataTampilan(data);
        }
        if (data.runtimeType == List<List<dynamic>>) {
          await setDataTampilan(data);
        }
      } catch (error) {
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
        print("here");
        print(data);
        if (data[0][0] == "Application Setting Ready") {
          if (data[2][0] == "pagi") {
            if (data[1][0].length != 0 && data[1][0] != "nothing") {
              print("masuk");
              print(data[1][0][1]);
              var object2 = data[1][0][2]
                  .toString()
                  .substring(10, data[1][0][2].length - 2);
              var object1 = data[1][0][1]
                  .toString()
                  .substring(10, data[1][0][1].length - 2);
              print("rusak");
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.grey,
                ),
                home: HomePage(data[1][0][0], ObjectId.parse(object1),
                    ObjectId.parse(object2)),
              ));
            } else {
              print("Morning!");
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.grey,
                ),
                home: Login(),
              ));
            }
          } else {
            print(data);

            if (data[1][0].length != 0 && data[1][0] != "nothing") {
              var object2 = data[1][0][2]
                  .toString()
                  .substring(10, data[1][0][2].length - 2);
              var object1 = data[1][0][1]
                  .toString()
                  .substring(10, data[1][0][1].length - 2);
              print("Night!");
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.grey,
                ),
                home: HomePage(data[1][0][0], ObjectId.parse(object1),
                    ObjectId.parse(object2)),
              ));
            } else {
              runApp(MaterialApp(
                title: 'Navigation Basics',
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.grey,
                ),
                home: Login(),
              ));
            }
          }
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }
}
