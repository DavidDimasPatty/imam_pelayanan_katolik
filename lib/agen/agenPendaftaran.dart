import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/fireBase.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPendaftaran extends Agent {
  AgentPendaftaran() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  List _Message = [];
  static int _estimatedTime = 5;
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
      case "update pelayanan user":
        return updatePelayananUser(data.task.data, sender);
      case "edit pengumuman":
        return editPengumuman(data.task.data, sender);
      case "add pelayanan":
        return addPelayanan(data.task.data, sender);
      case "edit pelayanan":
        return editPelayanan(data.task.data, sender);
      case "add pengumuman":
        return addPengumuman(data.task.data, sender);
      case "update status pelayanan":
        return updateStatusPelayanan(data.task.data, sender);
      case "update status pengumuman":
        return updateStatusPengumuman(data.task.data, sender);
      case "send FCM":
        return sendFCM(data.task.data, sender);

      default:
        return rejectTask(data, data);
    }
  }

  Future<Message> updatePelayananUser(dynamic data, String sender) async {
    var userPelayananCollection;
    if (data[0] == "baptis") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    }
    if (data[0] == "sakramentali") {
      userPelayananCollection =
          MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    }
    if (data[0] == "perkawinan") {
      userPelayananCollection =
          MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    }
    var update = await userPelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set('status', data[4])
            .set('updatedAt', DateTime.now())
            .set("updatedBy", data[5]));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      if (data[6] == true) {
        Message message2 = Message(agentName, 'Agent Pencarian', "REQUEST",
            Tasks('cari pelayanan pendaftaran', data));
        MessagePassing messagePassing = MessagePassing();
        await messagePassing.sendMessage(message2);
      }
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> sendFCM(dynamic data, String sender) async {
    String Pelayanan = "";
    DateTime tanggal = DateTime.now();

    if (data[0][0] == "baptis") {
      Pelayanan = "Baptis";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "komuni") {
      Pelayanan = "Komuni";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "krisma") {
      Pelayanan = "Krisma";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "umum") {
      Pelayanan = "Kegiatan Umum";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "sakramentali") {
      Pelayanan = "Pemberkatan";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "perkawinan") {
      Pelayanan = "Perkawinan";
      tanggal = data[1][0]['tanggal'];
    }

    String status = "";
    String body = "";
    String statusSoon = "";
    String bodySoon = "";
    if (data[0][4] == 1) {
      status = "Permintaan " + Pelayanan + " Diterima";
      body = "Permintaan baptis pada tanggal " +
          tanggal.toString().substring(0, 10) +
          " telah dikonfirmasi";
      statusSoon = "Baptis " + tanggal.toString().substring(0, 10);
      bodySoon = "Besok, Baptis " +
          tanggal.toString().substring(0, 10) +
          " Akan Dilaksakan";
    } else {
      status = "Permintaan" + Pelayanan + "Ditolak";
      body = "Maaf, permintaan " +
          Pelayanan +
          " pada tanggal " +
          tanggal.toString().substring(0, 10) +
          " ditolak";
    }

    String constructFCMPayload(String token) {
      return jsonEncode({
        'to': token,
        'data': {
          'via': 'FlutterFire Cloud Messaging!!!',
        },
        'notification': {
          'title': status,
          'body': body,
        },
      });
    }

    var FCMStatus = 0;
    try {
      if (data[0][4] == 1) {
        String constructFCMPayloadSoon(String token) {
          return jsonEncode({
            'to': token,
            'data': {
              "title": statusSoon,
              "message": bodySoon,
              "isScheduled": "true",
              "scheduledTime": tanggal.subtract(Duration(days: 1)).toString()
            },
          });
        }

        await http
            .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
          },
          body: constructFCMPayloadSoon(data[0][2]),
        )
            .then((value) {
          FCMStatus = value.statusCode;
          print(value.statusCode);
          print("success fcm for soon!");
        });
      }

      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
        },
        body: constructFCMPayload(data[0][2]),
      )
          .then((value) {
        FCMStatus = value.statusCode;
        print(value.statusCode);
      });
    } catch (e) {
      print(e);
    }

    if (FCMStatus == 200) {
      Message message = Message(agentName, "agent Page", "INFORM",
          Tasks('status modifikasi data', "oke"));
      print('FCM request for device sent!');
      return message;
    } else {
      Message message = Message(agentName, "agent Page", "INFORM",
          Tasks('status modifikasi data', "failed"));
      print('FCM request for device failed!');
      return message;
    }
  }

  Future<Message> editPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

    if (data[4] == true) {
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      final filename = date.toString();
      final destination = 'files/Imam Pelayanan Katolik/pengumuman/$filename';
      UploadTask? task = FirebaseApi.uploadFile(destination, data[3]);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      var update = await pengumumanCollection.updateOne(
          where.eq('_id', data[2]),
          modify
              .set('title', data[1])
              .set("caption", data[2])
              .set("gambar", urlDownload));
      if (update.isSuccess) {
        Message message = Message('Agent Pendaftaran', sender, "INFORM",
            Tasks('status modifikasi data', "oke"));
        return message;
      } else {
        Message message = Message('Agent Pendaftaran', sender, "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    } else {
      var update = await pengumumanCollection.updateOne(
          where.eq('_id', data[0]),
          modify.set('title', data[1]).set("caption", data[2]));
      if (update.isSuccess) {
        Message message = Message('Agent Pendaftaran', sender, "INFORM",
            Tasks('status modifikasi data', "oke"));
        return message;
      } else {
        Message message = Message('Agent Pendaftaran', sender, "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }
  }

  Future<Message> addPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    if (data[0] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
      var PengumumanCollection =
          MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      final filename = date.toString();
      final destination =
          'files/Imam Pelayanan Katolik/kegiatan umum/$filename';
      UploadTask? task = FirebaseApi.uploadFile(destination, data[11]);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      var add = await pelayananCollection.insertOne({
        'idGereja': data[1],
        'namaKegiatan': data[2],
        'temaKegiatan': data[3],
        'jenisKegiatan': data[4],
        'deskripsiKegiatan': data[5],
        'tamu': data[6],
        'tanggal': DateTime.parse(data[7]),
        'kapasitas': int.parse(data[8]),
        'lokasi': data[9],
        "picture": urlDownload,
        'status': 0,
        "createdAt": DateTime.now(),
        "createdBy": data[10],
        "updatedAt": DateTime.now(),
        "updatedBy": data[10],
      });
      if (add.isSuccess) {
        Message message = Message(agentName, sender, "INFORM",
            Tasks('status modifikasi data', "oke"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM",
            Tasks('status modifikasi data', "failed"));
        return message;
      }
    }

    var add = await pelayananCollection.insertOne({
      'idGereja': data[1],
      'kapasitas': int.parse(data[2]),
      'jadwalBuka': DateTime.parse(data[3]),
      'jadwalTutup': DateTime.parse(data[4]),
      'status': 0,
      'jenis': data[6],
      "createdAt": DateTime.now(),
      "createdBy": data[5],
      "updatedAt": DateTime.now(),
      "updatedBy": data[5],
    });
    if (add.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> updateStatusPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    if (data[0] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }

    var update = await pelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set('status', data[2])
            .set("updatedAt", DateTime.now())
            .set("updatedBy", data[3]));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> updateStatusPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var update = await pengumumanCollection.updateOne(
        where.eq('_id', data[0]),
        modify
            .set('status', data[1])
            .set("updatedAt", DateTime.now())
            .set("updatedBy", data[2]));

    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> editPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    if (data[0] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
      if (data[12] == true) {
        DateTime now = new DateTime.now();
        DateTime date = new DateTime(
            now.year, now.month, now.day, now.hour, now.minute, now.second);
        final filename = date.toString();
        final destination =
            'files/Imam Pelayanan Katolik/kegiatan umum/$filename';
        UploadTask? task = FirebaseApi.uploadFile(destination, data[11]);
        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        var update = await pelayananCollection.updateOne(
            where.eq('_id', data[1]),
            modify
                .set('namaKegiatan', data[2])
                .set('temaKegiatan', data[3])
                .set("jenisKegiatan", data[4])
                .set("deskripsiKegiatan", data[5])
                .set("tamu", data[6])
                .set("tanggal", DateTime.parse(data[7]))
                .set("kapasitas", int.parse(data[8]))
                .set("lokasi", data[9])
                .set("picture", urlDownload)
                .set("updatedAt", DateTime.now())
                .set("updatedBy", data[10]));

        if (update.isSuccess) {
          Message message = Message(agentName, sender, "INFORM",
              Tasks('status modifikasi data', "oke"));
          return message;
        } else {
          Message message = Message(agentName, sender, "INFORM",
              Tasks('status modifikasi data', "failed"));
          return message;
        }
      } else {
        var update = await pelayananCollection.updateOne(
            where.eq('_id', data[1]),
            modify
                .set('namaKegiatan', data[2])
                .set('temaKegiatan', data[3])
                .set("jenisKegiatan", data[4])
                .set("deskripsiKegiatan", data[5])
                .set("tamu", data[6])
                .set("tanggal", DateTime.parse(data[7]))
                .set("kapasitas", int.parse(data[8]))
                .set("lokasi", data[9])
                .set("updatedAt", DateTime.now())
                .set("updatedBy", data[10]));

        if (update.isSuccess) {
          Message message = Message(agentName, sender, "INFORM",
              Tasks('status modifikasi data', "oke"));
          return message;
        } else {
          Message message = Message(agentName, sender, "INFORM",
              Tasks('status modifikasi data', "failed"));
          return message;
        }
      }
    }

    var update = await pelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set("kapasitas", int.parse(data[2]))
            .set("jenis", data[6])
            .set("jadwalBuka", DateTime.parse(data[3]))
            .set("jadwalTutup", DateTime.parse(data[4]))
            .set("updatedAt", DateTime.now())
            .set("updatedBy", data[5]));
    if (update.isSuccess) {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Message> addPengumuman(dynamic data, String sender) async {
    var PengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/Imam Pelayanan Katolik/pengumuman/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, data[1]);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    var add = await PengumumanCollection.insertOne({
      'idGereja': data[0],
      'gambar': urlDownload,
      'caption': data[2],
      'tanggal': DateTime.now(),
      'status': 0,
      'title': data[3],
      "createdAt": DateTime.now(),
      "createdBy": data[4],
      "updatedAt": DateTime.now(),
      "updatedBy": data[4],
    });

    if (add.isSuccess) {
      Message message = Message('Agent Pendaftaran', sender, "INFORM",
          Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Message message = Message('Agent Pendaftaran', sender, "INFORM",
          Tasks('status modifikasi data', "failed"));
      return message;
    }
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
    this.agentName = "Agent Pendaftaran";
    _plan = [
      Plan("add pelayanan", "REQUEST"),
      Plan("add pengumuman", "REQUEST"),
      Plan("edit pelayanan", "REQUEST"),
      Plan("edit pengumuman", "REQUEST"),
      Plan("update status pelayanan", "REQUEST"),
      Plan("update status pengumuman", "REQUEST"),
      Plan("update pelayanan user", "REQUEST"),
      Plan("send FCM", "INFORM"),
    ];
    _goals = [
      Goals("add pelayanan", String, 2),
      Goals("add pengumuman", String, 2),
      Goals("edit pelayanan", String, 2),
      Goals("edit pengumuman", String, 2),
      Goals("update status pelayanan", String, 2),
      Goals("update status pengumuman", String, 2),
      Goals("update pelayanan user", String, 2),
      Goals("send FCM", String, 4),
    ];
  }
}
