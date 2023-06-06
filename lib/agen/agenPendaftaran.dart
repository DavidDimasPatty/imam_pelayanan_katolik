import 'package:flutter_dotenv/flutter_dotenv.dart';
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

class agenPendaftaran extends Agent {
  agenPendaftaran() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }
  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "add pelayanan": _estimatedTime,
    "edit pelayanan": _estimatedTime,
    "update status pelayanan": _estimatedTime,
    "update pelayanan user": _estimatedTime,
    "send FCM": _estimatedTime,
    "edit aturan pelayanan": _estimatedTime,
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar fungsi tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "update pelayanan user":
        return _updatePelayananUser(data.task.data, sender);
      case "add pelayanan":
        return _addPelayanan(data.task.data, sender);
      case "edit pelayanan":
        return _editPelayanan(data.task.data, sender);
      case "edit aturan pelayanan":
        return _EditAturanPelayanan(data.task.data, sender);
      case "update status pelayanan":
        return _updateStatusPelayanan(data.task.data, sender);
      case "send FCM":
        return _sendFCM(data.task.data, sender);

      default:
        return rejectTask(data, data);
    }
  }

  Future<Messages> _EditAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection = MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);

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
    //Update data aturan pelayanan berdasarkan idGereja
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Messages> _updatePelayananUser(dynamic data, String sender) async {
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    var userPelayananCollection;
    if (data[0] == "Baptis") {
      userPelayananCollection = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    }
    if (data[0] == "Komuni") {
      userPelayananCollection = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    }
    if (data[0] == "Krisma") {
      userPelayananCollection = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    }
    if (data[0] == "Umum") {
      userPelayananCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    }
    if (data[0] == "Pemberkatan") {
      userPelayananCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    }
    if (data[0] == "Perkawinan") {
      userPelayananCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    }
    var update = await userPelayananCollection.updateOne(where.eq('_id', data[1]), modify.set('status', data[4]).set('updatedAt', DateTime.now()).set("updatedBy", data[5]));
    //Melakukan update data pelayanan berdasakran id pelayanan
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      if (data[6] == true) {
        Messages message2 = Messages(agentName, 'Agent Pencarian', "REQUEST", Tasks('cari pelayanan pendaftaran', data));
        MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
        await messagePassing.sendMessage(message2);
      }
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _sendFCM(dynamic data, String sender) async {
    String Pelayanan = "";
    DateTime tanggal = DateTime.now();
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    if (data[0][0] == "Baptis") {
      Pelayanan = "Baptis";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "Komuni") {
      Pelayanan = "Komuni";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "Krisma") {
      Pelayanan = "Krisma";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "Umum") {
      Pelayanan = "Kegiatan Umum";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "Pemberkatan") {
      Pelayanan = "Pemberkatan";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "Perkawinan") {
      Pelayanan = "Perkawinan";
      tanggal = data[1][0]['tanggal'];
    }

    String status = "";
    String body = "";
    var FCMStatus = 0;
    String FCMKEY = dotenv.env['FCM'].toString(); // Mendapatkan key dari FCM

    try {
      if (data[0][4] == 1) {
        status = "Permintaan " + Pelayanan + " Diterima";
        body = "Permintaan baptis pada tanggal " + tanggal.toString().substring(0, 10) + " telah dikonfirmasi";
      } else {
        status = "Permintaan" + Pelayanan + "Ditolak";
        body = "Maaf, permintaan " + Pelayanan + " pada tanggal " + tanggal.toString().substring(0, 10) + " ditolak";
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

      //Mengirim endpoint ke FCM
      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': FCMKEY},
        body: constructFCMPayload(data[0][2]),
      )
          .then((value) {
        FCMStatus = value.statusCode;
      });
    } catch (e) {
      print(e);
    }

    if (FCMStatus == 200) {
      Messages message = Messages(agentName, "agent Page", "INFORM", Tasks('status modifikasi data', "oke"));
      print('FCM request for device sent!');
      return message;
    } else {
      Messages message = Messages(agentName, "agent Page", "INFORM", Tasks('status modifikasi data', "failed"));
      print('FCM request for device failed!');
      return message;
    }
  }

  Future<Messages> _addPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    if (data[0] == "Baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "Komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "Krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "Umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);

      String urlDownload = await FirebaseApi.configureUpload('files/Imam Pelayanan Katolik/kegiatan umum/', data[11]);
      //upload ke firebase kegiatan umum
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
      //Menambahkan data pada collection umum
      if (add.isSuccess) {
        Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
        return message;
      } else {
        Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
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
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _updateStatusPelayanan(dynamic data, String sender) async {
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    var pelayananCollection;
    if (data[0] == "Baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "Komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "Krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "Umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }
    var update = await pelayananCollection.updateOne(where.eq('_id', data[1]), modify.set('status', data[2]).set("updatedAt", DateTime.now()).set("updatedBy", data[3]));
    //Upadate data status pada collection pelayanan
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  Future<Messages> _editPelayanan(dynamic data, String sender) async {
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
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
        //Jika ada perubahan gambar
        var urlDownload = await FirebaseApi.configureUpload('files/Imam Pelayanan Katolik/kegiatan umum/', data[11]);
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
        //update data pada collection umum
        if (update.isSuccess) {
          Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
          return message;
        } else {
          Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
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
        //update data pada collection umum
        if (update.isSuccess) {
          Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
          return message;
        } else {
          Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
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
    //update data pada collection pelayanan
    if (update.isSuccess) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "oke"));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('status modifikasi data', "failed"));
      return message;
    }
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Pendaftaran";
    //nama agen
    plan = [
      Plan("add pelayanan", "REQUEST"),
      Plan("edit pelayanan", "REQUEST"),
      Plan("update status pelayanan", "REQUEST"),
      Plan("update pelayanan user", "REQUEST"),
      Plan("send FCM", "INFORM"),
      Plan("edit aturan pelayanan", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("add pelayanan", String, _timeAction["add pelayanan"]),
      Goals("edit pelayanan", String, _timeAction["edit pelayanan"]),
      Goals("update status pelayanan", String, _timeAction["update status pelayanan"]),
      Goals("update pelayanan user", String, _timeAction["update pelayanan user"]),
      Goals("send FCM", String, _timeAction["send FCM"]),
      Goals("edit aturan pelayanan", String, _timeAction["edit aturan pelayanan"]),
    ];
  }
}
