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
          var countKo =
              await userKomuniCollection.aggregateToStream(pipeline2).toList();

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
          var countKr =
              await userKrismaCollection.aggregateToStream(pipeline3).toList();

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

          if (data[0][0] == "update user") {
            var userCollection = MongoDatabase.db.collection(USER_COLLECTION);
            try {
              var update = await userCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('banned', data[2][0]))
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
              msg.setContent('fail');
              await msg.send();
            }
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
