// import 'dart:developer';
// import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:mongo_dart/mongo_dart.dart';
import 'package:path_provider/path_provider.dart';
// import 'messages.dart';

// class AgenSetting {
//   AgenSetting() {
//     ReadyBehaviour();
//     ResponsBehaviour();
//   }

//   var dataSetting;
//   setDataTampilan(data) {
//     dataSetting = data;
//   }

//   receiverTampilan() {
//     return dataSetting;
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data[0][0] == "save data") {
//           final directory = await getApplicationDocumentsDirectory();
//           var path = directory.path;
//           if (await File('$path/loginImam.txt').exists()) {
//             final file = await File('$path/loginImam.txt');
//             print("found file");
//             print(data[1][0][0]);
//             print("nama");
//             print(data[1][0][0]['name']);
//             await file.writeAsString(data[1][0][0]['name']);
//             await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
//                 mode: FileMode.append);

//             await file.writeAsString(
//                 '\n' + data[1][0][0]['idGereja'].toString(),
//                 mode: FileMode.append);
//             print("DONE!!!!!!!!!!!!!");
//           } else {
//             print("file not found");
//             final file =
//                 await File('$path/loginImam.txt').create(recursive: true);
//             await file.writeAsString(data[1][0][0]['name']);
//             await file.writeAsString('\n' + data[1][0][0]['_id'].toString(),
//                 mode: FileMode.append);

//             await file.writeAsString(
//                 '\n' + data[1][0][0]['idGereja'].toString(),
//                 mode: FileMode.append);
//           }
//         }

//         if (data[0][0] == "setting User") {
//           var date = DateTime.now();
//           var hour = date.hour;
//           print(hour);
//           await dotenv.load(fileName: ".env");
//           await Firebase.initializeApp();
//           await MongoDatabase.connect().then((result) async {
//             WidgetsFlutterBinding.ensureInitialized();
//             var res;
//             try {
//               final directory = await getApplicationDocumentsDirectory();
//               var path = directory.path;
//               final file = await File('$path/loginImam.txt');
//               res = await file.readAsLines();
//               print(await res);
//             } catch (e) {
//               print(e);
//               res = "nothing";
//             }
//             if (hour >= 5 && hour <= 17) {
//               await msg.addReceiver("agenPage");
//               await msg.setContent([
//                 ["Application Setting Ready"],
//                 [await res],
//                 ["pagi"]
//               ]);
//               await msg.send();
//             }
//             if (hour >= 18 || hour <= 4) {
//               await msg.addReceiver("agenPage");
//               await msg.setContent([
//                 ["Application Setting Ready"],
//                 [await res],
//                 ["malam"]
//               ]);
//               await msg.send();
//             }
//             // runApp(await MaterialApp(
//             //   title: 'Navigation Basics',
//             //   home: Login(),
//             // ));
//           });
//         }
//         if (data[0][0] == "log out") {
//           final directory = await getApplicationDocumentsDirectory();
//           var path = directory.path;

//           final file = await File('$path/loginImam.txt');
//           await file.writeAsString("");
//           await msg.addReceiver("agenPage");
//           await msg.setContent("oke");
//           await msg.send();
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }

//   ReadyBehaviour() {
//     Messages msg = Messages();
//     var data = msg.receive();
//     action() {
//       try {
//         if (data == "ready") {
//           print("Agen Setting Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';

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
  int _estimatedTime = 10;

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> performTask(Message msg, String sender) async {
    print('Agent Setting received message from $sender');
    dynamic task = msg.task;
    for (var p in _plan) {
      if (p.goals == task.action) {
        Timer timer = Timer.periodic(Duration(seconds: p.time), (timer) {
          stop = true;
          timer.cancel();

          MessagePassing messagePassing = MessagePassing();
          Message msg = rejectTask(task, sender);
          messagePassing.sendMessage(msg);
        });

        Message message = await action(p.goals, task.data, sender);
        print(message.task.data.runtimeType);

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
              for (var g in _goals) {
                if (g.request == p.goals &&
                    g.goals == message.task.data.runtimeType) {
                  checkGoals = true;
                }
              }
              if (checkGoals == true) {
                print('Agent Setting returning data to ${message.receiver}');
                MessagePassing messagePassing = MessagePassing();
                messagePassing.sendMessage(message);
                break;
              } else {
                rejectTask(task, sender);
              }
              break;
            }
          }
        }
      }
    }
  }

  messageSetData(task) {
    pencarianData.add(task);
  }

  Future<List> getDataPencarian() async {
    return pencarianData;
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
          Tasks('status', [
            [await res],
            ["pagi"]
          ]));
      return message;
    } else {
      Message message = Message(
          'Agent Setting',
          sender,
          "INFORM",
          Tasks('status', [
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
    if (await File('$path/loginImam.txt').exists()) {
      final file = await File('$path/loginImam.txt');

      await file.writeAsString(data[0]['name']);
      await file.writeAsString('\n' + data[0]['_id'].toString(),
          mode: FileMode.append);

      await file.writeAsString('\n' + data[0]['idGereja'].toString(),
          mode: FileMode.append);
    } else {
      final file = await File('$path/loginImam.txt').create(recursive: true);
      await file.writeAsString(data[0]['name']);
      await file.writeAsString('\n' + data[0]['_id'].toString(),
          mode: FileMode.append);

      await file.writeAsString('\n' + data[0]['idGereja'].toString(),
          mode: FileMode.append);
    }

    Message message =
        Message('Agent Setting', sender, "INFORM", Tasks('status', "oke"));
    return message;
  }

  Future<Message> logOut(dynamic data, String sender) async {
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    final file = await File('$path/loginImam.txt');
    await file.writeAsString("");

    Message message =
        Message('Agent Setting', sender, "INFORM", Tasks('status', "oke"));
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
      Plan("setting user", "REQUEST", _estimatedTime),
      Plan("log out", "REQUEST", _estimatedTime),
      Plan("save data", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("setting user", List<List<dynamic>>, 12),
      Goals("log out", String, 6),
      Goals("save data", String, 6),
    ];
  }
}
