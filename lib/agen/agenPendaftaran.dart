import 'dart:convert';
import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../DatabaseFolder/mongodb.dart';
import 'messages.dart';
import 'package:http/http.dart' as http;

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
            print(data[3][0].runtimeType);
            var baptisCollection =
                MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
            String status = "";
            String body = "";
            if (data[4][0] == 1) {
              status = "Permintaan Baptis Diterima";
              body = "Ada permintaan baptis yang telah di konfirmasi";
            } else {
              status = "Permintaan Baptis Ditolak";
              body = "Maaf, permintaan baptis anda ditolak";
            }
            try {
              String constructFCMPayload(String token) {
                return jsonEncode({
                  // 'token': dotenv.env['token_firebase'],
                  'to': token,
                  'data': {
                    'via': 'FlutterFire Cloud Messaging!!!',
                    // 'id': data[3][0].toString(),
                  },
                  'notification': {
                    'title': status,
                    'body': body,
                  },
                });
              }

              try {
                await http
                    .post(
                  Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':
                        'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
                  },
                  body: constructFCMPayload(data[2][0]),
                )
                    .then((value) {
                  print(value.statusCode);
                  print(value.body);
                });
              } catch (e) {
                print(e);
              }

              print('FCM request for device sent!');
              var update = await baptisCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[4][0]))
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
            String status = "";
            String body = "";
            if (data[4][0] == 1) {
              status = "Permintaan Komuni Diterima";
              body = "Ada permintaan komuni yang telah di konfirmasi";
            } else {
              status = "Permintaan Komuni Ditolak";
              body = "Maaf, permintaan komuni anda ditolak";
            }

            String constructFCMPayload(String token) {
              return jsonEncode({
                // 'token': dotenv.env['token_firebase'],
                'to': token,
                'data': {
                  'via': 'FlutterFire Cloud Messaging!!!',
                  // 'id': data[3][0].toString(),
                },
                'notification': {
                  'title': status,
                  'body': body,
                },
              });
            }

            try {
              await http
                  .post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization':
                      'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
                },
                body: constructFCMPayload(data[2][0]),
              )
                  .then((value) {
                print(value.statusCode);
                print(value.body);
              });
            } catch (e) {
              print(e);
            }

            try {
              var update = await komuniCollection
                  .updateOne(where.eq('_id', data[1][0]),
                      modify.set('status', data[4][0]))
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
          String status = "";
          String body = "";
          if (data[4][0] == 1) {
            status = "Permintaan Krisma Diterima";
            body = "Ada permintaan krisma yang telah di konfirmasi";
          } else {
            status = "Permintaan Krisma Ditolak";
            body = "Maaf, permintaan krisma anda ditolak";
          }

          String constructFCMPayload(String token) {
            return jsonEncode({
              // 'token': dotenv.env['token_firebase'],
              'to': token,
              'data': {
                'via': 'FlutterFire Cloud Messaging!!!',
                // 'id': data[3][0].toString(),
              },
              'notification': {
                'title': status,
                'body': body,
              },
            });
          }

          try {
            await http
                .post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
              },
              body: constructFCMPayload(data[2][0]),
            )
                .then((value) {
              print(value.statusCode);
              print(value.body);
            });
          } catch (e) {
            print(e);
          }

          try {
            var update = await krismaCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('status', data[4][0]))
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
          String status = "";
          String body = "";
          if (data[4][0] == 1) {
            status = "Permintaan Kegiatan Diterima";
            body = "Ada permintaan kegiatan yang telah di konfirmasi";
          } else {
            status = "Permintaan Kegiatan Ditolak";
            body = "Maaf, permintaan kegiatan anda ditolak";
          }

          String constructFCMPayload(String token) {
            return jsonEncode({
              // 'token': dotenv.env['token_firebase'],
              'to': token,
              'data': {
                'via': 'FlutterFire Cloud Messaging!!!',
                // 'id': data[3][0].toString(),
              },
              'notification': {
                'title': status,
                'body': body,
              },
            });
          }

          try {
            await http
                .post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
              },
              body: constructFCMPayload(data[2][0]),
            )
                .then((value) {
              print(value.statusCode);
              print(value.body);
            });
          } catch (e) {
            print(e);
          }

          try {
            var update = await kegiatanCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('status', data[4][0]))
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

          String status = "";
          String body = "";
          if (data[4][0] == 1) {
            status = "Permintaan Pemberkatan Diterima";
            body = "Ada permintaan pemberkatan yang telah di konfirmasi";
          } else {
            status = "Permintaan Pemberkatan Ditolak";
            body = "Maaf, permintaan pemberkatan anda ditolak";
          }

          String constructFCMPayload(String token) {
            return jsonEncode({
              // 'token': dotenv.env['token_firebase'],
              'to': token,
              'data': {
                'via': 'FlutterFire Cloud Messaging!!!',
                // 'id': data[3][0].toString(),
              },
              'notification': {
                'title': status,
                'body': body,
              },
            });
          }

          try {
            await http
                .post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization':
                    'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
              },
              body: constructFCMPayload(data[2][0]),
            )
                .then((value) {
              print(value.statusCode);
              print(value.body);
            });
          } catch (e) {
            print(e);
          }

          try {
            var update = await baptisCollection
                .updateOne(where.eq('_id', data[1][0]),
                    modify.set('status', data[4][0]))
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

        if (data[0][0] == "edit Pengumuman") {
          var pengumumanCollection =
              MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

          if (data[5][0] == true) {
            DateTime now = new DateTime.now();
            DateTime date = new DateTime(
                now.year, now.month, now.day, now.hour, now.minute, now.second);
            final filename = date.toString();
            final destination = 'files/$filename';
            UploadTask? task = FirebaseApi.uploadFile(destination, data[4][0]);
            final snapshot = await task!.whenComplete(() {});
            final urlDownload = await snapshot.ref.getDownloadURL();

            try {
              var update = await pengumumanCollection
                  .updateOne(
                      where.eq('_id', data[1][0]),
                      modify
                          .set('title', data[2][0])
                          .set("caption", data[3][0])
                          .set("gambar", urlDownload))
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
          } else {
            try {
              var update = await pengumumanCollection
                  .updateOne(
                      where.eq('_id', data[1][0]),
                      modify
                          .set('title', data[2][0])
                          .set("caption", data[3][0]))
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

        if (data[0][0] == "add Pengumuman") {
          var PengumumanCollection =
              MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(
              now.year, now.month, now.day, now.hour, now.minute, now.second);
          final filename = date.toString();
          final destination = 'files/$filename';
          UploadTask? task = FirebaseApi.uploadFile(destination, data[2][0]);
          final snapshot = await task!.whenComplete(() {});
          final urlDownload = await snapshot.ref.getDownloadURL();

          try {
            var hasil = await PengumumanCollection.insertOne({
              'idGereja': data[1][0],
              'gambar': urlDownload,
              'caption': data[3][0],
              'tanggal': DateTime.now(),
              'status': 0,
              'title': data[4][0]
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

        if (data[0][0] == "update Pengumuman") {
          var pengumumanCollection =
              MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

          try {
            var update = await pengumumanCollection
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
