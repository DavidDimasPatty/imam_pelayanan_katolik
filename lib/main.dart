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
  //Mengirim pesan untuk settingan aplikasi saat diluncurkan
  Completer<void> completer = Completer<void>();
  Message message = Message('Agent Page', 'Agent Setting', "REQUEST",
      Tasks('setting user', null)); //Pembuatan Pesan

  MessagePassing messagePassing =
      MessagePassing(); //Memanggil distributor pesan
  var data = await messagePassing
      .sendMessage(message); //Mengirim pesan ke distributor pesan
  completer
      .complete(); //Batas pengerjaan yang memerlukan completer //Batas pengerjaan yang memerlukan completer
  // sampai agen Page memiliki data
  var hasil = await await AgentPage
      .getData(); //Memanggil data yang tersedia di agen Page
  await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
  //memiliki nilai //Proses penungguan sudah selesai ketika varibel hasil
  //memiliki nilai
  return hasil; //Mengembalikan variabel hasil
}

callTampilan(tampilan) {
  //Fungsi untuk menampilkan halaman ketika settingan aplikasi sudah beres dan
  ////halaman siap ditampilkan
  if (tampilan[1][0] == "pagi") {
    //Jika data memiliki String pagi
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      //Jika data akun pengguna tersimpan pada lokal file
      var object2 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      var object1 = tampilan[0][0][0]
          .toString()
          .substring(10, tampilan[0][0][0].length - 2);
      //Mendapatkan data id pengguna, role, idGereja yang tersimpan
      // pada lokal file
      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: HomePage(ObjectId.parse(object1), ObjectId.parse(object2),
            int.parse(tampilan[0][0][2])), // Memanggil halaman home dengan
        //parameter variabel object
      ));
    } else {
      //Jika data akun pengguna tidak tersimpan pada lokal file

      runApp(MaterialApp(
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.grey,
        ),
        home: Login(),
      ));
      //Maka akan ditampilkan halaman login
    }
  } else {
    //Jika data memiliki String selain pagi
    if (tampilan[0][0].length != 0 && tampilan[0][0] != "nothing") {
      //Jika data akun pengguna tersimpan pada lokal file
      var object2 = tampilan[0][0][1]
          .toString()
          .substring(10, tampilan[0][0][1].length - 2);
      var object1 = tampilan[0][0][0]
          .toString()
          .substring(10, tampilan[0][0][0].length - 2);
      //Mendapatkan data id pengguna, role, idGereja yang tersimpan
      // pada lokal file
      runApp(MaterialApp(
        //tema aplikasi akan gelap karena malam
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: HomePage(ObjectId.parse(object1), ObjectId.parse(object2),
            int.parse(tampilan[0][0][2])),
        // Memanggil halaman home dengan
        //parameter variabel object
      ));
    } else {
      runApp(MaterialApp(
        //Jika data akun pengguna tidak tersimpan pada lokal file
        title: 'Navigation Basics',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey,
        ),
        home: Login(),
      ));
      //Maka akan ditampilkan halaman login
    }
  }
}

void main() async {
  var tampilan = await callDb(); // Memanggil callDb saat peluncuran aplikasi
  callTampilan(tampilan); // Memanggil callDb saat peluncuran aplikasi
}
