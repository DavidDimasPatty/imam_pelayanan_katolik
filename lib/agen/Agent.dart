import 'dart:async';

import 'package:imam_pelayanan_katolik/agen/Goals.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Plan.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';

import 'Message.dart';

abstract class Agent {
  List<Plan> plan = [];
  List<Goals> goals = [];
  List Messages = [];
  List Senders = [];
  String agentName = "";
  bool stop = false;

  bool canPerformTask(dynamic message) {
    for (var p in plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> receiveMessage(Message msg, String sender) {
    print(agentName + ' received message from $sender');
    Messages.add(msg);
    Senders.add(sender);
    return performTask();
  }

  Future<dynamic> performTask() async {
    Message msgCome = Messages.last;
    String sender = Senders.last;
    dynamic task = msgCome.task;

    var goalsQuest =
        goals.where((element) => element.request == task.action).toList();
    int clock = (goalsQuest[0].time) as int;

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      print(clock);
      timer.cancel();
      addEstimatedTime(task.action);
      MessagePassing messagePassing = MessagePassing();
      Message msg = overTime(msgCome, sender);
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
          for (var g in goals) {
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

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        agentName,
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(agentName +
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

    print(agentName +
        ' rejected task from $sender because takes time too long: ${task.task.action}');
    return message;
  }

  action(String goals, dynamic data, String sender);
  addEstimatedTime(String goals);
}
