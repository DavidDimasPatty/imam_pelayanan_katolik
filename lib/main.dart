//import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:mongo_dart/mongo_dart.dart';

//import 'package:geolocator/geolocator.dart';
//import 'package:pelayanan_iman_katolik/login.dart';

// void main() {
//   runApp(MyApp());
// }

Future callDb() async {
  // Messages msg = new Messages();
  // await msg.addReceiver("agenSetting");
  // await msg.setContent([
  //   ["setting User"]
  // ]);
  // await msg.send().then((res) async {});
  // await Future.delayed(Duration(seconds: 1));
  Completer<void> completer = Completer<void>();
  Message message =
      Message('View', 'Agent Setting', "REQUEST", Tasks('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  completer.complete();
  var hasil = await messagePassing.messageGetToView();
  return hasil;
}

void main() async {
  var tampilan = await callDb();

  if (tampilan[1][0] == "pagi") {
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      var object2 = tampilan[0][0][2]
          .toString()
          .substring(10, tampilan[0][0][2].length - 2);
      var object1 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: HomePage(tampilan[0][0][0], ObjectId.parse(object1),
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
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      var object2 = tampilan[0][0][2]
          .toString()
          .substring(10, tampilan[0][0][2].length - 2);
      var object1 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      print("Night!");
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: HomePage(tampilan[0][0][0], ObjectId.parse(object1),
            ObjectId.parse(object2)),
      ));
    } else {
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: Login(),
      ));
    }
  }
}
