import 'dart:developer';

import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';

class AgenPendaftaran {
  AgenPendaftaran() {
    ReadyBehaviour();
    ResponsBehaviour();
  }

  ResponsBehaviour() {
    Messages msg = Messages();

    var data = msg.receive();
    print(data.runtimeType);
    action() async {
      try {
        if (data.runtimeType == List<List<dynamic>>) {
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

        if (data[0][0] == "update Kegiatan") {
          var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
          try {
            var update = await umumCollection
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

        if (data[0][0] == "update Kegiatan User") {
          var kegiatanCollection =
              MongoDatabase.db.collection(USER_UMUM_COLLECTION);

          try {
            var update = await kegiatanCollection
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

        if (data[0][0] == "update Sakramentali") {
          var baptisCollection =
              MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);

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

        if (data[0][0] == "add Baptis") {
          var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);

          try {
            var hasil = await baptisCollection.insertOne({
              'idGereja': data[1][0],
              'kapasitas': int.parse(data[2][0]),
              'jadwalBuka': DateTime.parse(data[3][0]),
              'jadwalTutup': DateTime.parse(data[4][0]),
              'status': 0
            }).then((result) async {
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

        if (data[0][0] == "add Komuni") {
          var komuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);
          try {
            var hasil = await komuniCollection.insertOne({
              'idGereja': data[1][0],
              'kapasitas': int.parse(data[2][0]),
              'jadwalBuka': DateTime.parse(data[3][0]),
              'jadwalTutup': DateTime.parse(data[4][0]),
              'status': 0
            }).then((result) async {
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

        if (data[0][0] == "add Krisma") {
          var krismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);
          try {
            var hasil = await krismaCollection.insertOne({
              'idGereja': data[1][0],
              'kapasitas': int.parse(data[2][0]),
              'jadwalBuka': DateTime.parse(data[3][0]),
              'jadwalTutup': DateTime.parse(data[4][0]),
              'status': 0
            }).then((result) async {
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

        if (data[0][0] == "add Kegiatan") {
          var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
          try {
            var hasil = await umumCollection.insertOne({
              'idGereja': data[1][0],
              'namaKegiatan': data[2][0],
              'temaKegiatan': data[3][0],
              'jenisKegiatan': data[4][0],
              'deskripsiKegiatan': data[5][0],
              'tamu': data[6][0],
              'tanggal': DateTime.parse(data[7][0]),
              'kapasitas': int.parse(data[8][0]),
              'lokasi': data[9][0],
              'status': 0
            }).then((result) async {
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
