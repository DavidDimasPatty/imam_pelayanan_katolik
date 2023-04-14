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

  static int _estimatedTime = 5;

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
    Message msgCome = _Message.last;

    String sender = _Sender.last;
    dynamic task = msgCome.task;

    var goalsQuest =
        _goals.where((element) => element.request == task.action).toList();
    int clock = goalsQuest[0].time;

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      timer.cancel();
      _estimatedTime++;
      MessagePassing messagePassing = MessagePassing();
      Message msg = overTime(task, sender);
      messagePassing.sendMessage(msg);
    });

    Message message;
    try {
      message = await action(task.action, msgCome, sender);
    } catch (e) {
      message = Message(
          agentName, sender, "INFORM", Tasks('lack of parameters', "failed"));
    }

    if (stop == false) {
      if (timer.isActive) {
        timer.cancel();
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(msgCome, sender);
          return messagePassing.sendMessage(msg);
        } else {
          for (var g in _goals) {
            if (g.request == task.action &&
                g.goals == message.task.data.runtimeType) {
              checkGoals = true;
              break;
            }
          }

          if (checkGoals == true) {
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing = MessagePassing();
            messagePassing.sendMessage(message);
          } else {
            rejectTask(message, sender);
          }
        }
      }
    }
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "setting user":
        return settingUser(data.task.data, sender);

      case "save data":
        return saveData(data.task.data, sender);

      case "log out":
        return logOut(data.task.data, sender);

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
        "Agent Akun",
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName +
        ' rejected task from $sender because not capable of doing: ${task.task.action} with protocol ${task.protocol}');
    return message;
  }

  Message overTime(dynamic task, sender) {
    Message message = Message(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName +
        ' rejected task from $sender because takes time too long: ${task.task.action}');
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
      Goals("setting user", List<List<dynamic>>, _estimatedTime),
      Goals("log out", String, _estimatedTime),
      Goals("save data", String, _estimatedTime),
    ];
  }
}
