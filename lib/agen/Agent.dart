import 'dart:async';

import 'package:imam_pelayanan_katolik/agen/Goals.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Plan.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';

import 'Message.dart';

abstract class Agent {
  ////////////////////////////Inisialisasi Variabel//////////////////////////////////

  List<Plan> //nama agen
      plan = [];
  List<Goals> //Perencanaan agen
      goals = [];
  List Messages = [];
  List Senders = [];
  String agentName = "";
  bool stop = false;
/////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
////////////////////////////////////Fungsi Agen////////////////////////////////////

  int canPerformTask(Message message) {
    //Fungsi untuk melakukan pengecekan pada plan agen terhadap
    //tugas yang berada dalam pesan

    if (message.task.action == "error") {
      print(this.agentName + " get error messages");
      //Jika terdapat pesan error dari agen lain
      return -2;
    } else {
      for (var p in plan) {
        if (p.goals == message.task.action && p.protocol == message.protocol) {
          //Jika bisa mengerjakan tugas
          return 1;
        }
      }
    }
    return -1;
  }

  Future<dynamic> receiveMessage(Message msg, String sender) {
    //Fungsi agen menerima pesan yang dikirim oleh agen pengirim
    print(agentName + ' received message from $sender');
    //Menambahkan pesan dan nama pengirim ke variabel
    Messages.add(msg);
    Senders.add(sender);
    //Mengembalikan fungsi performTask
    return performTask();
  }

  Future<dynamic> performTask() async {
    //Fungsi agen mengerjakan tugas yang berada dalam pesan
    Message msgCome = Messages.last;
    String sender = Senders.last;
    dynamic task = msgCome.task;
    //Mengektifitaskan pemanggilan variabel

    var goalsQuest =
        goals.where((element) => element.request == task.action).toList();
    int clock = (goalsQuest[0].time) as int;
    //Mendapatkan batas waktu pengerjaan dalam goals terhadap tugas

    Timer timer = Timer.periodic(Duration(seconds: clock), (timer) {
      stop = true;
      print(clock);
      timer.cancel(); //memberhentikan timer
      addEstimatedTime(
          task.action); //menambahkan waktu pengerjaan terhadap tugas tersebut
      MessagePassing messagePassing =
          MessagePassing(); //Memanggil distributor pesan
      Message msg = overTime(msgCome, sender); //Mengirim pesan overtime
      messagePassing.sendMessage(msg);
    });
//Timer pengerjaan tugas agen

    Message message;
    try {
      message = await action(task.action, msgCome,
          sender); //Memanggil fungsi action untuk memilih tindakan yang dikerjakan
      //Memanggil fungsi action untuk memilih tindakan yang dikerjakan
    } catch (e) {
      message = Message(
          agentName, sender, "INFORM", Tasks('lack of parameters', "failed"));
      //Jika terdapat error dalam pengerjaan maka pesan gagal
    }

    if (stop == false) {
      if (timer.isActive) {
        //Jika timer masih menyala
        timer.cancel();
        //Memberhentikan timer
        bool checkGoals = false;
        if (message.task.data.runtimeType == String &&
            message.task.data == "failed") {
          //Jika hasil pengerjaan gagal
          MessagePassing messagePassing =
              MessagePassing(); //Memanggil distributor pesan
          Message msg = rejectTask(msgCome, sender); //agen menolak tugas
          return messagePassing.sendMessage(msg);
        } else {
          //Jika hasil pengerjaan tidak gagal
          for (var g in goals) {
            if (g.request == task.action &&
                g.goals == message.task.data.runtimeType) {
              //Dicek apakah goal terhadap tugas (tipe data) sudah cocok
              checkGoals = true;
              break;
            }
          }

          if (message.task.action == "done") {
            //Jika merupakan hasil tugas koordinasi dengan agen lain

            print(agentName +
                " Success doing coordination with another agent for task ${task.action}");
            return null; //Tidak mengirimkan apa apa
          } else if (checkGoals == true) {
            //Jika goal tugas agen sama dengan goal pengerjaan
            print(agentName + ' returning data to ${message.receiver}');
            MessagePassing messagePassing =
                MessagePassing(); //Memanggil distributor pesan
            return messagePassing.sendMessage(message); //pesan dikirim ke agen
          } else if (checkGoals == false) {
            //jika tidak sama dengan goal tugas agen
            MessagePassing messagePassing =
                MessagePassing(); //Memanggil distributor pesan
            Message msg = failedGoal(msgCome, sender);
            return messagePassing.sendMessage(msg);
          }
        }
      }
    }
  }

  Message rejectTask(dynamic task, sender) {
    //Fungsi untuk membuat pesan agen tidak mampu melakukan pengerjaan
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
    //Fungsi untuk membuat pesan agen melewati batas waktu pengerjaan goals
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

  Message failedGoal(dynamic task, sender) {
    //Fungsi untuk membuat pesan penolakan terhadap pesan agen
    Message message =
        Message(agentName, sender, "INFORM", Tasks('error', 'failed'));

    print(agentName +
        " rejecting task from $sender because the result of ${task.task.action} dataType does'nt suit the goal from ${agentName}");
    return message;
  }

  action(String goals, dynamic data,
      String sender); //aksi yang dilakukan masing-masing agen
  addEstimatedTime(String goals); //penambahan waktu dari goals tugas agen
}
////////////////////////////Batas Akhir Fungsi Agen///////////////////////////////////////////////
