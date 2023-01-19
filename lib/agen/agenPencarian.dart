import 'dart:developer';

import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenPencarian {
  AgenPencarian() {
    ReadyBehaviour();
    ResponsBehaviour();
    UpdateBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari Baptis") {
            var userBaptisCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            await userBaptisCollection
                .find({'idGereja': data[1][0], 'status': 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Baptis User") {
            var userBaptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userBaptis'))
                .addStage(Match(where
                    .eq('idBaptis', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userBaptisCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Komuni") {
            var userBaptisCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            await userBaptisCollection
                .find({'idGereja': data[1][0], 'status': 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Komuni User") {
            var userKomuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userKomuni'))
                .addStage(Match(where
                    .eq('idKomuni', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userKomuniCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Krisma") {
            var userBaptisCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            await userBaptisCollection
                .find({'idGereja': data[1][0], 'status': 0})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Krisma User") {
            var userKrismaCollection =
                MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userKrisma'))
                .addStage(Match(where
                    .eq('idKrisma', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userKrismaCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Rekoleksi") {
            var rekoleksiCollection =
                MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await rekoleksiCollection
                .find({
                  'idGereja': data[1][0],
                  'jenisKegiatan': "Rekoleksi",
                  'status': 0
                })
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Rekoleksi User") {
            var userUmumCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userRekoleksi'))
                .addStage(Match(where
                    .eq('idKegiatan', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userUmumCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Retret") {
            var rekoleksiCollection =
                MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await rekoleksiCollection
                .find({
                  'idGereja': data[1][0],
                  'jenisKegiatan': "Retret",
                  'status': 0
                })
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari Retret User") {
            var userUmumCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userRetret'))
                .addStage(Match(where
                    .eq('idKegiatan', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userUmumCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari PA") {
            var rekoleksiCollection =
                MongoDatabase.db.collection(UMUM_COLLECTION);
            var conn = await rekoleksiCollection
                .find({
                  'idGereja': data[1][0],
                  'jenisKegiatan': "Pendalaman Alkitab",
                  'status': 0
                })
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

          if (data[0][0] == "cari PA User") {
            var userUmumCollection =
                MongoDatabase.db.collection(USER_UMUM_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userPA'))
                .addStage(Match(where
                    .eq('idKegiatan', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await userUmumCollection
                .aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Sakramentali") {
            var PemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'user',
                    localField: 'idUser',
                    foreignField: '_id',
                    as: 'userDaftar'))
                .addStage(Match(where
                    .eq('idGereja', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var conn = await PemberkatanCollection.aggregateToStream(pipeline)
                .toList()
                .then((result) async {
              msg.addReceiver("agenPage");
              msg.setContent(result);
              await msg.send();
            });
          }

          if (data[0][0] == "cari Sakramentali Detail") {
            var pemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var conn = await pemberkatanCollection
                .find({'_id': data[1][0]})
                .toList()
                .then((result) async {
                  msg.addReceiver("agenPage");
                  msg.setContent(result);
                  await msg.send();
                });
          }

/////cari jumlah
          if (data[0][0] == "cari jumlah") {
            var userKrismaCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            var userBaptisCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            var userKomuniCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            var userPemberkatanCollection =
                MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
            var userKegiatanCollection =
                MongoDatabase.db.collection(UMUM_COLLECTION);
            var count = 0;

            final pipeline = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'userBaptis',
                    localField: '_id',
                    foreignField: 'idBaptis',
                    as: 'userBaptis'))
                .addStage(Match(where
                    .eq('idGereja', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var countB =
                await userBaptisCollection.aggregateToStream(pipeline).toList();

            final pipeline2 = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'userKomuni',
                    localField: '_id',
                    foreignField: 'idKomuni',
                    as: 'userKomuni'))
                .addStage(Match(where
                    .eq('idGereja', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var countKo = await userKomuniCollection
                .aggregateToStream(pipeline2)
                .toList();

            final pipeline3 = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'userKrisma',
                    localField: '_id',
                    foreignField: 'idKrisma',
                    as: 'userKrisma'))
                .addStage(Match(where
                    .eq('idGereja', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var countKr = await userKrismaCollection
                .aggregateToStream(pipeline3)
                .toList();

            final pipeline4 = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'userUmum',
                    localField: '_id',
                    foreignField: 'idKegiatan',
                    as: 'userKegiatan'))
                .addStage(Match(where
                    .eq('idGereja', data[1][0])
                    .eq('status', 0)
                    .map['\$query']))
                .build();
            var countU = await userKegiatanCollection
                .aggregateToStream(pipeline4)
                .toList();

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

            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);

            final pipeliner = AggregationPipelineBuilder()
                .addStage(Lookup(
                    from: 'Gereja',
                    localField: 'idGereja',
                    foreignField: '_id',
                    as: 'userGereja'))
                .addStage(Match(where.eq('_id', data[2][0]).map['\$query']))
                .build();
            var conn = await userCollection
                .aggregateToStream(pipeliner)
                .toList()
                .then((res) async {
              msg.addReceiver("agenPage");
              msg.setContent([
                totalB + totalKo + countP + totalKr + totalU,
                totalB + totalKo + totalKr,
                countP,
                totalU,
                res
              ]);
              await msg.send();
            });
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  UpdateBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    print(data.runtimeType);
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
          if (data[0][0] == "cari user") {
            print("nih");
            print(data);
            var userCollection = MongoDatabase.db.collection(IMAM_COLLECTION);
            var conn = await userCollection
                .find({'email': data[1][0], 'password': data[2][0]})
                .toList()
                .then((result) async {
                  print(result);

                  if (result != 0) {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  } else {
                    msg.addReceiver("agenPage");
                    msg.setContent(result);
                    await msg.send();
                  }
                });
          }

          if (data[0][0] == "update Baptis") {
            var baptisCollection =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);
            try {
              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }

          if (data[0][0] == "update Baptis User") {
            var baptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);

            try {
              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }

          if (data[0][0] == "update Komuni") {
            var komuniCollection =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);
            try {
              var update = await komuniCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }

          if (data[0][0] == "update Komuni User") {
            var komuniCollection =
                MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);

            try {
              var update = await komuniCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }

          if (data[0][0] == "update Krisma") {
            var krismaCollection =
                MongoDatabase.db.collection(KRISMA_COLLECTION);
            try {
              var update = await krismaCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[2][0]))
                  .then((result) async {
                if (result.isSuccess) {
                  msg.addReceiver("agenPage");
                  msg.setContent('oke');
                  await msg.send();
                } else {
                  msg.addReceiver("agenPage");
                  msg.setContent('failed');
                  await msg.send();
                }
              });
            } catch (e) {
              msg.addReceiver("agenPage");
              msg.setContent('failed');
              await msg.send();
            }
          }
        }

        if (data[0][0] == "update Krisma User") {
          var krismaCollection =
              MongoDatabase.db.collection(USER_KRISMA_COLLECTION);

          try {
            var update = await krismaCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('status', data[2][0]))
                .then((result) async {
              if (result.isSuccess) {
                msg.addReceiver("agenPage");
                msg.setContent('oke');
                await msg.send();
              } else {
                msg.addReceiver("agenPage");
                msg.setContent('failed');
                await msg.send();
              }
            });
          } catch (e) {
            msg.addReceiver("agenPage");
            msg.setContent('failed');
            await msg.send();
          }
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "ready") {
          print("Agen Pencarian Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
