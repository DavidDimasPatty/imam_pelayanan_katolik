//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/agen/messages.dart';
import 'package:imam_pelayanan_katolik/login.dart';

//import 'package:geolocator/geolocator.dart';
//import 'package:pelayanan_iman_katolik/login.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await MongoDatabase.connect();
  Messages msg = new Messages();
  msg.addReceiver("agenPage");
  msg.setContent("ready");
  msg.send();
  msg.addReceiver("agenPencarian");
  msg.setContent("ready");
  msg.send();
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
}
