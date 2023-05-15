import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 20;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "setting user": _estimatedTime,
    "log out": _estimatedTime,
    "save data": _estimatedTime,
  };
  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Message> action(String goals, dynamic data, String sender) async {
    //Daftar fungsi tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "setting user":
        return _settingUser(data.task.data, sender);

      case "save data":
        return _saveData(data.task.data, sender);

      case "log out":
        return _logOut(data.task.data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _settingUser(dynamic data, String sender) async {
    //Fungsi tindakan untuk mempesiapkan launch aplikasi
    var date = DateTime.now();
    var hour = date.hour;

    await dotenv.load(fileName: ".env"); //mendapatkan variabel pada file .env
    await Firebase.initializeApp(); //Koneksi ke firebase
    await MongoDatabase.connect(); //Koneksi ke mongodb
    WidgetsFlutterBinding.ensureInitialized();
    //Karena aplikasi
    //menunggu berbagai koneksi maka widget ini diperlukan saat aplikasi dipanggil
    var res;
    try {
      //Mendapatkan data pada lokal file
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      final file = await File('$path/loginImam.txt');
      res = await file.readAsLines();
    } catch (e) {
      //jika tidak ada data pada lokal file
      print(e);
      res = "nothing";
    }
    //////////Check waktu saat pengguna membuka aplikasi dan membuat pesan/////////
    if (hour >= 5 && hour <= 17) {
      Message message = Message(
          'Agent Setting',
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["pagi"]
          ]));
      return message;
    } else {
      Message message = Message(
          'Agent Setting',
          sender,
          "INFORM",
          Tasks('status aplikasi', [
            [await res],
            ["malam"]
          ]));
      return message;
    }
    ///////////////////////////////////////////////////////////////////////////
  }

  Future<Message> _saveData(dynamic data, String sender) async {
    //Fungsi tindakan untuk menyimpan data akun pada lokal file
    //
    ///Mendapatkan path ke lokal file aplikasi//////////
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    /////////////////////////////////////////////
    ////
    try {
      if (await File('$path/loginImam.txt').exists()) {
        //Jika terdapat file maka langsung diganti data yang ada
        //dengan data baru
        final file = await File('$path/loginImam.txt');

        await file.writeAsString(data[0]['_id'].toString());

        await file.writeAsString('\n' + data[0]['idGereja'].toString(),
            mode: FileMode.append);
        await file.writeAsString('\n' + data[0]['role'].toString(),
            mode: FileMode.append);
      } else {
        //Jika tidak ada file maka file akan dibuat dan diisi dengan data
        final file = await File('$path/loginImam.txt').create(recursive: true);
        await file.writeAsString(data[0]['_id'].toString());

        await file.writeAsString('\n' + data[0]['idGereja'].toString(),
            mode: FileMode.append);
        await file.writeAsString('\n' + data[0]['role'].toString(),
            mode: FileMode.append);
      }
    } catch (e) {
      Message message = Message('Agent Setting', sender, "INFORM",
          Tasks('status aplikasi', "failed"));
      return message;
    }
    Message message = Message(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    //Membuat pesan berhasil koordinasi dengan agen Akun
    return message;
  }

  Future<Message> _logOut(dynamic data, String sender) async {
    //Fungsi tindakan untuk menghapus data akun pada lokal file
    //
    ///Mendapatkan path ke lokal file aplikasi//////////
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    /////////////////////////////////////////////
    final file = await File('$path/loginImam.txt');
    await file.writeAsString("");

    Message message = Message(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    //Membuat pesan berhasil koordinasi dengan agen Akun
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Setting";
    //nama agen
    plan = [
      Plan("setting user", "REQUEST"),
      Plan("log out", "REQUEST"),
      Plan("save data", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("setting user", List<List<dynamic>>, _timeAction["setting user"]),
      Goals("log out", String, _timeAction["log out"]),
      Goals("save data", String, _timeAction["save data"]),
    ];
  }
}
