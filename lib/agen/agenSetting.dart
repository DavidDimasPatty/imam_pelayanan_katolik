import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import '../view/login.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentSetting extends Agent {
  AgentSetting() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  List _Message = [];
  List _Sender = [];

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Message msg, String sender) {
    print(agentName + ' received message from $sender');
    _Message.add(msg);
    _Sender.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Message msg = _Message.last;
    String sender = _Sender.last;
    dynamic task = msg.task;
    var planQuest =
        _plan.where((element) => element.goals == task.action).toList();
    Plan p = planQuest[0];
    var goalsQuest =
        _goals.where((element) => element.request == p.goals).toList();
    int clock = goalsQuest[0].time;
    Goals goalquest = goalsQuest[0];

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();

      MessagePassing messagePassing = MessagePassing();
      Message msg = rejectTask(task, sender);
      messagePassing.sendMessage(msg);
      return;
    });

    Message message = await action(p.goals, task.data, sender);

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        } else {
          if (goalquest.request == p.goals &&
              goalquest.goals == message.task.data.runtimeType) {
            checkGoals = true;
          }

          if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            messagePassing.sendMessage(message);
          } else {
            rejectTask(task, sender);
          }
        }
      }
    }
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "setting user":
        return settingUser(data, sender);

      case "save data":
        return saveData(data, sender);

      case "log out":
        return logOut(data, sender);

      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> settingUser(dynamic data, String sender) async {
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

  Future<Message> saveData(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;
    print(data);
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

  Future<Message> logOut(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    final file = await File('$path/loginImam.txt');
    await file.writeAsString("");

    Message message = Message(
        'Agent Setting', sender, "INFORM", Tasks('status aplikasi', "oke"));
    return message;
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Setting",
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Setting",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Setting";
    _plan = [
      Plan("setting user", "REQUEST"),
      Plan("log out", "REQUEST"),
      Plan("save data", "REQUEST"),
    ];
    _goals = [
      Goals("setting user", List<List<dynamic>>, 12),
      Goals("log out", String, 6),
      Goals("save data", String, 6),
    ];
  }
}
