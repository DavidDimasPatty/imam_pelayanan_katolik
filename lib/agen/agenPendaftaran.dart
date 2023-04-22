import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:imam_pelayanan_katolik/DatabaseFolder/modelDB.dart';

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
  static int _estimatedTime = 5;
  static Map<String, int> _timeAction = {
    "add pelayanan": _estimatedTime,
    "add pengumuman": _estimatedTime,
    "edit pelayanan": _estimatedTime,
    "edit pengumuman": _estimatedTime,
    "update status pelayanan": _estimatedTime,
    "update status pengumuman": _estimatedTime,
    "update pelayanan user": _estimatedTime,
    "send FCM": _estimatedTime,
    "edit aturan pelayanan": _estimatedTime,
  };

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update pelayanan user":
        return _updatePelayananUser(data.task.data, sender);
      case "edit pengumuman":
        return _editPengumuman(data.task.data, sender);
      case "add pelayanan":
        return _addPelayanan(data.task.data, sender);
      case "edit pelayanan":
        return _editPelayanan(data.task.data, sender);
      case "edit aturan pelayanan":
        return _EditAturanPelayanan(data.task.data, sender);
      case "add pengumuman":
        return _addPengumuman(data.task.data, sender);
      case "update status pelayanan":
        return _updateStatusPelayanan(data.task.data, sender);
      case "update status pengumuman":
        return _updateStatusPengumuman(data.task.data, sender);
      case "send FCM":
        return _sendFCM(data.task.data, sender);

      default:
        return rejectTask(data, data);
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

  Future<Message> _updatePelayananUser(dynamic data, String sender) async {
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

  Future<Message> _sendFCM(dynamic data, String sender) async {
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

  Future<Message> _editPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

    if (data[4] == true) {
      var urlDownload = await FirebaseApi.configureUpload(
          'files/Imam Pelayanan Katolik/pengumuman/', data[3]);
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

  Future<Message> _addPelayanan(dynamic data, String sender) async {
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

      String urlDownload = await FirebaseApi.configureUpload(
          'files/Imam Pelayanan Katolik/kegiatan umum/', data[11]);
      var configJson = modelDB.umum(
        data[1],
        data[2],
        data[3],
        data[4],
        data[5],
        data[6],
        DateTime.parse(data[7]),
        int.parse(data[8]),
        data[9],
        urlDownload,
        0,
        DateTime.now(),
        data[10],
        DateTime.now(),
        data[10],
      );

      var add = await pelayananCollection.insertOne(configJson);
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
    var configJson = modelDB.Pelayanan(
      data[1],
      int.parse(data[2]),
      DateTime.parse(data[3]),
      DateTime.parse(data[4]),
      0,
      data[6],
      DateTime.now(),
      data[5],
      DateTime.now(),
      data[5],
    );

    var add = await pelayananCollection.insertOne(configJson);
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

  Future<Message> _updateStatusPelayanan(dynamic data, String sender) async {
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

  Future<Message> _updateStatusPengumuman(dynamic data, String sender) async {
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

  Future<Message> _editPelayanan(dynamic data, String sender) async {
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
        var urlDownload = await FirebaseApi.configureUpload(
            'files/Imam Pelayanan Katolik/kegiatan umum/', data[11]);
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

  Future<Message> _addPengumuman(dynamic data, String sender) async {
    var PengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var urlDownload = await FirebaseApi.configureUpload(
        'files/Imam Pelayanan Katolik/pengumuman/', data[1]);

    var configJson = modelDB.gambarGereja(
      data[0],
      urlDownload,
      data[2],
      0,
      data[3],
      DateTime.now(),
      data[4],
      DateTime.now(),
      data[4],
    );
    var add = await PengumumanCollection.insertOne(configJson);
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

  @override
  addEstimatedTime(String goals) {
    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    agentName = "Agent Pendaftaran";
    plan = [
      Plan("add pelayanan", "REQUEST"),
      Plan("add pengumuman", "REQUEST"),
      Plan("edit pelayanan", "REQUEST"),
      Plan("edit pengumuman", "REQUEST"),
      Plan("update status pelayanan", "REQUEST"),
      Plan("update status pengumuman", "REQUEST"),
      Plan("update pelayanan user", "REQUEST"),
      Plan("send FCM", "INFORM"),
      Plan("edit aturan pelayanan", "REQUEST"),
    ];
    goals = [
      Goals("add pelayanan", String, _timeAction["add pelayanan"]),
      Goals("add pengumuman", String, _timeAction["add pengumuman"]),
      Goals("edit pelayanan", String, _timeAction["edit pelayanan"]),
      Goals("edit pengumuman", String, _timeAction["edit pengumuman"]),
      Goals("update status pelayanan", String,
          _timeAction["update status pelayanan"]),
      Goals("update status pengumuman", String,
          _timeAction["update status pengumuman"]),
      Goals("update pelayanan user", String,
          _timeAction["update pelayanan user"]),
      Goals("send FCM", String, _timeAction["send FCM"]),
      Goals("edit aturan pelayanan", String,
          _timeAction["edit aturan pelayanan"]),
    ];
  }
}
