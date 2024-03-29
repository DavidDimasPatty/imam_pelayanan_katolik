import 'dart:async';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'Plan.dart';
import 'Task.dart';

class agenPencarian extends Agent {
  agenPencarian() {
    //Konstruktor agen memanggil fungsi initAgent
    _initAgent();
  }

  static int _estimatedTime = 5;
  //Batas waktu awal pengerjaan seluruh tugas agen
  static Map<String, int> _timeAction = {
    "cari aturan pelayanan": _estimatedTime,
    "cari pelayanan": _estimatedTime,
    "cari pelayanan user": _estimatedTime,
    "cari pelayanan pendaftaran": _estimatedTime,
    "cari data edit pelayanan": _estimatedTime,
    "cari jumlah": _estimatedTime,
    "cari jumlah Sakramen": _estimatedTime,
    "cari jumlah Umum": _estimatedTime,
    "cari profile": _estimatedTime,
  };

  //Daftar batas waktu pengerjaan masing-masing tugas

  Future<Messages> action(String goals, dynamic data, String sender) async {
    //Daftar fungsi tindakan yang bisa dilakukan oleh agen, fungsi ini memilih tindakan
    //berdasarkan tugas yang berada pada isi pesan
    switch (goals) {
      case "cari aturan pelayanan":
        return _cariAturanPelayanan(data.task.data, sender);
      case "cari pelayanan":
        return _cariPelayanan(data.task.data, sender);
      case "cari pelayanan user":
        return _cariPelayananUser(data.task.data, sender);
      case "cari pelayanan pendaftaran":
        return _cariPelayananPendaftaran(data.task.data, sender);
      case "cari data edit pelayanan":
        return _cariEditPelayanan(data.task.data, sender);
      case "cari jumlah":
        return _cariJumlah(data.task.data, sender);
      case "cari jumlah Sakramen":
        return _cariJumlahSakramen(data.task.data, sender);
      case "cari jumlah Umum":
        return _cariJumlahUmum(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      default:
        return rejectTask(data, sender);
    }
  }

  Future<Messages> _cariProfile(dynamic data, String sender) async {
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var userPemberkatanCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userBaptis', localField: '_id', foreignField: 'idBaptis', as: 'userBaptis'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countB = await userBaptisCollection.aggregateToStream(pipeline).toList();
    //Mencari data join antara baptis dan userBaptis berdasarkan idGereja
    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKomuni', localField: '_id', foreignField: 'idKomuni', as: 'userKomuni'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countKo = await userKomuniCollection.aggregateToStream(pipeline2).toList();
    //Mencari data join antara komuni dan userKomuni berdasarkan idGereja
    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKrisma', localField: '_id', foreignField: 'idKrisma', as: 'userKrisma'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countKr = await userKrismaCollection.aggregateToStream(pipeline3).toList();
    //Mencari data join antara krisma dan userKrisma berdasarkan idGereja
    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userUmum', localField: '_id', foreignField: 'idKegiatan', as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).map['\$query']))
        .build();
    var countU = await userKegiatanCollection.aggregateToStream(pipeline4).toList();
    //Mencari data join antara umum dan userUmum berdasarkan idGereja
    var countP = await userPemberkatanCollection.find({'idGereja': data[0]}).length;

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
    //Mencari jumlah umat yang mendaftar pelayanan baptis yang masih
    //belum dikonfirmasi

    for (var i = 0; i < countKo.length; i++) {
      if (countKo[i]['userKomuni'] != null) {
        for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
          if (countKo[i]['userKomuni'][j]['status'] != null) {
            totalKo++;
          }
        }
      }
    }
    //Mencari jumlah umat yang mendaftar pelayanan komuni yang masih
    //belum dikonfirmasi

    for (var i = 0; i < countKr.length; i++) {
      if (countKr[i]['userKrisma'] != null) {
        for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
          if (countKr[i]['userKrisma'][j]['status'] != null) {
            totalKr++;
          }
        }
      }
    }
    //Mencari jumlah umat yang mendaftar pelayanan krisma yang masih
    //belum dikonfirmasi

    for (var i = 0; i < countU.length; i++) {
      if (countU[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
          if (countU[i]['userKegiatan'][j]['status'] != null) {
            totalU++;
          }
        }
      }
    }
    //Mencari jumlah umat yang mendaftar pelayanan kegiatan umum yang masih
    //belum dikonfirmasi
    Messages message = Messages(agentName, sender, "INFORM", Tasks("hasil pencarian", [data[2], totalB + totalKo + countP + totalKr + totalU]));
    return message;
  }

  Future<Messages> _cariAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection = MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    var conn = await aturanPelayananCollection.find({'idGereja': data}).toList();
    //Mencari data aturan pelayanan berdasarkan idGereja
    Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Messages> _cariPelayananUser(dynamic data, String sender) async {
    var userPelayananCollection;
    String initial = "userPelayanan";
    String id = "";
    //Memberi nilai variabel berdasarkan data yang berada di pesan
    if (data[1] == "Baptis") {
      userPelayananCollection = MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
      // initial = "userBaptis";
      id = "idBaptis";
    } else if (data[1] == "Komuni") {
      userPelayananCollection = MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
      // initial = "userKomuni";
      id = "idKomuni";
    } else if (data[1] == "Krisma") {
      userPelayananCollection = MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
      // initial = "userKrisma";
      id = "idKrisma";
    } else if (data[1] == "Retret") {
      userPelayananCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      // initial = "userRetret";
      id = "idKegiatan";
    } else if (data[1] == "Rekoleksi") {
      userPelayananCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      // initial = "userRekoleksi";
      id = "idKegiatan";
    }
    if (data[2] == "current") {
      //Melakukan join dengan pelayanan yang masih aktif
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: initial))
          .addStage(Match(where.eq(id, data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn = await userPelayananCollection.aggregateToStream(pipeline).toList();

      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else {
      //Melakukan join dengan pelayanan yang sudah tidak aktif
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: initial))
          .addStage(Match(where.eq(id, data[0]).ne('status', -2).map['\$query']))
          .build();
      var conn = await userPelayananCollection.aggregateToStream(pipeline).toList();

      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    }
  }

  Future<Messages> _cariPelayananPendaftaran(dynamic data, String sender) async {
    var PelayananCollection;
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    if (data[0] == "Baptis") {
      PelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "Komuni") {
      PelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "Krisma") {
      PelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "Umum") {
      PelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }
    if (data[0] == "Pemberkatan") {
      PelayananCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    }
    if (data[0] == "Perkawinan") {
      PelayananCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    }
    var conn = await PelayananCollection.find({"_id": data[3]}).toList();
    Messages message = Messages(agentName, sender, "INFORM", Tasks('send FCM', [data, conn]));
    return message;
  }

  Future<Messages> _cariPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    var currentOrHistory;
    String id = "idGereja";
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    if (data[1] == "Baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    } else if (data[1] == "Komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    } else if (data[1] == "Krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    } else if (data[1] == "Umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    } else if (data[1] == "Perkawinan" && data[2] == "current") {
      var PerkawinanCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn = await PerkawinanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "Perkawinan" && data[2] == "history") {
      var PerkawinanCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).ne("status", 0).map['\$query']))
          .build();
      var conn = await PerkawinanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "Perkawinan" && data[2] == "detail") {
      print("MASUKKKKKKKKKKK");
      print(data[0]);
      var perkawinanCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      var conn = await perkawinanCollection.find({'_id': data[0]}).toList();

      var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
      var conn2 = await userCollection.find({'_id': conn[0]['idUser']}).toList();

      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [conn, conn2]));
      return message;
    } else if (data[1] == "Pemberkatan" && data[2] == "current") {
      var PemberkatanCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn = await PemberkatanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "Pemberkatan" && data[2] == "history") {
      var PemberkatanCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(from: 'user', localField: 'idUser', foreignField: '_id', as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).ne("status", 0).map['\$query']))
          .build();
      var conn = await PemberkatanCollection.aggregateToStream(pipeline).toList();
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "Pemberkatan" && data[2] == "detail") {
      var pemberkatanCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      var conn = await pemberkatanCollection.find({'_id': data[0]}).toList();

      var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
      var conn2 = await userCollection.find({'_id': conn[0]['idUser']}).toList();

      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [conn, conn2]));
      return message;
    }
    if (data[1] == "Umum") {
      if (data[2] == "current") {
        var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        var conn = await rekoleksiCollection.find({'idGereja': data[0], 'jenisKegiatan': data[3], 'status': 0}).toList();

        Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else {
        var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        var conn = await rekoleksiCollection.find({'idGereja': data[0], 'jenisKegiatan': data[3], "status": 1}).toList();

        Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      }
    } else {
      if (data[2] == "current") {
        var conn = await pelayananCollection.find({id: data[0], 'status': 0}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      } else {
        var conn = await pelayananCollection.find({id: data[0], "status": 1}).toList();
        Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
        return message;
      }
    }
  }

  Future<Messages> _cariEditPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    //Memberi nilai pada variabel berdasarkan data pada isi pesan
    if (data[1] == "Baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    } else if (data[1] == "Komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    } else if (data[1] == "Krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    } else if (data[1] == "Umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }

    var conn = await pelayananCollection.find({'_id': data[0]}).toList();
    //Mencari data pelayanan berdasarkan id pelayanan
    Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Messages> _cariJumlah(dynamic data, String sender) async {
    //Inisialisasi Variabel
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var userPemberkatanCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var perkawinanCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

///////////Melakukan join pada setiap pelayanan dengan userPelayanan////////////
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userBaptis', localField: '_id', foreignField: 'idBaptis', as: 'userBaptis'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countB = await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKomuni', localField: '_id', foreignField: 'idKomuni', as: 'userKomuni'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKo = await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKrisma', localField: '_id', foreignField: 'idKrisma', as: 'userKrisma'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKr = await userKrismaCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userUmum', localField: '_id', foreignField: 'idKegiatan', as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countU = await userKegiatanCollection.aggregateToStream(pipeline4).toList();
/////////////////////////////////////////////////////////////////////////////

//Mencari total pengguna mendaftar pelayanan yang masih aktif
    var countP = await userPemberkatanCollection.find({'idImam': data[1], 'status': 0}).length;

    var totalB = 0;
    var totalKo = 0;
    var totalKr = 0;
    var totalU = 0;
    for (var i = 0; i < countB.length; i++) {
      if (countB[i]['userBaptis'] != null) {
        for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
          if (countB[i]['userBaptis'][j]['status'] == 0) {
            totalB++;
          }
        }
      }
    }

    for (var i = 0; i < countKo.length; i++) {
      if (countKo[i]['userKomuni'] != null) {
        for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
          if (countKo[i]['userKomuni'][j]['status'] == 0) {
            totalKo++;
          }
        }
      }
    }

    for (var i = 0; i < countKr.length; i++) {
      if (countKr[i]['userKrisma'] != null) {
        for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
          if (countKr[i]['userKrisma'][j]['status'] == 0) {
            totalKr++;
          }
        }
      }
    }

    for (var i = 0; i < countU.length; i++) {
      if (countU[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
          if (countU[i]['userKegiatan'][j]['status'] == 0) {
            totalU++;
          }
        }
      }
    }
    var totalKa = await perkawinanCollection.find({'idImam': data[1], 'status': 0}).length;

    if (data[3] == 1) {
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [totalB + totalKo + totalKr + totalU, totalB + totalKo + totalKr, countP, totalU, data[2]]));
      return message;
    } else {
      Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [countP + totalKa, totalKa, countP, totalU, data[2]]));
      return message;
    }
  }

  Future<Messages> _cariJumlahSakramen(dynamic data, String sender) async {
    //Inisialisasi variabel
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var perkawinanCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);

    var count = 0;
    //Join pelayanan sakramen dengan user pelayanan sakramen
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userBaptis', localField: '_id', foreignField: 'idBaptis', as: 'userBaptis'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countB = await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKomuni', localField: '_id', foreignField: 'idKomuni', as: 'userKomuni'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKo = await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userKrisma', localField: '_id', foreignField: 'idKrisma', as: 'userKrisma'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKr = await userKrismaCollection.aggregateToStream(pipeline3).toList();

    var totalB = 0;
    var totalKo = 0;
    var totalKr = 0;
    var totalU = 0;
    for (var i = 0; i < countB.length; i++) {
      if (countB[i]['userBaptis'] != null) {
        for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
          if (countB[i]['userBaptis'][j]['status'] == 0) {
            totalB++;
          }
        }
      }
    }

    for (var i = 0; i < countKo.length; i++) {
      if (countKo[i]['userKomuni'] != null) {
        for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
          if (countKo[i]['userKomuni'][j]['status'] == 0) {
            totalKo++;
          }
        }
      }
    }

    for (var i = 0; i < countKr.length; i++) {
      if (countKr[i]['userKrisma'] != null) {
        for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
          if (countKr[i]['userKrisma'][j]['status'] == 0) {
            totalKr++;
          }
        }
      }
    }
    var totalKa = await perkawinanCollection.find({'idImam': data[1], 'status': 0}).length;

    if (data[2] == 1) {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', [totalB + totalKo + totalKr, totalB, totalKo, totalKr, totalKa]));
      return message;
    } else {
      Messages message = Messages(agentName, sender, "INFORM", Tasks('hasil pencarian', [totalKa, totalB, totalKo, totalKr, totalKa]));
      return message;
    }
  }

  Future<Messages> _cariJumlahUmum(dynamic data, String sender) async {
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    //Join pelayanan umum dengan userPelayanan umum
    final pipeline1 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userUmum', localField: '_id', foreignField: 'idKegiatan', as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countU = await userKegiatanCollection.aggregateToStream(pipeline1).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userUmum', localField: '_id', foreignField: 'idKegiatan', as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).eq('jenisKegiatan', "Rekoleksi").map['\$query']))
        .build();
    var countU2 = await userKegiatanCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(from: 'userUmum', localField: '_id', foreignField: 'idKegiatan', as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[0]).eq('status', 0).eq('jenisKegiatan', "Retret").map['\$query']))
        .build();
    var countU3 = await userKegiatanCollection.aggregateToStream(pipeline3).toList();
    var totalU1 = 0;
    var totalU2 = 0;
    var totalU3 = 0;
    for (var i = 0; i < countU.length; i++) {
      if (countU[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
          if (countU[i]['userKegiatan'][j]['status'] == 0) {
            totalU1++;
          }
        }
      }
    }

    for (var i = 0; i < countU2.length; i++) {
      if (countU2[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU2[i]['userKegiatan'].length; j++) {
          if (countU2[i]['userKegiatan'][j]['status'] == 0) {
            totalU2++;
          }
        }
      }
    }

    for (var i = 0; i < countU3.length; i++) {
      if (countU3[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU3[i]['userKegiatan'].length; j++) {
          if (countU3[i]['userKegiatan'][j]['status'] == 0) {
            totalU3++;
          }
        }
      }
    }
    Messages message = Messages('Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [totalU1, totalU2, totalU3]));
    return message;
  }

  @override
  addEstimatedTime(String goals) {
    //Fungsi menambahkan batas waktu pengerjaan tugas dengan 1 detik

    _timeAction[goals] = _timeAction[goals]! + 1;
  }

  _initAgent() {
    //Inisialisasi identitas agen
    agentName = "Agent Pencarian";

    //nama agen
    plan = [
      Plan("cari aturan pelayanan", "REQUEST"),
      Plan("cari pelayanan", "REQUEST"),
      Plan("cari pelayanan user", "REQUEST"),
      Plan("cari pelayanan pendaftaran", "REQUEST"),
      Plan("cari data edit pelayanan", "REQUEST"),
      Plan("cari pelayanan user", "REQUEST"),
      Plan("cari jumlah", "REQUEST"),
      Plan("cari jumlah Sakramen", "REQUEST"),
      Plan("cari jumlah Umum", "REQUEST"),
      Plan("cari profile", "REQUEST"),
    ];
    //Perencanaan agen
    goals = [
      Goals("cari aturan pelayanan", List<Map<String, Object?>>, _timeAction["cari aturan pelayanan"]),
      Goals("cari pelayanan", List<Map<String, Object?>>, _timeAction["cari pelayanan"]),
      Goals("cari profile", List<dynamic>, _timeAction["cari profile"]),
      Goals("cari pelayanan", List<dynamic>, _timeAction["cari pelayanan"]),
      Goals("cari pelayanan user", List<Map<String, Object?>>, _timeAction["cari pelayanan user"]),
      Goals("cari pelayanan pendaftaran", List<dynamic>, _timeAction["cari pelayanan pendaftaran"]),
      Goals("cari data edit pelayanan", List<Map<String, Object?>>, _timeAction["cari data edit pelayanan"]),
      Goals("cari pelayanan user", List<Map<String, Object?>>, _timeAction["cari pelayanan user"]),
      Goals("cari jumlah", List<dynamic>, _timeAction["cari jumlah"]),
      Goals("cari jumlah Sakramen", List<dynamic>, _timeAction["cari jumlah Sakramen"]),
      Goals("cari jumlah Umum", List<int>, _timeAction["cari jumlah Umum"]),
      Goals("cari jumlah Umum", List<dynamic>, _timeAction["cari jumlah Umum"]),
    ];
  }
}
