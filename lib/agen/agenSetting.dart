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
    _initAgent();
  }

  static int _estimatedTime = 10;
  static Map<String, int> _timeAction = {
    "setting user": _estimatedTime,
    "log out": _estimatedTime,
    "save data": _estimatedTime,
  };
  Future<Message> action(String goals, dynamic data, String sender) async {
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
    var date = DateTime.now();
    var hour = date.hour;

    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    await MongoDatabase.connect();
    WidgetsFlutterBinding.ensureInitialized();
    var res;
    try {
      final directory = await getApplicationDocumentsDirectory();
      var path = directory.path;
      final file = await File('$path/loginImam.txt');
      // await file.writeAsString("");
      res = await file.readAsLines();
    } catch (e) {
      print(e);
      res = "nothing";
    }
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
  }

  Future<Message> _saveData(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    try {
      if (await File('$path/loginImam.txt').exists()) {
        final file = await File('$path/loginImam.txt');

        await file.writeAsString(data[0]['_id'].toString());

        await file.writeAsString('\n' + data[0]['idGereja'].toString(),
            mode: FileMode.append);
        await file.writeAsString('\n' + data[0]['role'].toString(),
            mode: FileMode.append);
      } else {
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
    return message;
  }

  Future<Message> _logOut(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    final file = await File('$path/loginImam.txt');
    await file.writeAsString("");

    Message message = Message(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    agentName = "Agent Setting";
    plan = [
      Plan("setting user", "REQUEST"),
      Plan("log out", "REQUEST"),
      Plan("save data", "REQUEST"),
    ];
    goals = [
      Goals("setting user", List<List<dynamic>>, _timeAction["setting user"]),
      Goals("log out", String, _timeAction["log out"]),
      Goals("save data", String, _timeAction["save data"]),
    ];
  }
}
