import 'dart:async';
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
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "login": _estimatedTime,
    "edit status": _estimatedTime,
    "edit profile gereja": _estimatedTime,
    "edit profile imam": _estimatedTime,
    "cari data imam": _estimatedTime,
    "update notification": _estimatedTime,
    "find password": _estimatedTime,
    "change password": _estimatedTime,
    "change profile picture": _estimatedTime,
    "cari profile": _estimatedTime,
    "cari data gereja": _estimatedTime,
    "cari data aturan pelayanan": _estimatedTime,
    "cari jumlah": _estimatedTime,
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Message> action(String goals, dynamic data, String sender) async {
    //Daftar fungsi tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "login":
        return _login(data.task.data, sender);
      case "edit status":
        return _changeStatus(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      case "cari data gereja":
        return _cariProfileGereja(data.task.data, sender);
      case "edit profile gereja":
        return _EditProfileGereja(data.task.data, sender);
      case "edit profile imam":
        return _EditProfileImam(data.task.data, sender);
      case "cari data imam":
        return _cariDataImam(data.task.data, sender);
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
    final pipeliner =
        AggregationPipelineBuilder().addStage(Lookup(from: 'Gereja', localField: 'idGereja', foreignField: '_id', as: 'userGereja')).addStage(Match(where.eq('_id', data[1]).map['\$query'])).build();
    //Melakukan join dengan collection Gereja dan imam
    var conn = await imamCollection.aggregateToStream(pipeliner).toList();
    //Mendapatkan data dari join
    Completer<void> completer = Completer<void>();
    Message message2 = Message(sender, 'Agent Pencarian', "REQUEST", Tasks("cari jumlah", [data[0], data[1], conn, data[2]]));
    //Membuat pesan kepada agen Pencarian
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message2);
    Message message = Message(agentName, sender, "INFORM", Tasks('done', "Wait agent pencarian"));
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return message;
  }

  Future<Message> _login(dynamic data, String sender) async {
    //Fungsi tindakan yang digunakan saat pengguna login
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'email': data[0], 'password': data[1], 'banned': 0}).toList();
    //Pencarian berdasarkan
    //password dan email
    sendToAgenSetting(conn, agentName);
    //Berkoordinasi dengan agen Setting
    Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  void sendToAgenSetting(dynamic data, String sender) async {
    //Fungsi tindakan yang membuat pesan dengan tugas "save data" untuk dikirim ke agen Setting
    Message message = Message(sender, "Agent Setting", "REQUEST", Tasks('save data', data));
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    messagePassing.sendMessage(message);
  }

  Future<Message> _changeStatus(dynamic data, String sender) async {
    //Fungsi tindakan menganti setatus pelayanan Imam
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

    var update = await imamCollection.updateOne(where.eq('_id', data[0]), modify.set(change, data[1]).set("updatedAt", DateTime.now()));
    //Memperbarui data status dan updatedAt pada collection imam
    if (update.isSuccess) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariProfile(dynamic data, String sender) async {
    //Fungsi tindakan untuk mencari tampilan halaman profile dan berkooperasi dengan
    //agen Pencarian
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    final pipeline5 =
        AggregationPipelineBuilder().addStage(Lookup(from: 'Gereja', localField: 'idGereja', foreignField: '_id', as: 'userGereja')).addStage(Match(where.eq('_id', data[1]).map['\$query'])).build();
    //join pada collection imam dan Gereja berdasarkan id imam
    var conn = await userCollection.aggregateToStream(pipeline5).toList();
    Completer<void> completer = Completer<void>();
    Message message2 = Message(sender, "Agent Pencarian", "REQUEST", Tasks("cari profile", [data[0], data[1], conn]));
    // Membuat pesan dengan tugas "cari profile" untuk dikirim ke agen Pencarian
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message2);

    Message message = Message(agentName, sender, "INFORM", Tasks('done', "Wait agent pencarian"));
    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return message;
  }

  Future<Message> _cariProfileGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var conn = await gerejaCollection.find({'_id': data}).toList();
    //Pencarian pada collection Gereja berdasarkan id
    Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", conn));

    return message;
  }

  Future<Message> _EditProfileGereja(dynamic data, String sender) async {
    var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
    var checkName;
    checkName = await gerejaCollection.find(where.eq('nama', data[1]).ne('_id', data[0])).toList();
    //Check jika nama sudah digunakan

    if (checkName.length > 0) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
      return message;
    }

    if (data[7] == true) {
      //Jika ada perubahan gambar
      var urlDownload = await FirebaseApi.configureUpload('files/Imam Pelayanan Katolik/gereja/', data[6]);
      //Upload ke Firebase
      var update = await gerejaCollection.updateOne(
          where.eq('_id', data[0]),
          modify
              .set('nama', data[1])
              .set('address', data[2])
              .set('paroki', data[3])
              .set('lingkungan', data[4])
              .set('deskripsi', data[5])
              .set("gambar", urlDownload)
              .set("lat", data[8])
              .set("lng", data[9]));
      //Update data Gereja
      if (update.isSuccess) {
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
        return message;
      }
    } else {
      //Jika tidak ada perubahan gambar
      var gerejaCollection = MongoDatabase.db.collection(GEREJA_COLLECTION);
      var update = await gerejaCollection.updateOne(where.eq('_id', data[0]),
          modify.set('nama', data[1]).set('address', data[2]).set('paroki', data[3]).set('lingkungan', data[4]).set('deskripsi', data[5]).set("lat", data[8]).set("lng", data[9]));
      //Update data Gereja
      if (update.isSuccess) {
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
        return message;
      } else {
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
        return message;
      }
    }
  }

  Future<Message> _cariEditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data[1][0]});
    //Pencarian pada collection imam berdasarkan id
    Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", conn));
    return message;
  }

  Future<Message> _EditProfileImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var checkEmail;
    var checkName;
    checkName = await imamCollection.find(where.eq('nama', data[1]).ne('_id', data[0])).toList();

    checkEmail = await imamCollection.find(where.eq('email', data[2]).ne('_id', data[0])).toList();
    if (checkName.length > 0) {
      //Pengecekan jika nama imam sudah digunakan
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "nama"));
      return message;
    } else if (checkEmail.length > 0) {
      //Pengecekan jika email imam sudah digunakan
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "email"));
      return message;
    }
    var update = await imamCollection.updateOne(where.eq('_id', data[0]), modify.set('nama', data[1]).set('email', data[2]).set('notelp', data[3]));
    //Update pada collection imam
    if (update.isSuccess) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariDataImam(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await imamCollection.find({'_id': data}).toList();
    //Pencarian pada collection imam berdasarkan id
    Message message = Message(agentName, sender, "INFORM", Tasks('status modifikasi/ pencarian data akun', conn));
    return message;
  }

  Future<Message> _updateNotification(dynamic data, String sender) async {
    var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var update = await imamCollection.updateOne(where.eq('_id', data[0]), modify.set('notif', data[1]));
    if (update.isSuccess) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "oke"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "failed"));
      return message;
    }
  }

  Future<Message> _cariPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.find({'_id': data[0], 'password': data[1]}).toList();
    //Pencarian pada collection imam berdasarkan id dan password
    try {
      if (conn[0]['_id'] == null) {
        //Jika tidak ditemukan
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
        return message;
      } else {
        //Jika ditemukan
        Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
        return message;
      }
    } catch (e) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    }
  }

  Future<Message> _gantiPassword(dynamic data, String sender) async {
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('password', data[1]));
    //Memperbarui data password pada collection imam
    if (conn.isSuccess) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
      return message;
    }
  }

  Future<Message> _changeProfilePicture(dynamic data, String sender) async {
    var urlDownload = await FirebaseApi.configureUpload('files/Imam Pelayanan Katolik/imam/', data[1]);
    //Upload ke firebase
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
    var conn = await userCollection.updateOne(where.eq('_id', data[0]), modify.set('picture', urlDownload));
    //Memperbarui data picture pada collection imam berdasarkan id
    if (conn.isSuccess) {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "not"));
      return message;
    } else {
      Message message = Message(agentName, sender, "INFORM", Tasks("status modifikasi/ pencarian data akun", "found"));
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
    agentName = "Agent Akun";
    //nama agen
    plan = [
      Plan("login", "REQUEST"),
      Plan("edit status", "REQUEST"),
      Plan("edit profile gereja", "REQUEST"),
      Plan("edit profile imam", "REQUEST"),
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
    //Perencanaan agen
    goals = [
      Goals("login", List<Map<String, Object?>>, _timeAction["login"]),
      Goals("edit status", String, _timeAction["edit status"]),
      Goals("edit profile gereja", String, _timeAction["edit profile gereja"]),
      Goals("edit profile imam", String, _timeAction["edit profile imam"]),
      Goals("cari data imam", List<Map<String, Object?>>, _timeAction["cari data imam"]),
      Goals("update notification", String, _timeAction["update notification"]),
      Goals("find password", String, _timeAction["find password"]),
      Goals("cari jumlah", String, _timeAction["cari jumlah"]),
      Goals("change password", String, _timeAction["change password"]),
      Goals("change profile picture", String, _timeAction["change profile picture"]),
      Goals("cari profile", List<dynamic>, _timeAction["cari profile"]),
      Goals("cari data gereja", List<Map<String, Object?>>, _timeAction["cari data gereja"]),
      Goals("cari data aturan pelayanan", List<Map<String, Object?>>, _timeAction["cari data aturan pelayanan"]),
    ];
  }
}
