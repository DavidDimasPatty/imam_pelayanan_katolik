//import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future callDb() async {
  Completer<void> completer = Completer<void>();
  Message message = Message(
      'Agent Page', 'Agent Setting', "REQUEST", Tasks('setting user', null));

  MessagePassing messagePassing = MessagePassing();
  var data = await messagePassing.sendMessage(message);
  completer.complete();
  var hasil = await await AgentPage.getDataPencarian();
  return hasil;
}

callTampilan(tampilan) {
  if (tampilan[1][0] == "pagi") {
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      var object2 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      var object1 = tampilan[0][0][0]
          .toString()
          .substring(10, tampilan[0][0][0].length - 2);
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: HomePage(ObjectId.parse(object1), ObjectId.parse(object2),
            int.parse(tampilan[0][0][2])),
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
      print(tampilan);
      var object2 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      var object1 = tampilan[0][0][0]
          .toString()
          .substring(10, tampilan[0][0][0].length - 2);
      print("Night!");
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: HomePage(ObjectId.parse(object1), ObjectId.parse(object2),
            int.parse(tampilan[0][0][2])),
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

void main() async {
  var tampilan = await callDb();
  callTampilan(tampilan);
}
