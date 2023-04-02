// import 'dart:developer';

// import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import '../DatabaseFolder/mongodb.dart';
// import 'messages.dart';

// class AgenPencarian {
//   AgenPencarian() {
//     ReadyBehaviour();
//     ResponsBehaviour();
//     UpdateBehaviour();
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (data[0][0] == "cari Profile") {
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             var userPemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var count = 0;

//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userBaptis',
//                     localField: '_id',
//                     foreignField: 'idBaptis',
//                     as: 'userBaptis'))
//                 .addStage(
//                     Match(where.eq('idGereja', data[1][0]).map['\$query']))
//                 .build();
//             var countB =
//                 await userBaptisCollection.aggregateToStream(pipeline).toList();

//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKomuni',
//                     localField: '_id',
//                     foreignField: 'idKomuni',
//                     as: 'userKomuni'))
//                 .addStage(
//                     Match(where.eq('idGereja', data[1][0]).map['\$query']))
//                 .build();
//             var countKo = await userKomuniCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();

//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKrisma',
//                     localField: '_id',
//                     foreignField: 'idKrisma',
//                     as: 'userKrisma'))
//                 .addStage(
//                     Match(where.eq('idGereja', data[1][0]).map['\$query']))
//                 .build();
//             var countKr = await userKrismaCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();

//             final pipeline4 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(
//                     Match(where.eq('idGereja', data[1][0]).map['\$query']))
//                 .build();
//             var countU = await userKegiatanCollection
//                 .aggregateToStream(pipeline4)
//                 .toList();

//             var countP = await userPemberkatanCollection
//                 .find({'idGereja': data[1][0]}).length;

//             var totalB = 0;
//             var totalKo = 0;
//             var totalKr = 0;
//             var totalU = 0;
//             for (var i = 0; i < countB.length; i++) {
//               if (countB[i]['userBaptis'] != null) {
//                 for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
//                   if (countB[i]['userBaptis'][j]['status'] != null) {
//                     totalB++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKo.length; i++) {
//               if (countKo[i]['userKomuni'] != null) {
//                 for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
//                   if (countKo[i]['userKomuni'][j]['status'] != null) {
//                     totalKo++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKr.length; i++) {
//               if (countKr[i]['userKrisma'] != null) {
//                 for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
//                   if (countKr[i]['userKrisma'][j]['status'] != null) {
//                     totalKr++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countU.length; i++) {
//               if (countU[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
//                   if (countU[i]['userKegiatan'][j]['status'] != null) {
//                     totalU++;
//                   }
//                 }
//               }
//             }

//             var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             final pipeline5 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'userGereja'))
//                 .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
//                 .build();
//             var conn = await userCollection
//                 .aggregateToStream(pipeline5)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 [result],
//                 [totalB + totalKo + countP + totalKr + totalU]
//               ]);
//               await msg.send();
//             });
//           }
//           if (data[0][0] == "tampilan edit Profile") {
//             var imamCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await imamCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//             ;
//           }
//           if (data[0][0] == "tampilan aturan pelayanan") {
//             var aturanPelayananCollection =
//                 MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
//             var conn = await aturanPelayananCollection
//                 .find({'idGereja': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//             ;
//           }
//           if (data[0][0] == "cari Pengumuman") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Pengumuman Edit") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//             await userBaptisCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Baptis") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0], 'status': 0})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Baptis Pendaftaran") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             await userBaptisCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   await msg.addReceiver("agenPendaftaran");
//                   await msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari edit Baptis") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             await userBaptisCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari edit Komuni") {
//             var komuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             await komuniCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari edit Krisma") {
//             var krismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             await krismaCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari edit Kegiatan") {
//             var kegiatanCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             await kegiatanCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Baptis History") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             var conn = await userBaptisCollection
//                 .find({'idGereja': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Baptis User") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userBaptis'))
//                 .addStage(Match(where
//                     .eq('idBaptis', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userBaptisCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Baptis User History") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userBaptis'))
//                 .addStage(Match(where
//                     .eq('idBaptis', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userBaptisCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Komuni") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0], 'status': 0})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Komuni Pendaftaran") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             await userBaptisCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   await msg.addReceiver("agenPendaftaran");
//                   await msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Komuni History") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Komuni User") {
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userKomuni'))
//                 .addStage(Match(where
//                     .eq('idKomuni', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userKomuniCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Komuni User History") {
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userKomuni'))
//                 .addStage(Match(where
//                     .eq('idKomuni', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userKomuniCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Krisma") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0], 'status': 0})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Krisma Pendaftaran") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             await userBaptisCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   await msg.addReceiver("agenPendaftaran");
//                   await msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Krisma History") {
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             await userBaptisCollection
//                 .find({'idGereja': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Krisma User") {
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userKrisma'))
//                 .addStage(Match(where
//                     .eq('idKrisma', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userKrismaCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Krisma User History") {
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userKrisma'))
//                 .addStage(Match(where
//                     .eq('idKrisma', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userKrismaCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Rekoleksi") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Rekoleksi",
//                   'status': 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Umum Pendaftaran") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({'_id': data[1][0]})
//                 .toList()
//                 .then((result) async {
//                   await msg.addReceiver("agenPendaftaran");
//                   await msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Rekoleksi History") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Rekoleksi",
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Rekoleksi User") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userRekoleksi'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Rekoleksi User History") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userRekoleksi'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Retret") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Retret",
//                   'status': 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Retret History") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Retret",
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Retret User") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userRetret'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Retret User History") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userRetret'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari PA") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Pendalaman Alkitab",
//                   'status': 0
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari PA History") {
//             var rekoleksiCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var conn = await rekoleksiCollection
//                 .find({
//                   'idGereja': data[1][0],
//                   'jenisKegiatan': "Pendalaman Alkitab",
//                 })
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent(result);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari PA User") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userPA'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari PA User History") {
//             var userUmumCollection =
//                 MongoDatabase.db.collection(USER_UMUM_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userPA'))
//                 .addStage(Match(where
//                     .eq('idKegiatan', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await userUmumCollection
//                 .aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Sakramentali") {
//             var PemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userDaftar'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await PemberkatanCollection.aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Perkawinan") {
//             var PerkawinanCollection =
//                 MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userDaftar'))
//                 .addStage(Match(where
//                     .eq('idImam', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await PerkawinanCollection.aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari History Perkawinan") {
//             var PerkawinanCollection =
//                 MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userDaftar'))
//                 .addStage(Match(where
//                     .eq('idImam', data[1][0])
//                     .ne('status', 0)
//                     .map['\$query']))
//                 .build();
//             var conn = await PerkawinanCollection.aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Sakramentali History") {
//             var PemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'user',
//                     localField: 'idUser',
//                     foreignField: '_id',
//                     as: 'userDaftar'))
//                 .addStage(
//                     Match(where.eq('idGereja', data[1][0]).map['\$query']))
//                 .build();
//             var conn = await PemberkatanCollection.aggregateToStream(pipeline)
//                 .toList()
//                 .then((result) async {
//               msg.addReceiver("agenPage");
//               msg.setContent(result);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari Sakramentali Detail") {
//             var pemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var conn =
//                 await pemberkatanCollection.find({'_id': data[1][0]}).toList();

//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn2 = await userCollection
//                 .find({'_id': conn[0]['idUser']})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent([
//                     [conn],
//                     [result]
//                   ]);
//                   await msg.send();
//                 });
//           }

//           if (data[0][0] == "cari Perkawinan Detail") {
//             var perkawinanCollection =
//                 MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
//             var conn =
//                 await perkawinanCollection.find({'_id': data[1][0]}).toList();

//             var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
//             var conn2 = await userCollection
//                 .find({'_id': conn[0]['idUser']})
//                 .toList()
//                 .then((result) async {
//                   msg.addReceiver("agenPage");
//                   msg.setContent([
//                     [conn],
//                     [result]
//                   ]);
//                   await msg.send();
//                 });
//           }

// /////cari jumlah
//           if (data[0][0] == "cari jumlah") {
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             var userPemberkatanCollection =
//                 MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
//             var perkawinanCollection =
//                 MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var count = 0;

//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userBaptis',
//                     localField: '_id',
//                     foreignField: 'idBaptis',
//                     as: 'userBaptis'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countB =
//                 await userBaptisCollection.aggregateToStream(pipeline).toList();

//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKomuni',
//                     localField: '_id',
//                     foreignField: 'idKomuni',
//                     as: 'userKomuni'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countKo = await userKomuniCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();

//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKrisma',
//                     localField: '_id',
//                     foreignField: 'idKrisma',
//                     as: 'userKrisma'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countKr = await userKrismaCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();

//             final pipeline4 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countU = await userKegiatanCollection
//                 .aggregateToStream(pipeline4)
//                 .toList();

//             var countP = await userPemberkatanCollection
//                 .find({'idGereja': data[1][0], 'status': 0}).length;

//             var totalB = 0;
//             var totalKo = 0;
//             var totalKr = 0;
//             var totalU = 0;
//             for (var i = 0; i < countB.length; i++) {
//               if (countB[i]['userBaptis'] != null) {
//                 for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
//                   if (countB[i]['userBaptis'][j]['status'] == 0) {
//                     totalB++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKo.length; i++) {
//               if (countKo[i]['userKomuni'] != null) {
//                 for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
//                   if (countKo[i]['userKomuni'][j]['status'] == 0) {
//                     totalKo++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKr.length; i++) {
//               if (countKr[i]['userKrisma'] != null) {
//                 for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
//                   if (countKr[i]['userKrisma'][j]['status'] == 0) {
//                     totalKr++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countU.length; i++) {
//               if (countU[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
//                   if (countU[i]['userKegiatan'][j]['status'] == 0) {
//                     totalU++;
//                   }
//                 }
//               }
//             }
//             var totalKa = await perkawinanCollection
//                 .find({'idImam': data[2][0], 'status': 0}).length;
//             var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

//             final pipeliner = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'userGereja'))
//                 .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
//                 .build();
//             var conn = await userCollection
//                 .aggregateToStream(pipeliner)
//                 .toList()
//                 .then((res) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 totalB + totalKo + countP + totalKr + totalU + totalKa,
//                 totalB + totalKo + totalKr + totalKa,
//                 countP,
//                 totalU,
//                 res
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari jumlah Sakramen") {
//             var userKrismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             var userBaptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             var userKomuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             var perkawinanCollection =
//                 MongoDatabase.db.collection(PERKAWINAN_COLLECTION);

//             var count = 0;

//             final pipeline = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userBaptis',
//                     localField: '_id',
//                     foreignField: 'idBaptis',
//                     as: 'userBaptis'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countB =
//                 await userBaptisCollection.aggregateToStream(pipeline).toList();

//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKomuni',
//                     localField: '_id',
//                     foreignField: 'idKomuni',
//                     as: 'userKomuni'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countKo = await userKomuniCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();

//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userKrisma',
//                     localField: '_id',
//                     foreignField: 'idKrisma',
//                     as: 'userKrisma'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countKr = await userKrismaCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();

//             var totalB = 0;
//             var totalKo = 0;
//             var totalKr = 0;
//             var totalU = 0;
//             for (var i = 0; i < countB.length; i++) {
//               if (countB[i]['userBaptis'] != null) {
//                 for (var j = 0; j < countB[i]['userBaptis'].length; j++) {
//                   if (countB[i]['userBaptis'][j]['status'] == 0) {
//                     totalB++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKo.length; i++) {
//               if (countKo[i]['userKomuni'] != null) {
//                 for (var j = 0; j < countKo[i]['userKomuni'].length; j++) {
//                   if (countKo[i]['userKomuni'][j]['status'] == 0) {
//                     totalKo++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countKr.length; i++) {
//               if (countKr[i]['userKrisma'] != null) {
//                 for (var j = 0; j < countKr[i]['userKrisma'].length; j++) {
//                   if (countKr[i]['userKrisma'][j]['status'] == 0) {
//                     totalKr++;
//                   }
//                 }
//               }
//             }
//             var totalKa = await perkawinanCollection
//                 .find({'idImam': data[2][0], 'status': 0}).length;
//             var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

//             final pipeliner = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'userGereja'))
//                 .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
//                 .build();
//             var conn = await userCollection
//                 .aggregateToStream(pipeliner)
//                 .toList()
//                 .then((res) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([
//                 totalB + totalKo + totalKr + totalKa,
//                 totalB,
//                 totalKo,
//                 totalKr,
//                 totalKa,
//                 res
//               ]);
//               await msg.send();
//             });
//           }

//           if (data[0][0] == "cari jumlah Umum") {
//             var userKegiatanCollection =
//                 MongoDatabase.db.collection(UMUM_COLLECTION);
//             var count = 0;

//             final pipeline1 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .map['\$query']))
//                 .build();
//             var countU = await userKegiatanCollection
//                 .aggregateToStream(pipeline1)
//                 .toList();

//             final pipeline2 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .eq('jenisKegiatan', "Rekoleksi")
//                     .map['\$query']))
//                 .build();
//             var countU2 = await userKegiatanCollection
//                 .aggregateToStream(pipeline2)
//                 .toList();

//             final pipeline3 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .eq('jenisKegiatan', "Retret")
//                     .map['\$query']))
//                 .build();
//             var countU3 = await userKegiatanCollection
//                 .aggregateToStream(pipeline3)
//                 .toList();

//             final pipeline4 = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'userUmum',
//                     localField: '_id',
//                     foreignField: 'idKegiatan',
//                     as: 'userKegiatan'))
//                 .addStage(Match(where
//                     .eq('idGereja', data[1][0])
//                     .eq('status', 0)
//                     .eq('jenisKegiatan', "Pendalaman Alkitab")
//                     .map['\$query']))
//                 .build();
//             var countU4 = await userKegiatanCollection
//                 .aggregateToStream(pipeline4)
//                 .toList();

//             var totalU1 = 0;
//             var totalU2 = 0;
//             var totalU3 = 0;
//             var totalU4 = 0;

//             for (var i = 0; i < countU.length; i++) {
//               if (countU[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU[i]['userKegiatan'].length; j++) {
//                   if (countU[i]['userKegiatan'][j]['status'] == 0) {
//                     totalU1++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countU2.length; i++) {
//               if (countU2[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU2[i]['userKegiatan'].length; j++) {
//                   if (countU2[i]['userKegiatan'][j]['status'] == 0) {
//                     totalU2++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countU3.length; i++) {
//               if (countU3[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU3[i]['userKegiatan'].length; j++) {
//                   if (countU3[i]['userKegiatan'][j]['status'] == 0) {
//                     totalU3++;
//                   }
//                 }
//               }
//             }

//             for (var i = 0; i < countU4.length; i++) {
//               if (countU4[i]['userKegiatan'] != null) {
//                 for (var j = 0; j < countU4[i]['userKegiatan'].length; j++) {
//                   if (countU4[i]['userKegiatan'][j]['status'] == 0) {
//                     totalU4++;
//                   }
//                 }
//               }
//             }

//             var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

//             final pipeliner = AggregationPipelineBuilder()
//                 .addStage(Lookup(
//                     from: 'Gereja',
//                     localField: 'idGereja',
//                     foreignField: '_id',
//                     as: 'userGereja'))
//                 .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
//                 .build();
//             var conn = await userCollection
//                 .aggregateToStream(pipeliner)
//                 .toList()
//                 .then((res) async {
//               msg.addReceiver("agenPage");
//               msg.setContent([totalU1, totalU2, totalU3, totalU4, res]);
//               await msg.send();
//             });
//           }
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }

//   UpdateBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     print(data.runtimeType);
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
//           if (data[0][0] == "cari user") {
//             print("nih");
//             print(data);
//             var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
//             var conn = await userCollection
//                 .find({'email': data[1][0], 'password': data[2][0]})
//                 .toList()
//                 .then((result) async {
//                   print(result);

//                   if (result != 0) {
//                     msg.addReceiver("agenPage");
//                     msg.setContent(result);
//                     await msg.send();
//                   } else {
//                     msg.addReceiver("agenPage");
//                     msg.setContent(result);
//                     await msg.send();
//                   }
//                 });
//           }

//           if (data[0][0] == "update Baptis") {
//             var baptisCollection =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);
//             try {
//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[2][0]))
//                   .then((result) async {
//                 if (result.isSuccess) {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('oke');
//                   await msg.send();
//                 } else {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('failed');
//                   await msg.send();
//                 }
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent('failed');
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "update Baptis User") {
//             var baptisCollection =
//                 MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);

//             try {
//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[2][0]))
//                   .then((result) async {
//                 if (result.isSuccess) {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('oke');
//                   await msg.send();
//                 } else {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('failed');
//                   await msg.send();
//                 }
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent('failed');
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "update Komuni") {
//             var komuniCollection =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);
//             try {
//               var update = await komuniCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[2][0]))
//                   .then((result) async {
//                 if (result.isSuccess) {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('oke');
//                   await msg.send();
//                 } else {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('failed');
//                   await msg.send();
//                 }
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent('failed');
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "update Komuni User") {
//             var komuniCollection =
//                 MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);

//             try {
//               var update = await komuniCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[2][0]))
//                   .then((result) async {
//                 if (result.isSuccess) {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('oke');
//                   await msg.send();
//                 } else {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('failed');
//                   await msg.send();
//                 }
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent('failed');
//               await msg.send();
//             }
//           }

//           if (data[0][0] == "update Krisma") {
//             var krismaCollection =
//                 MongoDatabase.db.collection(KRISMA_COLLECTION);
//             try {
//               var update = await krismaCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[2][0]))
//                   .then((result) async {
//                 if (result.isSuccess) {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('oke');
//                   await msg.send();
//                 } else {
//                   msg.addReceiver("agenPage");
//                   msg.setContent('failed');
//                   await msg.send();
//                 }
//               });
//             } catch (e) {
//               msg.addReceiver("agenPage");
//               msg.setContent('failed');
//               await msg.send();
//             }
//           }
//         }

//         if (data[0][0] == "update Krisma User") {
//           var krismaCollection =
//               MongoDatabase.db.collection(USER_KRISMA_COLLECTION);

//           try {
//             var update = await krismaCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "update Kegiatan") {
//           var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//           try {
//             var update = await umumCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "update Kegiatan User") {
//           var kegiatanCollection =
//               MongoDatabase.db.collection(USER_UMUM_COLLECTION);

//           try {
//             var update = await kegiatanCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "update Sakramentali") {
//           var baptisCollection =
//               MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);

//           try {
//             var update = await baptisCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[2][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add Baptis") {
//           var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);

//           try {
//             var hasil = await baptisCollection.insertOne({
//               'idGereja': data[1][0],
//               'kapasitas': int.parse(data[2][0]),
//               'jadwalBuka': DateTime.parse(data[3][0]),
//               'jadwalTutup': DateTime.parse(data[4][0]),
//               'status': 0
//             }).then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add Komuni") {
//           var komuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
//           try {
//             var hasil = await komuniCollection.insertOne({
//               'idGereja': data[1][0],
//               'kapasitas': int.parse(data[2][0]),
//               'jadwalBuka': DateTime.parse(data[3][0]),
//               'jadwalTutup': DateTime.parse(data[4][0]),
//               'status': 0
//             }).then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add Krisma") {
//           var krismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
//           try {
//             var hasil = await krismaCollection.insertOne({
//               'idGereja': data[1][0],
//               'kapasitas': int.parse(data[2][0]),
//               'jadwalBuka': DateTime.parse(data[3][0]),
//               'jadwalTutup': DateTime.parse(data[4][0]),
//               'status': 0
//             }).then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add Kegiatan") {
//           var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//           try {
//             var hasil = await umumCollection.insertOne({
//               'idGereja': data[1][0],
//               'namaKegiatan': data[2][0],
//               'temaKegiatan': data[3][0],
//               'jenisKegiatan': data[4][0],
//               'deskripsiKegiatan': data[5][0],
//               'tamu': data[6][0],
//               'tanggal': DateTime.parse(data[7][0]),
//               'kapasitas': int.parse(data[8][0]),
//               'lokasi': data[9][0],
//               'status': 0
//             }).then((result) async {
//               if (result.isSuccess) {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 msg.addReceiver("agenPage");
//                 msg.setContent('failed');
//                 await msg.send();
//               }
//             });
//           } catch (e) {
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }

//   ReadyBehaviour() {
//     Messages msg = Messages();
//     var data = msg.receive();
//     action() {
//       try {
//         if (data == "ready") {
//           print("Agen Pencarian Ready");
//         }
//       } catch (e) {
//         return 0;
//       }
//     }

//     action();
//   }
// }

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

  List<Plan> _plan = [];
  List<Goals> _goals = [];
  int _estimatedTime = 5;
  bool stop = false;

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> performTask(Message msg, String sender) async {
    print('Agent Pencarian received message from $sender');

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

        Message message = await action(p.goals, task, sender);

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
                print('Agent Pencarian returning data to ${message.receiver}');
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

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "cari gereja":
        return cariGereja(data, sender);
      case "cari aturan pelayanan":
        return cariAturanPelayanan(data, sender);
      case "cariPengumumanEdit":
        return cariPengumumanEdit(data, sender);
      case "cariPengumuman":
        return cariPengumuman(data, sender);
      case "cariBaptis":
        return cariBaptis(data, sender);
      case "cariBaptisPendaftaran":
        return cariBaptisPendaftaran(data, sender);
      case "cariEditBaptis":
        return cariEditBaptis(data, sender);
      case "cariBaptisUser":
        return cariBaptisUser(data, sender);
      case "cariRekoleksi":
        return cariRekoleksi(data, sender);
      case "cariUmumPendaftaran":
        return cariUmumPendaftaran(data, sender);
      case "cariRekoleksiHistory":
        return cariRekoleksiHistory(data, sender);
      case "cariRekoleksiUser":
        return cariRekoleksiUser(data, sender);
      case "cariRekoleksiUserHistory":
        return cariRekoleksiUserHistory(data, sender);
      case "cariSakramentali":
        return cariSakramentali(data, sender);
      case "cariPerkawinan":
        return cariPerkawinan(data, sender);
      case "cariHistoryPerkawinan":
        return cariHistoryPerkawinan(data, sender);
      case "cariSakramentaliHistory":
        return cariSakramentaliHistory(data, sender);
      case "cariSakramentaliDetail":
        return cariSakramentaliDetail(data, sender);
      case "cariPerkawinanDetail":
        return cariPerkawinanDetail(data, sender);
      case "cariJumlah":
        return cariJumlah(data, sender);
      case "cariJumlahSakramen":
        return cariJumlahSakramen(data, sender);
      case "cariJumlahUmum":
        return cariJumlahUmum(data, sender);
      default:
        return rejectTask(data.task, data.sender);
    }
  }

  Future<Message> cariGereja(dynamic data, String sender) async {
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
        .addStage(Match(where.eq('idGereja', data[1][0]).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(Match(where.eq('idGereja', data[1][0]).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(Match(where.eq('idGereja', data[1][0]).map['\$query']))
        .build();
    var countKr =
        await userKrismaCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(where.eq('idGereja', data[1][0]).map['\$query']))
        .build();
    var countU =
        await userKegiatanCollection.aggregateToStream(pipeline4).toList();

    var countP =
        await userPemberkatanCollection.find({'idGereja': data[1][0]}).length;

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
        .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
        .build();

    var conn = await userCollection.aggregateToStream(pipeline5).toList();

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('data pencarian gereja', [
          [conn],
          [totalB + totalKo + countP + totalKr + totalU]
        ]));
    return message;
  }

  Future<Message> cariAturanPelayanan(dynamic data, String sender) async {
    var aturanPelayananCollection =
        MongoDatabase.db.collection(ATURAN_PELAYANAN_COLLECTION);
    var conn =
        await aturanPelayananCollection.find({'idGereja': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', [conn]));
    return message;
  }

  Future<Message> cariPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var conn =
        await pengumumanCollection.find({'idGereja': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariBaptisUser(dynamic data, String sender) async {
    var userBaptisCollection =
        MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userBaptis'))
        .addStage(Match(
            where.eq('idBaptis', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var conn = await userBaptisCollection.aggregateToStream(pipeline).toList();

    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariPengumumanEdit(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var conn = await pengumumanCollection.find({'_id': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariBaptis(dynamic data, String sender) async {
    var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var conn = await baptisCollection
        .find({'idGereja': data[1][0], 'status': 0}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariBaptisPendaftaran(dynamic data, String sender) async {
    var userBaptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var conn = await userBaptisCollection.find({'_id': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariEditBaptis(dynamic data, String sender) async {
    var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);
    var conn = await baptisCollection.find({'_id': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariRekoleksi(dynamic data, String sender) async {
    var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var conn = await rekoleksiCollection.find({
      'idGereja': data[1][0],
      'jenisKegiatan': "Rekoleksi",
      'status': 0
    }).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariUmumPendaftaran(dynamic data, String sender) async {
    var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var conn = await rekoleksiCollection.find({'_id': data[1][0]}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariRekoleksiHistory(dynamic data, String sender) async {
    var rekoleksiCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var conn = await rekoleksiCollection.find({
      'idGereja': data[1][0],
      'jenisKegiatan': "Rekoleksi",
    }).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariRekoleksiUser(dynamic data, String sender) async {
    var userUmumCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userRekoleksi'))
        .addStage(Match(
            where.eq('idKegiatan', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var conn = await userUmumCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariRekoleksiUserHistory(dynamic data, String sender) async {
    var userUmumCollection = MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userRekoleksi'))
        .addStage(Match(
            where.eq('idKegiatan', data[1][0]).ne('status', 0).map['\$query']))
        .build();
    var conn = await userUmumCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariSakramentali(dynamic data, String sender) async {
    var PemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userDaftar'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var conn = await PemberkatanCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariPerkawinan(dynamic data, String sender) async {
    var PerkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userDaftar'))
        .addStage(Match(
            where.eq('idImam', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var conn = await PerkawinanCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariHistoryPerkawinan(dynamic data, String sender) async {
    var PerkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userDaftar'))
        .addStage(Match(
            where.eq('idImam', data[1][0]).ne('status', 0).map['\$query']))
        .build();
    var conn = await PerkawinanCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariSakramentaliHistory(dynamic data, String sender) async {
    var PemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    final pipeline = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'user',
            localField: 'idUser',
            foreignField: '_id',
            as: 'userDaftar'))
        .addStage(Match(where.eq('idGereja', data[1][0]).map['\$query']))
        .build();
    var conn = await PemberkatanCollection.aggregateToStream(pipeline).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', conn));
    return message;
  }

  Future<Message> cariSakramentaliDetail(dynamic data, String sender) async {
    var pemberkatanCollection =
        MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    var conn = await pemberkatanCollection.find({'_id': data[1][0]}).toList();

    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn2 = await userCollection.find({'_id': conn[0]['idUser']}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', [conn, conn2]));
    return message;
  }

  Future<Message> cariPerkawinanDetail(dynamic data, String sender) async {
    var perkawinanCollection =
        MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    var conn = await perkawinanCollection.find({'_id': data[1][0]}).toList();

    var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
    var conn2 = await userCollection.find({'_id': conn[0]['idUser']}).toList();
    Message message = Message('Agent Pencarian', sender, "INFORM",
        Tasks('data pencarian gereja', [conn, conn2]));
    return message;
  }

  Future<Message> cariJumlah(dynamic data, String sender) async {
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
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countKr =
        await userKrismaCollection.aggregateToStream(pipeline3).toList();

    final pipeline4 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countU =
        await userKegiatanCollection.aggregateToStream(pipeline4).toList();

    var countP = await userPemberkatanCollection
        .find({'idGereja': data[1][0], 'status': 0}).length;

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
        .find({'idImam': data[2][0], 'status': 0}).length;
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    final pipeliner = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'userGereja'))
        .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
        .build();
    var conn = await userCollection.aggregateToStream(pipeliner).toList();

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('data pencarian gereja', [
          totalB + totalKo + countP + totalKr + totalU + totalKa,
          totalB + totalKo + totalKr + totalKa,
          countP,
          totalU,
          conn
        ]));
    return message;
  }

  Future<Message> cariJumlahSakramen(dynamic data, String sender) async {
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
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countB =
        await userBaptisCollection.aggregateToStream(pipeline).toList();

    final pipeline2 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKomuni',
            localField: '_id',
            foreignField: 'idKomuni',
            as: 'userKomuni'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
        .build();
    var countKo =
        await userKomuniCollection.aggregateToStream(pipeline2).toList();

    final pipeline3 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userKrisma',
            localField: '_id',
            foreignField: 'idKrisma',
            as: 'userKrisma'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
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
        .find({'idImam': data[2][0], 'status': 0}).length;
    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    final pipeliner = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'userGereja'))
        .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
        .build();
    var conn = await userCollection.aggregateToStream(pipeliner).toList();

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('data pencarian gereja', [
          totalB + totalKo + totalKr + totalKa,
          totalB,
          totalKo,
          totalKr,
          totalKa,
          conn
        ]));
    return message;
  }

  Future<Message> cariJumlahUmum(dynamic data, String sender) async {
    var userKegiatanCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
    var count = 0;

    final pipeline1 = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'userUmum',
            localField: '_id',
            foreignField: 'idKegiatan',
            as: 'userKegiatan'))
        .addStage(Match(
            where.eq('idGereja', data[1][0]).eq('status', 0).map['\$query']))
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
            .eq('idGereja', data[1][0])
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
            .eq('idGereja', data[1][0])
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
            .eq('idGereja', data[1][0])
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

    var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

    final pipeliner = AggregationPipelineBuilder()
        .addStage(Lookup(
            from: 'Gereja',
            localField: 'idGereja',
            foreignField: '_id',
            as: 'userGereja'))
        .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
        .build();
    var conn = await userCollection.aggregateToStream(pipeliner).toList();

    Message message = Message(
        'Agent Pencarian',
        sender,
        "INFORM",
        Tasks('data pencarian gereja',
            [totalU1, totalU2, totalU3, totalU4, conn]));
    return message;
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Pencarian",
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print('Task rejected $sender: $task');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Pencarian",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    _plan = [
      Plan("cari gereja", "REQUEST", _estimatedTime),
      Plan("cari aturan pelayanan", "REQUEST", _estimatedTime),
      Plan("cari pengumuman Edit", "REQUEST", _estimatedTime),
      Plan("cari pengumuman", "REQUEST", _estimatedTime),
      Plan("cari baptis", "REQUEST", _estimatedTime),
      Plan("cari baptis Pendaftaran", "REQUEST", _estimatedTime),
      Plan("cari edit baptis", "REQUEST", _estimatedTime),
      Plan("cari baptis user", "REQUEST", _estimatedTime),
      Plan("cari rekoleksi", "REQUEST", _estimatedTime),
      Plan("cari umum pendaftaran", "REQUEST", _estimatedTime),
      Plan("cari rekoleksi history", "REQUEST", _estimatedTime),
      Plan("cari rekoleksi user", "REQUEST", _estimatedTime),
      Plan("cari rekoleksi user history", "REQUEST", _estimatedTime),
      Plan("cari sakramentali", "REQUEST", _estimatedTime),
      Plan("cari perkawinan", "REQUEST", _estimatedTime),
      Plan("cari history perkawinan", "REQUEST", _estimatedTime),
      Plan("cari sakramentali history", "REQUEST", _estimatedTime),
      Plan("cari sakramentali detail", "REQUEST", _estimatedTime),
      Plan("cari perkawinan detail", "REQUEST", _estimatedTime),
      Plan("cari jumlah", "REQUEST", _estimatedTime),
      Plan("cari jumlah sakramen", "REQUEST", _estimatedTime),
      Plan("cari jumlah umum", "REQUEST", _estimatedTime),
    ];
    _goals = [
      Goals("cari gereja", List<Map<String, Object?>>, 2),
      Goals("cari aturan pelayanan", List<Map<String, Object?>>, 2),
      Goals("cari pengumuman Edit", List<Map<String, Object?>>, 2),
      Goals("cari pengumuman", List<Map<String, Object?>>, 2),
      Goals("cari baptis", List<Map<String, Object?>>, 2),
      Goals("cari baptis Pendaftaran", List<Map<String, Object?>>, 2),
      Goals("cari edit baptis", List<Map<String, Object?>>, 2),
      Goals("cari baptis user", List<Map<String, Object?>>, 2),
      Goals("cari rekoleksi", List<Map<String, Object?>>, 2),
      Goals("cari umum pendaftaran", List<Map<String, Object?>>, 2),
      Goals("cari rekoleksi history", List<Map<String, Object?>>, 2),
      Goals("cari rekoleksi user", List<Map<String, Object?>>, 2),
      Goals("cari rekoleksi user history", List<Map<String, Object?>>, 2),
      Goals("cari sakramentali", List<Map<String, Object?>>, 2),
      Goals("cari perkawinan", List<Map<String, Object?>>, 2),
      Goals("cari history perkawinan", List<Map<String, Object?>>, 2),
      Goals("cari sakramentali history", List<Map<String, Object?>>, 2),
      Goals("cari sakramentali detail", List<Map<String, Object?>>, 2),
      Goals("cari perkawinan detail", List<Map<String, Object?>>, 2),
      Goals("cari jumlah", List<Map<String, Object?>>, 2),
      Goals("cari jumlah sakramen", List<Map<String, Object?>>, 2),
      Goals("cari jumlah umum", List<Map<String, Object?>>, 2),
    ];
  }
}
