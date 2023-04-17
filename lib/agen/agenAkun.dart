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

  static int _estimatedTime = 5;

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "login":
        return _login(data.task.data, sender);
      case "edit status":
        return _changeStatus(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      case "cari data gereja":
        return _cariProfileGereja(data.task.data, sender);
      case "cari data aturan pelayanan":
        return _cariDataAturanPelayanan(data.task.data, sender);
      case "edit profile gereja":
        return _EditProfileGereja(data.task.data, sender);
      case "edit profile imam":
        return _EditProfileImam(data.task.data, sender);
      case "edit aturan pelayanan":
        return _EditAturanPelayanan(data.task.data, sender);
      case "cari data imam":
        return _cariDataImam(data.task.data, sender);
      case "update notification":
        return _updateNotification(data.task.data, sender);
      case "find password":
        return _cariPassword(data.task.data, sender);
      case "change password":
        return _gantiPassword(data.task.data, sender);
      case "change profile picture":
        return _changeProfilePicture(data.task.data, sender);
      case "cari jumlah":
        return _cariJumlah(data.task.data, sender);
      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _cariJumlah(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    final pipeliner = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'userGereja'))
        .addStage(Match(where.eq('_id', data[1]).map['\$query']))
        .build();
    var conn = await imamCollection.aggregateToStream(pipeliner).toList();

    Completer<void> completer = Completer<void>();
    Message message2 = Message(sender, 'Agent Pencarian', "REQUEST",
        Tasks("cari jumlah", [data[0], data[1], conn, data[2]]));
    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message2);

    Message message = Message(
        agentName, sender, "INFORM", Tasks('wait', "Wait agent pencarian"));
    // Future.delayed(Duration(seconds: 1));
    completer.complete();

    await completer.future;
    return message;
  }

  Future<Message> _login(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection
        .find({'email': data[0], 'password': data[1], 'banned': 0}).toList();

    sendToAgenSetting(conn, agentName);
    Message message = Message(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  void sendToAgenSetting(dynamic data, String sender) async {
    Message message =
        Message(sender, "Agent Setting", "REQUEST", Tasks('save data', data));
    MessagePassing messagePassing = MessagePassing();
    messagePassing.sendMessage(message);
  }

  Future<Message> _changeStatus(dynamic data, String sender) async {
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
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariProfile(dynamic data, String sender) async {
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
    Completer<void> completer = Completer<void>();
    Message message2 = Message(sender, "Agent Pencarian", "REQUEST",
        Tasks("cari profile", [data[0], data[1], conn]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message2);

    Message message = Message(
        agentName, sender, "INFORM", Tasks('wait', "Wait agent pencarian"));
    // Future.delayed(Duration(seconds: 1));
    completer.complete();

    await completer.future;
    return message;
  }

  Future<Message> _cariProfileGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find({'_id': data}).toList();
    Message message = Message(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));

    return message;
  }

  Future<Message> _cariDataAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    var conn =
        await aturanPelayananCollection.find({'idGereja': data}).toList();
    Message message = Message(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));

    return message;
  }

  Future<Message> _EditProfileGereja(dynamic data, String sender) async {
    if (data[7] == true) {
      var urlDownload = await FirebaseApi.configureUpload(
          'files/Imam Pelayanan Katolik/gereja/', data[6]);
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
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "oke"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "failed"));
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
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "oke"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "failed"));
        return message;
      }
    }
  }

  Future<Message> _EditAturanPelayanan(dynamic data, String sender) async {
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
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariEditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data[1][0]});
    Message message = Message(agentName, sender, "INFORM",
        Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Message> _EditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    var update = await imamCollection.updateOne(
        where.eq('_id', data[0]),
        modify
            .set('name', data[1])
            .set('email', data[2])
            .set('notelp', data[3]));

    if (update.isSuccess) {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariDataImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data}).toList();

    Message message = Message(agentName, sender, "INFORM",
        Tasks('status modifikasi/ pencarian data akun', conn));
    return message;
  }

  Future<Message> _updateNotification(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var update = await imamCollection.updateOne(
        where.eq('_id', data[0]), modify.set('notif', data[1]));
    if (update.isSuccess) {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection
        .find({'_id': data[0], 'password': data[1]}).toList();
    try {
      if (conn[0]['_id'] == null) {
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "not"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM",
            Tasks("status modifikasi/ pencarian data akun", "found"));
        return message;
      }
    } catch (e) {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    }
  }

  Future<Message> _gantiPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', data[0]), modify.set('password', data[1]));
    if (conn.isSuccess) {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  Future<Message> _changeProfilePicture(dynamic data, String sender) async {
    var urlDownload = await FirebaseApi.configureUpload(
        'files/Imam Pelayanan Katolik/imam/', data[1]);
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(
        where.eq('_id', data[0]), modify.set('picture', urlDownload));
    if (conn.isSuccess) {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM",
          Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  @override
  addEstimatedTime() {
    _estimatedTime++;
  }

  _initAgent() {
    agentName = "Agent Akun";
    plan = [
      Plan("login", "REQUEST"),
      Plan("edit status", "REQUEST"),
      Plan("edit profile gereja", "REQUEST"),
      Plan("edit profile imam", "REQUEST"),
      Plan("edit aturan pelayanan", "REQUEST"),
      Plan("cari data imam", "REQUEST"),
      Plan("update notification", "REQUEST"),
      Plan("find password", "REQUEST"),
      Plan("change password", "REQUEST"),
      Plan("change profile picture", "REQUEST"),
      Plan("cari profile", "REQUEST"),
      Plan("cari data gereja", "REQUEST"),
      Plan("cari data aturan pelayanan", "REQUEST"),
      Plan("cari jumlah", "REQUEST"),
    ];
    goals = [
      Goals("login", List<Map<String, Object?>>, _estimatedTime),
      Goals("edit status", String, _estimatedTime),
      Goals("edit profile gereja", String, _estimatedTime),
      Goals("edit profile imam", String, _estimatedTime),
      Goals("edit aturan pelayanan", String, _estimatedTime),
      Goals("cari data imam", List<Map<String, Object?>>, _estimatedTime),
      Goals("update notification", String, _estimatedTime),
      Goals("find password", String, _estimatedTime),
      Goals("cari jumlah", String, _estimatedTime),
      Goals("change password", String, _estimatedTime),
      Goals("change profile picture", String, _estimatedTime),
      Goals("cari profile", List<dynamic>, _estimatedTime),
      Goals("cari data gereja", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari data aturan pelayanan", List<Map<String, Object?>>,
          _estimatedTime),
    ];
  }
}
