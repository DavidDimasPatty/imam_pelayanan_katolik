//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/agen/messages.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:mongo_dart/mongo_dart.dart';

//import 'package:geolocator/geolocator.dart';
//import 'package:pelayanan_iman_katolik/login.dart';

// void main() {
//   runApp(MyApp());
// }

Future callDb() async {
  Messages msg = new Messages();
  msg.addReceiver("agenSetting");
  msg.setContent([
    ["setting User"]
  ]);
  await msg.send().then((res) async {});
  await Future.delayed(Duration(seconds: 1));
  var k = await AgenPage().receiverTampilan();
  // print(k);
  return k;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  // Messages msg = new Messages();
  // msg.addReceiver("agenPage");
  // msg.setContent("ready");
  // msg.send();
  // msg.addReceiver("agenPencarian");
  // msg.setContent("ready");
  // msg.send();
  //LocationPermission permission = await Geolocator.checkPermission();
  //print(permission);
  //if (permission == LocationPermission.denied) {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   LocationPermission permission2 = await Geolocator.checkPermission();
  //   print(permission2);
  // }
  //await MongoDatabase.showUser();

  // runApp(MaterialApp(
  //   title: 'Navigation Basics',
  //   home: Login(),
  // ));
  var tampilan = await callDb();

  if (tampilan[1][0] == "pagi") {
    print(tampilan[0][0]);
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
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.grey,

          // Define the default font family.
          // fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
        ),
        home: HomePage(tampilan[0][0][0], ObjectId.parse(object1),
            ObjectId.parse(object2)),
      ));
    } else {
      print("Morning!");
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.grey,

          // Define the default font family.
          // fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
        ),
        home: Login(),
      ));
    }
  } else {
    print(tampilan);

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

          // Define the default font family.
          // fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
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

          // Define the default font family.
          // fontFamily: 'Georgia',

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          //   titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          //   bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          // ),
        ),
        home: Login(),
      ));
    }
  }
}
