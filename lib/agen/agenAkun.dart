import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';

class AgentAkun extends Agent {
  AgentAkun() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  List _Message = [];
  List _Sender = [];
  bool stop = false;
  int _estimatedTime = 5;

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
                print('Agent Akun returning data to ${message.receiver}');
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
      case "login":
        return login(data, sender);
      case "edit status":
        return changeStatus(data, sender);
      case "cari profile":
        return cariProfile(data, sender);
      case "cari data gereja":
        return cariProfileGereja(data, sender);
      case "cari data aturan pelayanan":
        return cariDataAturanPelayanan(data, sender);
      case "edit profile gereja":
        return EditProfileGereja(data, sender);
      case "edit profile imam":
        return EditProfileImam(data, sender);
      case "edit aturan pelayanan":
        return EditAturanPelayanan(data, sender);
      case "cari data imam":
        return cariDataImam(data, sender);
      case "update notification":
        return updateNotification(data, sender);
      case "find password":
        return cariPassword(data, sender);
      case "change password":
        return gantiPassword(data, sender);
      case "change profile picture":
        return changeProfilePicture(data, sender);

      default:
        return rejectTask(data, data.sender);
    }
  }

  Future<Message> login(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection
        .find({'email': data[0], 'password': data[1], 'banned': 0}).toList();

    sendToAgenSetting(conn, agentName);
    Message message =
        Message('Agent Akun', sender, "REQUEST", Tasks('save data', conn));
    return message;
  }

  void sendToAgenSetting(dynamic data, String sender) async {
    Message message =
        Message(sender, "Agent Setting", "REQUEST", Tasks('save data', data));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  Future<Message> changeStatus(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    String change = "";
    if (data[2] == "sakramentali") {
      change = "statusPemberkatan";
    }
    if (data[2] == "perminyakan") {
      change = "statusPerminyakan";
    }
    if (data[2] == "tobat") {
      change = "statusTobat";
    }
    if (data[2] == "perkawinan") {
      change = "statusPerkawinan";
    }

    var update = await imamCollection.updateOne(where.eq('_id', data[0]),
        modify.set(change, data[1]).set("updatedAt", DateTime.now()));
    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "oke"));
      return message;
    } else {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "failed"));
      return message;
    }
  }

  Future<Message> cariProfile(dynamic data, String sender) async {
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var userPemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userBaptis',
            localField: '_id',
            foreignField: 'idBaptis',
            as: 'userBaptis'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countKr =
        await userKrismaCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countU =
        await userKegiatanCollection.aggregateToStream(pipeline4).toList();

    var countP =
        await userPemberkatanCollection.find({'idGereja': data[0]}).length;

    var totalB = 0;
    var totalKo = 0;
    var totalKr = 0;
    var totalU = 0;
    for (var i = 0; i < countB.length; i++) {
      if (countB[i]['userBaptis'] != null) {
        for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
          if (countB[i]['userBaptis'][j]['status'] != null) {
            totalB++;
          }
        }
      }
    }

    for (var i = 0; i < countKo.length; i++) {
      if (countKo[i]['userKomuni'] != null) {
        for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
          if (countKo[i]['userKomuni'][j]['status'] != null) {
            totalKo++;
          }
        }
      }
    }

    for (var i = 0; i < countKr.length; i++) {
      if (countKr[i]['userKrisma'] != null) {
        for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
          if (countKr[i]['userKrisma'][j]['status'] != null) {
            totalKr++;
          }
        }
      }
    }

    for (var i = 0; i < countU.length; i++) {
      if (countU[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
          if (countU[i]['userKegiatan'][j]['status'] != null) {
            totalU++;
          }
        }
      }
    }

    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    final pipeline5 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'userGereja'))
        .addStage(Match(where.eq('_id', data[1]).map['\$query']))
        .build();
    var conn = await userCollection.aggregateToStream(pipeline5).toList();

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('data pencarian gereja',
            [conn, totalB + totalKo + countP + totalKr + totalU]));
    return message;
  }

  Future<Message> cariProfileGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find({'_id': data}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));

    return message;
  }

  Future<Message> cariDataAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    var conn =
        await aturanPelayananCollection.find({'idGereja': data}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));

    return message;
  }

  Future<Message> EditProfileGereja(dynamic data, String sender) async {
    if (data[7] == true) {
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      final filename = date.toString();
      final destination = 'files/$filename';
      UploadTask? task = FirebaseApi.uploadFile(destination, data[6]);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

      var update = await gerejaCollection.updateOne(
          where.eq('_id', data[0]),
          modify
              .set('nama', data[1])
              .set('address', data[2])
              .set('paroki', data[3])
              .set('lingkungan', data[4])
              .set('deskripsi', data[5])
              .set("gambar", urlDownload));

      if (update.isSuccess) {
        Message message =
            Message(agentName, sender, "INFORM", Tasks('update', "oke"));
        return message;
      } else {
        Message message =
            Message(agentName, sender, "INFORM", Tasks('update', "failed"));
        return message;
      }
    } else {
      var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);

      var update = await gerejaCollection.updateOne(
          where.eq('_id', data[0]),
          modify
              .set('nama', data[1])
              .set('address', data[2])
              .set('paroki', data[3])
              .set('lingkungan', data[4])
              .set('deskripsi', data[5]));

      if (update.isSuccess) {
        Message message =
            Message(agentName, sender, "INFORM", Tasks('update', "oke"));
        return message;
      } else {
        Message message =
            Message(agentName, sender, "INFORM", Tasks('update', "failed"));
        return message;
      }
    }
  }

  Future<Message> EditAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);

    var update = await aturanPelayananCollection.updateOne(
        where.eq('idGereja', data[0]),
        modify
            .set('baptis', data[1])
            .set('komuni', data[2])
            .set('krisma', data[3])
            .set('perkawinan', data[4])
            .set('perminyakan', data[5])
            .set('tobat', data[6])
            .set('pemberkatan', data[7])
            .set('updatedAt', DateTime.now())
            .set('updatedBy', data[8]));
    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "oke"));
      return message;
    } else {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "failed"));
      return message;
    }
  }

  Future<Message> cariEditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data[1][0]});
    Message message =
        Message('Agent Akun', sender, "INFORM", Tasks('cari', conn));
    return message;
  }

  Future<Message> EditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(
        where.eq('_id', data[0]),
        modify
            .set('name', data[1])
            .set('email', data[2])
            .set('notelp', data[3]));

    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "oke"));
      return message;
    } else {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "failed"));
      return message;
    }
  }

  Future<Message> cariDataImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data}).toList();
    Message message =
        Message('Agent Akun', sender, "INFORM", Tasks('cari', conn));
    return message;
  }

  Future<Message> updateNotification(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var update = await imamCollection.updateOne(
        where.eq('_id', data[0]), modify.set('notif', data[1]));
    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "oke"));
      return message;
    } else {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "failed"));
      return message;
    }
  }

  Future<Message> cariPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection
        .find({'_id': data[0], 'password': data[1]}).toList();
    try {
      if (conn[0]['_id'] == null) {
        Message message =
            Message('Agent Akun', sender, "INFORM", Tasks('cari', "not"));
        return message;
      } else {
        Message message =
            Message('Agent Akun', sender, "INFORM", Tasks('cari', "found"));
        return message;
      }
    } catch (e) {
      Message message =
          Message('Agent Akun', sender, "INFORM", Tasks('cari', "not"));
      return message;
    }
  }

  Future<Message> gantiPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', data[0]), modify.set('password', data[1]));
    if (conn.isSuccess) {
      Message message =
          Message('Agent Akun', sender, "INFORM", Tasks('cari', "not"));
      return message;
    } else {
      Message message =
          Message('Agent Akun', sender, "INFORM", Tasks('cari', "found"));
      return message;
    }
  }

  Future<Message> changeProfilePicture(dynamic data, String sender) async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, data[1]);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', data[0]), modify.set('picture', urlDownload));
    if (conn.isSuccess) {
      Message message =
          Message('Agent Akun', sender, "INFORM", Tasks('cari', "not"));
      return message;
    } else {
      Message message =
          Message('Agent Akun', sender, "INFORM", Tasks('cari', "found"));
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

    print(this.agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Akun",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Akun";
    _plan = [
      Plan("login", "REQUEST", _estimatedTime),
      Plan("edit status", "REQUEST", _estimatedTime),
      Plan("edit profile gereja", "REQUEST", _estimatedTime),
      Plan("edit profile imam", "REQUEST", _estimatedTime),
      Plan("edit aturan pelayanan", "REQUEST", _estimatedTime),
      Plan("cari data imam", "REQUEST", _estimatedTime),
      Plan("update notification", "REQUEST", _estimatedTime),
      Plan("find password", "REQUEST", _estimatedTime),
      Plan("change password", "REQUEST", _estimatedTime),
      Plan("change profile picture", "REQUEST", _estimatedTime),
      Plan("cari profile", "REQUEST", _estimatedTime),
      Plan("cari data gereja", "REQUEST", _estimatedTime),
      Plan("cari data aturan pelayanan", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("login", List<Map<String, Object?>>, 5),
      Goals("edit status", String, 2),
      Goals("edit profile gereja", String, 2),
      Goals("edit profile imam", String, 2),
      Goals("edit aturan pelayanan", String, 2),
      Goals("cari data imam", List<Map<String, Object?>>, 2),
      Goals("update notification", String, 2),
      Goals("find password", String, 2),
      Goals("change password", String, 2),
      Goals("change profile picture", String, 2),
      Goals("cari profile", List<dynamic>, 2),
      Goals("cari data gereja", List<Map<String, Object?>>, 2),
      Goals("cari data aturan pelayanan", List<Map<String, Object?>>, 2),
    ];
  }
}
