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

            var baptisCollection2 =
                MongoDatabase.db.collection(BAPTIS_COLLECTION);

            //Find date baptis
            var conn2 =
                await baptisCollection2.find({'_id': data[3][0]}).toList();
            print(conn2);
            String status = "";
            String body = "";
            if (data[4][0] == 1) {
              status = "Permintaan Baptis Diterima";
              body = "Permintaan baptis pada tanggal " +
                  conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                  " telah dikonfirmasi";
            } else {
              status = "Permintaan Baptis Ditolak";
              body = "Maaf, permintaan baptis pada tanggal " +
                  conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                  " ditolak";
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
            var komuniCollection2 =
                MongoDatabase.db.collection(KOMUNI_COLLECTION);

            //Find date baptis
            var conn2 =
                await komuniCollection2.find({'_id': data[3][0]}).toList();
            print(conn2);
            String status = "";
            String body = "";
            if (data[4][0] == 1) {
              status = "Permintaan Komuni Diterima";
              body = "Permintaan komuni pada tanggal " +
                  conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                  " telah dikonfirmasi";
            } else {
              status = "Permintaan Komuni Ditolak";
              body = "Maaf, permintaan komuni pada tanggal " +
                  conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                  " ditolak";
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
          var krismaCollection2 =
              MongoDatabase.db.collection(KRISMA_COLLECTION);

          //Find date baptis
          var conn2 =
              await krismaCollection2.find({'_id': data[3][0]}).toList();
          print(conn2);
          String status = "";
          String body = "";
          if (data[4][0] == 1) {
            status = "Permintaan Krisma Diterima";
            body = "Permintaan krisma pada tanggal " +
                conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                " telah dikonfirmasi";
          } else {
            status = "Permintaan Krisma Ditolak";
            body = "Maaf, permintaan krisma pada tanggal " +
                conn2[0]['jadwalBuka'].toString().substring(0, 10) +
                " ditolak";
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
          var kegiatanCollection2 =
              MongoDatabase.db.collection(UMUM_COLLECTION);
          print(data[3][0]);
          //Find date baptis
          var conn2 =
              await kegiatanCollection2.find({'_id': data[3][0]}).toList();
          print(conn2);
          String status = "";
          String body = "";
          if (data[4][0] == 1) {
            status = "Permintaan Kegiatan Diterima";
            body = "Permintaan kegiatan " +
                conn2[0]['jenisKegiatan'] +
                " " +
                conn2[0]['namaKegiatan'] +
                " telah dikonfirmasi";
          } else {
            status = "Permintaan Kegiatan Ditolak";
            body = "Permintaan kegiatan " +
                conn2[0]['jenisKegiatan'] +
                " " +
                conn2[0]['namaKegiatan'] +
                " ditolak";
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
          print(DateTime.parse(data[3][0]));
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
            print(e);
            msg.addReceiver("agenPage");
            msg.setContent('failed');
            await msg.send();
          }
        }

        if (data[0][0] == "edit Baptis") {
          print(DateTime.parse(data[3][0]));
          var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);

          try {
            var hasil = await baptisCollection
                .updateOne(
                    where.eq('_id', data[1][0]),
                    modify
                        .set("kapasitas", int.parse(data[2][0]))
                        .set("jadwalBuka", DateTime.parse(data[3][0]))
                        .set("jadwalTutup", DateTime.parse(data[4][0])))
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
            print(e);
            msg.addReceiver("agenPage");
            msg.setContent('failed');
            await msg.send();
          }
        }

        if (data[0][0] == "edit Komuni") {
          print(DateTime.parse(data[3][0]));
          var komuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);

          try {
            var hasil = await komuniCollection
                .updateOne(
                    where.eq('_id', data[1][0]),
                    modify
                        .set("kapasitas", int.parse(data[2][0]))
                        .set("jadwalBuka", DateTime.parse(data[3][0]))
                        .set("jadwalTutup", DateTime.parse(data[4][0])))
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
            print(e);
            msg.addReceiver("agenPage");
            msg.setContent('failed');
            await msg.send();
          }
        }

        if (data[0][0] == "edit Krisma") {
          print(DateTime.parse(data[3][0]));
          var krismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);

          try {
            var hasil = await krismaCollection
                .updateOne(
                    where.eq('_id', data[1][0]),
                    modify
                        .set("kapasitas", int.parse(data[2][0]))
                        .set("jadwalBuka", DateTime.parse(data[3][0]))
                        .set("jadwalTutup", DateTime.parse(data[4][0])))
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
            print(e);
            msg.addReceiver("agenPage");
            msg.setContent('failed');
            await msg.send();
          }
        }

        if (data[0][0] == "edit Kegiatan") {
          var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
          // 'idGereja': data[1][0],
          //             'namaKegiatan': data[2][0],
          //             'temaKegiatan': data[3][0],
          //             'jenisKegiatan': data[4][0],
          //             'deskripsiKegiatan': data[5][0],
          //             'tamu': data[6][0],
          //             'tanggal': DateTime.parse(data[7][0]),
          //             'kapasitas': int.parse(data[8][0]),
          //             'lokasi': data[9][0],
          try {
            var hasil = await umumCollection
                .updateOne(
                    where.eq('_id', data[1][0]),
                    modify
                        .set('namaKegiatan', data[2][0])
                        .set('temaKegiatan', data[3][0])
                        .set("jenisKegiatan", data[4][0])
                        .set("deskripsiKegiatan", data[5][0])
                        .set("tamu", data[6][0])
                        .set("tanggal", DateTime.parse(data[7][0]))
                        .set("kapasitas", int.parse(data[8][0]))
                        .set("lokasi", data[9][0]))
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
            print(e);
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
