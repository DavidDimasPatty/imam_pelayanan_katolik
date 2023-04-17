import 'dart:async';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPencarian extends Agent {
  AgentPencarian() {
    _initAgent();
  }

  static int _estimatedTime = 5;

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari aturan pelayanan":
        return _cariAturanPelayanan(data.task.data, sender);
      case "cari pengumuman edit":
        return _cariPengumumanEdit(data.task.data, sender);
      case "cari pengumuman":
        return _cariPengumuman(data.task.data, sender);
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
      case "cari jumlah sakramen":
        return _cariJumlahSakramen(data.task.data, sender);
      case "cari jumlah umum":
        return _cariJumlahUmum(data.task.data, sender);
      case "cari profile":
        return _cariProfile(data.task.data, sender);
      default:
        return rejectTask(data, sender);
    }
  }

  Future<Message> _cariProfile(dynamic data, String sender) async {
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
    Message message = Message(
        agentName,
        sender,
        "INFORM",
        Tasks("hasil pencarian",
            [data[2], totalB + totalKo + countP + totalKr + totalU]));
    return message;
  }

  Future<Message> _cariAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    var conn =
        await aturanPelayananCollection.find({'idGereja': data[0]}).toList();
    Message message = Message(
        'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', [conn]));
    return message;
  }

  Future<Message> _cariPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var conn =
        await pengumumanCollection.find(where.eq("idGereja", data[0])).toList();
    Message message = Message(
        'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> _cariPelayananUser(dynamic data, String sender) async {
    var userPelayananCollection;
    String initial = "";
    String id = "";
    if (data[1] == "baptis") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
      initial = "userBaptis";
      id = "idBaptis";
    } else if (data[1] == "komuni") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
      initial = "userKomuni";
      id = "idKomuni";
    } else if (data[1] == "krisma") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
      initial = "userKrisma";
      id = "idKrisma";
    } else if (data[1] == "pendalaman alkitab") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      initial = "userPA";
      id = "idKegiatan";
    } else if (data[1] == "retret") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      initial = "userRetret";
      id = "idKegiatan";
    } else if (data[1] == "rekoleksi") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_UMUM_COLLECTION);
      initial = "userRekoleksi";
      id = "idKegiatan";
    }
    if (data[2] == "current") {
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: initial))
          .addStage(Match(where.eq(id, data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn =
          await userPelayananCollection.aggregateToStream(pipeline).toList();

      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else {
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: initial))
          .addStage(Match(where.eq(id, data[0]).map['\$query']))
          .build();
      var conn =
          await userPelayananCollection.aggregateToStream(pipeline).toList();

      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    }
  }

  Future<Message> _cariPengumumanEdit(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var conn = await pengumumanCollection.find({'_id': data[0]}).toList();
    Message message = Message(
        'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> _cariPelayananPendaftaran(dynamic data, String sender) async {
    var PelayananCollection;
    if (data[0] == "baptis") {
      PelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      PelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      PelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      PelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }
    if (data[0] == "sakramentali") {
      PelayananCollection = MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    }
    if (data[0] == "perkawinan") {
      PelayananCollection = MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    }
    var conn = await PelayananCollection.find({"_id": data[3]}).toList();

    Message message =
        Message(agentName, sender, "INFORM", Tasks('send FCM', [data, conn]));
    return message;
  }

  Future<Message> _cariPelayanan(dynamic data, String sender) async {
    var pelayananCollection;
    var currentOrHistory;
    String id = "idGereja";
    if (data[1] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    } else if (data[1] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    } else if (data[1] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    } else if (data[1] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    } else if (data[1] == "perkawinan" && data[2] == "current") {
      var PerkawinanCollection =
          MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: 'userDaftar'))
          .addStage(
              Match(where.eq('idImam', data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn =
          await PerkawinanCollection.aggregateToStream(pipeline).toList();
      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "perkawinan" && data[2] == "history") {
      var PerkawinanCollection =
          MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).map['\$query']))
          .build();
      var conn =
          await PerkawinanCollection.aggregateToStream(pipeline).toList();
      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "perkawinan" && data[2] == "detail") {
      var perkawinanCollection =
          MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
      var conn = await perkawinanCollection.find({'_id': data[0]}).toList();

      var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
      var conn2 =
          await userCollection.find({'_id': conn[0]['idUser']}).toList();

      Message message = Message('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [conn, conn2]));
      return message;
    } else if (data[1] == "sakramentali" && data[2] == "current") {
      var PemberkatanCollection =
          MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: 'userDaftar'))
          .addStage(
              Match(where.eq('idImam', data[0]).eq('status', 0).map['\$query']))
          .build();
      var conn =
          await PemberkatanCollection.aggregateToStream(pipeline).toList();
      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "sakramentali" && data[2] == "history") {
      var PemberkatanCollection =
          MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      final pipeline = AggregationPipelineBuilder()
          .addStage(Lookup(
              from: 'user',
              localField: 'idUser',
              foreignField: '_id',
              as: 'userDaftar'))
          .addStage(Match(where.eq('idImam', data[0]).map['\$query']))
          .build();
      var conn =
          await PemberkatanCollection.aggregateToStream(pipeline).toList();
      Message message = Message(
          'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
      return message;
    } else if (data[1] == "sakramentali" && data[2] == "detail") {
      var pemberkatanCollection =
          MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
      var conn = await pemberkatanCollection.find({'_id': data[0]}).toList();

      var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
      var conn2 =
          await userCollection.find({'_id': conn[0]['idUser']}).toList();

      Message message = Message('Agent Pencarian', sender, "INFORM",
          Tasks('hasil pencarian', [conn, conn2]));
      return message;
    }
    if (data[1] == "umum") {
      if (data[2] == "current") {
        var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        var conn = await rekoleksiCollection.find({
          'idGereja': data[0],
          'jenisKegiatan': data[3],
          'status': 0
        }).toList();

        Message message = Message('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
        var conn = await rekoleksiCollection.find({
          'idGereja': data[0],
          'jenisKegiatan': data[3],
        }).toList();

        Message message = Message('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      }
    } else {
      if (data[2] == "current") {
        var conn =
            await pelayananCollection.find({id: data[0], 'status': 0}).toList();
        Message message = Message('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      } else {
        var conn = await pelayananCollection.find({id: data[0]}).toList();
        Message message = Message('Agent Pencarian', sender, "INFORM",
            Tasks('hasil pencarian', conn));
        return message;
      }
    }
  }

  Future<Message> _cariEditPelayanan(dynamic data, String sender) async {
    var pelayananCollection;

    if (data[1] == "baptis") {
      pelayananCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    } else if (data[1] == "komuni") {
      pelayananCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    } else if (data[1] == "krisma") {
      pelayananCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    } else if (data[1] == "umum") {
      pelayananCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    }

    var conn = await pelayananCollection.find({'_id': data[0]}).toList();
    Message message = Message(
        'Agent Pencarian', sender, "INFORM", Tasks('hasil pencarian', conn));
    return message;
  }

  Future<Message> _cariJumlah(dynamic data, String sender) async {
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var userPemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userBaptis',
            localField: '_id',
            foreignField: 'idBaptis',
            as: 'userBaptis'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKr =
        await userKrismaCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countU =
        await userKegiatanCollection.aggregateToStream(pipeline4).toList();

    var countP = await userPemberkatanCollection
        .find({'idImam': data[1], 'status': 0}).length;

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
    var totalKa = await perkawinanCollection
        .find({'idImam': data[1], 'status': 0}).length;

    if (data[3] == 1) {
      Message message = Message(
          'Agent Pencarian',
          sender,
          "INFORM",
          Tasks('hasil pencarian', [
            totalB + totalKo + totalKr + totalU,
            totalB + totalKo + totalKr,
            countP,
            totalU,
            data[2]
          ]));
      return message;
    } else {
      Message message = Message(
          'Agent Pencarian',
          sender,
          "INFORM",
          Tasks('hasil pencarian',
              [countP + totalKa, totalKa, countP, totalU, data[2]]));
      return message;
    }
  }

  Future<Message> _cariJumlahSakramen(dynamic data, String sender) async {
    var userKrismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var userKomuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);

    var count = 0;

    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userBaptis',
            localField: '_id',
            foreignField: 'idBaptis',
            as: 'userBaptis'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countKr =
        await userKrismaCollection.aggregateToStream(pipeline3).toList();

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
    var totalKa = await perkawinanCollection
        .find({'idImam': data[1], 'status': 0}).length;

    if (data[2] == 1) {
      Message message = Message(
          agentName,
          sender,
          "INFORM",
          Tasks('hasil pencarian',
              [totalB + totalKo + totalKr, totalB, totalKo, totalKr, totalKa]));
      return message;
    } else {
      Message message = Message(
          agentName,
          sender,
          "INFORM",
          Tasks(
              'hasil pencarian', [totalKa, totalB, totalKo, totalKr, totalKa]));
      return message;
    }
  }

  Future<Message> _cariJumlahUmum(dynamic data, String sender) async {
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    final pipeline1 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(
            Match(where.eq('idGereja', data[0]).eq('status', 0).map['\$query']))
        .build();
    var countU =
        await userKegiatanCollection.aggregateToStream(pipeline1).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(where
            .eq('idGereja', data[0])
            .eq('status', 0)
            .eq('jenisKegiatan', "Rekoleksi")
            .map['\$query']))
        .build();
    var countU2 =
        await userKegiatanCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(where
            .eq('idGereja', data[0])
            .eq('status', 0)
            .eq('jenisKegiatan', "Retret")
            .map['\$query']))
        .build();
    var countU3 =
        await userKegiatanCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(where
            .eq('idGereja', data[0])
            .eq('status', 0)
            .eq('jenisKegiatan', "Pendalaman Alkitab")
            .map['\$query']))
        .build();
    var countU4 =
        await userKegiatanCollection.aggregateToStream(pipeline4).toList();

    var totalU1 = 0;
    var totalU2 = 0;
    var totalU3 = 0;
    var totalU4 = 0;

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

    for (var i = 0; i < countU4.length; i++) {
      if (countU4[i]['userKegiatan'] != null) {
        for (var j = 0; j < countU4[i]['userKegiatan'].length; j++) {
          if (countU4[i]['userKegiatan'][j]['status'] == 0) {
            totalU4++;
          }
        }
      }
    }

    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('hasil pencarian', [totalU1, totalU2, totalU3, totalU4]));
    return message;
  }

  @override
  addEstimatedTime() {
    _estimatedTime++;
  }

  _initAgent() {
    agentName = "Agent Pencarian";

    plan = [
      Plan("cari aturan pelayanan", "REQUEST"),
      Plan("cari pengumuman edit", "REQUEST"),
      Plan("cari pengumuman", "REQUEST"),
      Plan("cari pelayanan", "REQUEST"),
      Plan("cari pelayanan user", "REQUEST"),
      Plan("cari pelayanan pendaftaran", "REQUEST"),
      Plan("cari data edit pelayanan", "REQUEST"),
      Plan("cari pelayanan user", "REQUEST"),
      Plan("cari jumlah", "REQUEST"),
      Plan("cari jumlah sakramen", "REQUEST"),
      Plan("cari jumlah umum", "REQUEST"),
      Plan("cari profile", "REQUEST"),
    ];
    goals = [
      Goals(
          "cari aturan pelayanan", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari pengumuman edit", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari pengumuman", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari pelayanan", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari profile", List<dynamic>, _estimatedTime),
      Goals("cari pelayanan", List<dynamic>, _estimatedTime),
      Goals("cari pelayanan user", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari pelayanan pendaftaran", List<dynamic>, _estimatedTime),
      Goals("cari data edit pelayanan", List<Map<String, Object?>>,
          _estimatedTime),
      Goals("cari pelayanan user", List<Map<String, Object?>>, _estimatedTime),
      Goals("cari jumlah", List<dynamic>, _estimatedTime),
      Goals("cari jumlah sakramen", List<dynamic>, _estimatedTime),
      Goals("cari jumlah umum", List<dynamic>, _estimatedTime),
    ];
  }
}
