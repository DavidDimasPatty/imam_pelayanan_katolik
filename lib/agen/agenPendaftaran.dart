// import 'dart:convert';
// import 'dart:developer';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
// import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import '../DatabaseFolder/mongodb.dart';
// import 'messages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

// class AgenPendaftaran {
//   static var dataPencarian;
//   AgenPendaftaran() {
//     ReadyBehaviour();
//     ReceiveBehaviour();
//     ResponsBehaviour();
//   }

//   setDataTampilan(data) {
//     dataPencarian = data;
//   }

//   receiverTampilan() {
//     return dataPencarian;
//   }

//   ReceiveBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     print("APAANIH DATANYA");
//     print(data.runtimeType);
//     action() async {
//       try {
//         if (data.runtimeType == List<Map<String, Object?>>) {
//           await setDataTampilan(data);
//         }
//       } catch (e) {}
//     }

//     action();
//   }

//   ResponsBehaviour() {
//     Messages msg = Messages();

//     var data = msg.receive();
//     action() async {
//       try {
//         if (data.runtimeType == List<List<dynamic>>) {
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

//             var baptisCollection2 =
//                 MongoDatabase.db.collection(BAPTIS_COLLECTION);

//             // var conn2 =
//             //     await baptisCollection2.find({'_id': data[3][0]}).toList();

//             await msg.addReceiver("agenPencarian");
//             await msg.setContent([
//               ["cari Baptis Pendaftaran"],
//               [data[3][0]]
//             ]);
//             await msg.send();
//             var conn2 = await receiverTampilan();

//             String status = "";
//             String body = "";
//             String statusSoon = "";
//             String bodySoon = "";
//             if (data[4][0] == 1) {
//               status = "Permintaan Baptis Diterima";
//               body = "Permintaan baptis pada tanggal " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " telah dikonfirmasi";
//               statusSoon = "Baptis " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10);
//               bodySoon = "Besok, Baptis " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " Akan Dilaksakan";
//             } else {
//               status = "Permintaan Baptis Ditolak";
//               body = "Maaf, permintaan baptis pada tanggal " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " ditolak";
//             }
//             try {
//               String constructFCMPayload(String token) {
//                 return jsonEncode({
//                   // 'token': dotenv.env['token_firebase'],
//                   'to': token,
//                   'data': {
//                     'via': 'FlutterFire Cloud Messaging!!!',
//                     // 'id': data[3][0].toString(),
//                   },
//                   'notification': {
//                     'title': status,
//                     'body': body,
//                   },
//                 });
//               }

//               String constructFCMPayloadSoon(String token) {
//                 return jsonEncode({
//                   // 'token': dotenv.env['token_firebase'],
//                   'to': token,
//                   'data': {
//                     "title": statusSoon,
//                     "message": bodySoon,
//                     // 'id': data[3][0].toString(),
//                     "isScheduled": "true",
//                     "scheduledTime": conn2[0]['jadwalBuka']
//                         .subtract(Duration(days: 1))
//                         .toString()
//                   },
//                   // 'notification': {
//                   //   'title': statusSoon,
//                   //   'body': bodySoon,
//                   // "isScheduled": "true",
//                   // "scheduledTime": conn2[0]['jadwalBuka']
//                   //     .subtract(Duration(days: 1))
//                   //     .toString()
//                 });
//               }

//               try {
//                 if (data[4][0] == 1) {
//                   await http
//                       .post(
//                     Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                     headers: <String, String>{
//                       'Content-Type': 'application/json; charset=UTF-8',
//                       'Authorization':
//                           'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                     },
//                     body: constructFCMPayloadSoon(data[2][0]),
//                   )
//                       .then((value) {
//                     print(value.statusCode);
//                     print(value.body);
//                     print("success fcm for soon!");
//                   });
//                 }
//                 await http
//                     .post(
//                   Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                   headers: <String, String>{
//                     'Content-Type': 'application/json; charset=UTF-8',
//                     'Authorization':
//                         'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                   },
//                   body: constructFCMPayload(data[2][0]),
//                 )
//                     .then((value) {
//                   print(value.statusCode);
//                   print(value.body);
//                 });
//               } catch (e) {
//                 print(e);
//               }

//               print('FCM request for device sent!');
//               var update = await baptisCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[4][0]))
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
//             var komuniCollection2 =
//                 MongoDatabase.db.collection(KOMUNI_COLLECTION);

//             //Find date baptis
//             // var conn2 =
//             //     await komuniCollection2.find({'_id': data[3][0]}).toList();

//             await msg.addReceiver("agenPencarian");
//             await msg.setContent([
//               ["cari Komuni Pendaftaran"],
//               [data[3][0]]
//             ]);
//             await msg.send();
//             var conn2 = await receiverTampilan();

//             String status = "";
//             String body = "";
//             String statusSoon = "";
//             String bodySoon = "";
//             if (data[4][0] == 1) {
//               status = "Permintaan Komuni Diterima";
//               body = "Permintaan komuni pada tanggal " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " telah dikonfirmasi";
//               statusSoon = "Komuni " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10);
//               bodySoon = "Besok, Komuni " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " Akan Dilaksakan";
//             } else {
//               status = "Permintaan Komuni Ditolak";
//               body = "Maaf, permintaan komuni pada tanggal " +
//                   conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                   " ditolak";
//             }

//             String constructFCMPayload(String token) {
//               return jsonEncode({
//                 // 'token': dotenv.env['token_firebase'],
//                 'to': token,
//                 'data': {
//                   'via': 'FlutterFire Cloud Messaging!!!',
//                   // 'id': data[3][0].toString(),
//                 },
//                 'notification': {
//                   'title': status,
//                   'body': body,
//                 },
//               });
//             }

//             String constructFCMPayloadSoon(String token) {
//               return jsonEncode({
//                 // 'token': dotenv.env['token_firebase'],
//                 'to': token,
//                 'data': {
//                   "title": statusSoon,
//                   "message": bodySoon,
//                   // 'id': data[3][0].toString(),
//                   "isScheduled": "true",
//                   "scheduledTime": conn2[0]['jadwalBuka']
//                       .subtract(Duration(days: 1))
//                       .toString()
//                 },
//                 // 'notification': {
//                 //   'title': statusSoon,
//                 //   'body': bodySoon,
//                 // "isScheduled": "true",
//                 // "scheduledTime": conn2[0]['jadwalBuka']
//                 //     .subtract(Duration(days: 1))
//                 //     .toString()
//               });
//             }

//             try {
//               if (data[4][0] == 1) {
//                 await http
//                     .post(
//                   Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                   headers: <String, String>{
//                     'Content-Type': 'application/json; charset=UTF-8',
//                     'Authorization':
//                         'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                   },
//                   body: constructFCMPayloadSoon(data[2][0]),
//                 )
//                     .then((value) {
//                   print(value.statusCode);
//                   print(value.body);
//                   print("success fcm for soon!");
//                 });
//               }
//               await http
//                   .post(
//                 Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                 headers: <String, String>{
//                   'Content-Type': 'application/json; charset=UTF-8',
//                   'Authorization':
//                       'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                 },
//                 body: constructFCMPayload(data[2][0]),
//               )
//                   .then((value) {
//                 print(value.statusCode);
//                 print(value.body);
//               });
//             } catch (e) {
//               print(e);
//             }

//             try {
//               var update = await komuniCollection
//                   .updateOne(where.eq('_id', data[1][0]),
//                       modify.set('status', data[4][0]))
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
//           var krismaCollection2 =
//               MongoDatabase.db.collection(KRISMA_COLLECTION);

//           //Find date baptis
//           // var conn2 =
//           //     await krismaCollection2.find({'_id': data[3][0]}).toList();
//           await msg.addReceiver("agenPencarian");
//           await msg.setContent([
//             ["cari Krisma Pendaftaran"],
//             [data[3][0]]
//           ]);
//           await msg.send();
//           var conn2 = await receiverTampilan();
//           String status = "";
//           String body = "";
//           String statusSoon = "";
//           String bodySoon = "";
//           if (data[4][0] == 1) {
//             status = "Permintaan Krisma Diterima";
//             body = "Permintaan krisma pada tanggal " +
//                 conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                 " telah dikonfirmasi";
//             statusSoon =
//                 "Krisma " + conn2[0]['jadwalBuka'].toString().substring(0, 10);
//             bodySoon = "Besok, Krisma " +
//                 conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                 " Akan Dilaksakan";
//           } else {
//             status = "Permintaan Krisma Ditolak";
//             body = "Maaf, permintaan krisma pada tanggal " +
//                 conn2[0]['jadwalBuka'].toString().substring(0, 10) +
//                 " ditolak";
//           }

//           String constructFCMPayload(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 'via': 'FlutterFire Cloud Messaging!!!',
//                 // 'id': data[3][0].toString(),
//               },
//               'notification': {
//                 'title': status,
//                 'body': body,
//               },
//             });
//           }

//           String constructFCMPayloadSoon(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 "title": statusSoon,
//                 "message": bodySoon,
//                 // 'id': data[3][0].toString(),
//                 "isScheduled": "true",
//                 "scheduledTime": conn2[0]['jadwalBuka']
//                     .subtract(Duration(days: 1))
//                     .toString()
//               },
//               // 'notification': {
//               //   'title': statusSoon,
//               //   'body': bodySoon,
//               // "isScheduled": "true",
//               // "scheduledTime": conn2[0]['jadwalBuka']
//               //     .subtract(Duration(days: 1))
//               //     .toString()
//             });
//           }

//           try {
//             if (data[4][0] == 1) {
//               await http
//                   .post(
//                 Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                 headers: <String, String>{
//                   'Content-Type': 'application/json; charset=UTF-8',
//                   'Authorization':
//                       'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                 },
//                 body: constructFCMPayloadSoon(data[2][0]),
//               )
//                   .then((value) {
//                 print(value.statusCode);
//                 print(value.body);
//                 print("success fcm for soon!");
//               });
//             }
//             await http
//                 .post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':
//                     'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//               },
//               body: constructFCMPayload(data[2][0]),
//             )
//                 .then((value) {
//               print(value.statusCode);
//               print(value.body);
//             });
//           } catch (e) {
//             print(e);
//           }

//           try {
//             var update = await krismaCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[4][0]))
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
//           var kegiatanCollection2 =
//               MongoDatabase.db.collection(UMUM_COLLECTION);

//           // var conn2 =
//           //     await kegiatanCollection2.find({'_id': data[3][0]}).toList();

//           String status = "";
//           String body = "";
//           String statusSoon = "";
//           String bodySoon = "";

//           await msg.addReceiver("agenPencarian");
//           await msg.setContent([
//             ["cari Umum Pendaftaran"],
//             [data[3][0]]
//           ]);
//           await msg.send();
//           var conn2 = await receiverTampilan();

//           if (data[4][0] == 1) {
//             print("lawai");
//             print(conn2);
//             status = "Permintaan Kegiatan Diterima";
//             body = "Permintaan kegiatan " +
//                 conn2[0]['jenisKegiatan'] +
//                 " " +
//                 conn2[0]['namaKegiatan'] +
//                 " telah dikonfirmasi";
//             statusSoon = "Kegiatan " +
//                 conn2[0]['namaKegiatan'].toString().substring(0, 10);
//             bodySoon = "Besok, Kegiatan " +
//                 conn2[0]['namaKegiatan'].toString().substring(0, 10) +
//                 " Akan Dilaksakan";
//           } else {
//             status = "Permintaan Kegiatan Ditolak";
//             body = "Permintaan kegiatan " +
//                 conn2[0]['jenisKegiatan'] +
//                 " " +
//                 conn2[0]['namaKegiatan'] +
//                 " ditolak";
//           }

//           print("OVER HEREEEE");

//           String constructFCMPayload(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 'via': 'FlutterFire Cloud Messaging!!!',
//                 // 'id': data[3][0].toString(),
//               },
//               'notification': {
//                 'title': status,
//                 'body': body,
//               },
//             });
//           }

//           String constructFCMPayloadSoon(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 "title": statusSoon,
//                 "message": bodySoon,
//                 // 'id': data[3][0].toString(),
//                 "isScheduled": "true",
//                 "scheduledTime":
//                     conn2[0]['tanggal'].subtract(Duration(days: 1)).toString()
//               },
//               // 'notification': {
//               //   'title': statusSoon,
//               //   'body': bodySoon,
//               // "isScheduled": "true",
//               // "scheduledTime": conn2[0]['jadwalBuka']
//               //     .subtract(Duration(days: 1))
//               //     .toString()
//             });
//           }

//           try {
//             if (data[4][0] == 1) {
//               await http
//                   .post(
//                 Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                 headers: <String, String>{
//                   'Content-Type': 'application/json; charset=UTF-8',
//                   'Authorization':
//                       'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//                 },
//                 body: constructFCMPayloadSoon(data[2][0]),
//               )
//                   .then((value) {
//                 print(value.statusCode);
//                 print(value.body);
//                 print("success fcm for soon!");
//               });
//             }
//             await http
//                 .post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':
//                     'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//               },
//               body: constructFCMPayload(data[2][0]),
//             )
//                 .then((value) {
//               print(value.statusCode);
//               print(value.body);
//             });
//           } catch (e) {
//             print(e);
//           }

//           try {
//             var update = await kegiatanCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[4][0]))
//                 .then((result) async {
//               if (result.isSuccess) {
//                 await msg.addReceiver("agenPage");
//                 await msg.setContent('oke');
//                 await msg.send();
//               } else {
//                 await msg.addReceiver("agenPage");
//                 await msg.setContent('failed');
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
//           var pemberkatanCollection =
//               MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);

//           String status = "";
//           String body = "";
//           if (data[4][0] == 1) {
//             status = "Permintaan Pemberkatan Diterima";
//             body = "Ada permintaan pemberkatan yang telah di konfirmasi";
//           } else {
//             status = "Permintaan Pemberkatan Ditolak";
//             body = "Maaf, permintaan pemberkatan anda ditolak";
//           }

//           String constructFCMPayload(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 'via': 'FlutterFire Cloud Messaging!!!',
//                 // 'id': data[3][0].toString(),
//               },
//               'notification': {
//                 'title': status,
//                 'body': body,
//               },
//             });
//           }

//           try {
//             await http
//                 .post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':
//                     'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//               },
//               body: constructFCMPayload(data[2][0]),
//             )
//                 .then((value) {
//               print(value.statusCode);
//               print(value.body);
//             });
//           } catch (e) {
//             print(e);
//           }

//           try {
//             var update = await pemberkatanCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[4][0]))
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

//         if (data[0][0] == "update Perkawinan") {
//           var perkawinanCollection =
//               MongoDatabase.db.collection(PERKAWINAN_COLLECTION);

//           String status = "";
//           String body = "";
//           if (data[4][0] == 1) {
//             status = "Permintaan Perkawinan Diterima";
//             body = "Ada permintaan perkawinan yang telah di konfirmasi";
//           } else {
//             status = "Permintaan Perkawinan Ditolak";
//             body = "Maaf, permintaan perkawinan anda ditolak";
//           }

//           String constructFCMPayload(String token) {
//             return jsonEncode({
//               // 'token': dotenv.env['token_firebase'],
//               'to': token,
//               'data': {
//                 'via': 'FlutterFire Cloud Messaging!!!',
//                 // 'id': data[3][0].toString(),
//               },
//               'notification': {
//                 'title': status,
//                 'body': body,
//               },
//             });
//           }

//           try {
//             await http
//                 .post(
//               Uri.parse('https://fcm.googleapis.com/fcm/send'),
//               headers: <String, String>{
//                 'Content-Type': 'application/json; charset=UTF-8',
//                 'Authorization':
//                     'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
//               },
//               body: constructFCMPayload(data[2][0]),
//             )
//                 .then((value) {
//               print(value.statusCode);
//               print(value.body);
//             });
//           } catch (e) {
//             print(e);
//           }

//           try {
//             var update = await perkawinanCollection
//                 .updateOne(where.eq('_id', data[1][0]),
//                     modify.set('status', data[4][0]))
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

//         if (data[0][0] == "edit Pengumuman") {
//           var pengumumanCollection =
//               MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

//           if (data[5][0] == true) {
//             DateTime now = new DateTime.now();
//             DateTime date = new DateTime(
//                 now.year, now.month, now.day, now.hour, now.minute, now.second);
//             final filename = date.toString();
//             final destination = 'files/$filename';
//             UploadTask? task = FirebaseApi.uploadFile(destination, data[4][0]);
//             final snapshot = await task!.whenComplete(() {});
//             final urlDownload = await snapshot.ref.getDownloadURL();

//             try {
//               var update = await pengumumanCollection
//                   .updateOne(
//                       where.eq('_id', data[1][0]),
//                       modify
//                           .set('title', data[2][0])
//                           .set("caption", data[3][0])
//                           .set("gambar", urlDownload))
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
//           } else {
//             try {
//               var update = await pengumumanCollection
//                   .updateOne(
//                       where.eq('_id', data[1][0]),
//                       modify
//                           .set('title', data[2][0])
//                           .set("caption", data[3][0]))
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

//         if (data[0][0] == "add Baptis") {
//           print(DateTime.parse(data[3][0]));
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
//             print(e);
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "edit Baptis") {
//           print(DateTime.parse(data[3][0]));
//           var baptisCollection = MongoDatabase.db.collection(BAPTIS_COLLECTION);

//           try {
//             var hasil = await baptisCollection
//                 .updateOne(
//                     where.eq('_id', data[1][0]),
//                     modify
//                         .set("kapasitas", int.parse(data[2][0]))
//                         .set("jadwalBuka", DateTime.parse(data[3][0]))
//                         .set("jadwalTutup", DateTime.parse(data[4][0])))
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
//             print(e);
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "edit Komuni") {
//           print(DateTime.parse(data[3][0]));
//           var komuniCollection = MongoDatabase.db.collection(KOMUNI_COLLECTION);

//           try {
//             var hasil = await komuniCollection
//                 .updateOne(
//                     where.eq('_id', data[1][0]),
//                     modify
//                         .set("kapasitas", int.parse(data[2][0]))
//                         .set("jadwalBuka", DateTime.parse(data[3][0]))
//                         .set("jadwalTutup", DateTime.parse(data[4][0])))
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
//             print(e);
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "edit Krisma") {
//           print(DateTime.parse(data[3][0]));
//           var krismaCollection = MongoDatabase.db.collection(KRISMA_COLLECTION);

//           try {
//             var hasil = await krismaCollection
//                 .updateOne(
//                     where.eq('_id', data[1][0]),
//                     modify
//                         .set("kapasitas", int.parse(data[2][0]))
//                         .set("jadwalBuka", DateTime.parse(data[3][0]))
//                         .set("jadwalTutup", DateTime.parse(data[4][0])))
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
//             print(e);
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "edit Kegiatan") {
//           var umumCollection = MongoDatabase.db.collection(UMUM_COLLECTION);
//           // 'idGereja': data[1][0],
//           //             'namaKegiatan': data[2][0],
//           //             'temaKegiatan': data[3][0],
//           //             'jenisKegiatan': data[4][0],
//           //             'deskripsiKegiatan': data[5][0],
//           //             'tamu': data[6][0],
//           //             'tanggal': DateTime.parse(data[7][0]),
//           //             'kapasitas': int.parse(data[8][0]),
//           //             'lokasi': data[9][0],
//           try {
//             var hasil = await umumCollection
//                 .updateOne(
//                     where.eq('_id', data[1][0]),
//                     modify
//                         .set('namaKegiatan', data[2][0])
//                         .set('temaKegiatan', data[3][0])
//                         .set("jenisKegiatan", data[4][0])
//                         .set("deskripsiKegiatan", data[5][0])
//                         .set("tamu", data[6][0])
//                         .set("tanggal", DateTime.parse(data[7][0]))
//                         .set("kapasitas", int.parse(data[8][0]))
//                         .set("lokasi", data[9][0]))
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
//             print(e);
//             msg.addReceiver("agenPage");
//             msg.setContent('failed');
//             await msg.send();
//           }
//         }

//         if (data[0][0] == "add Pengumuman") {
//           var PengumumanCollection =
//               MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
//           DateTime now = new DateTime.now();
//           DateTime date = new DateTime(
//               now.year, now.month, now.day, now.hour, now.minute, now.second);
//           final filename = date.toString();
//           final destination = 'files/$filename';
//           UploadTask? task = FirebaseApi.uploadFile(destination, data[2][0]);
//           final snapshot = await task!.whenComplete(() {});
//           final urlDownload = await snapshot.ref.getDownloadURL();

//           try {
//             var hasil = await PengumumanCollection.insertOne({
//               'idGereja': data[1][0],
//               'gambar': urlDownload,
//               'caption': data[3][0],
//               'tanggal': DateTime.now(),
//               'status': 0,
//               'title': data[4][0]
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

//         if (data[0][0] == "update Pengumuman") {
//           var pengumumanCollection =
//               MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

//           try {
//             var update = await pengumumanCollection
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
import 'dart:convert';

import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/view/pengumuman/editPengumuman.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../DatabaseFolder/data.dart';
import '../DatabaseFolder/fireBase.dart';
import '../DatabaseFolder/mongodb.dart';
import 'Agent.dart';
import 'Goals.dart';
import 'MessagePassing.dart';
import 'Plan.dart';
import 'Task.dart';

class AgentPendaftaran extends Agent {
  AgentPendaftaran() {
    _initAgent();
  }
  List<Plan> _plan = [];
  List<Goals> _goals = [];
  List<dynamic> pencarianData = [];
  String agentName = "";
  bool stop = false;
  int _estimatedTime = 5;

  bool canPerformTask(dynamic message) {
    for (var p in _plan) {
      if (p.goals == message.task.action && p.protocol == message.protocol) {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> performTask(Message msg, String sender) async {
    print('Agent Pendaftaran received message from $sender');
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
                print(
                    'Agent Pendaftaran returning data to ${message.receiver}');
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

  messageSetData(task) {
    pencarianData.add(task);
  }

  Future<List> getDataPencarian() async {
    return pencarianData;
  }

  Future<Message> action(String goals, dynamic data, String sender) async {
    switch (goals) {
      case "update pelayanan user":
        return updatePelayananUser(data.data, sender);
      case "edit pengumuman":
        return editPengumuman(data.data, sender);
      case "add pelayanan":
        return addPelayanan(data.data, sender);
      case "edit pelayanan":
        return editPelayanan(data.data, sender);
      case "add pengumuman":
        return addPengumuman(data.data, sender);
      case "update status pelayanan":
        return updateStatusPelayanan(data.data, sender);
      case "update status pengumuman":
        return updateStatusPengumuman(data.data, sender);
      case "send FCM":
        return sendFCM(data.data, sender);

      default:
        return rejectTask(data, data.sender);
    }
  }

  Future<Message> updatePelayananUser(dynamic data, String sender) async {
    var userPelayananCollection;
    if (data[0] == "baptis") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_BAPTIS_COLLECTION);
    }
    if (data[0] == "komuni") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KOMUNI_COLLECTION);
    }
    if (data[0] == "krisma") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_KRISMA_COLLECTION);
    }
    if (data[0] == "umum") {
      userPelayananCollection =
          MongoDatabase.db.collection(USER_UMUM_COLLECTION);
    }
    if (data[0] == "sakramentali") {
      userPelayananCollection =
          MongoDatabase.db.collection(PEMBERKATAN_COLLECTION);
    }
    if (data[0] == "perkawinan") {
      userPelayananCollection =
          MongoDatabase.db.collection(PERKAWINAN_COLLECTION);
    }
    var update = await userPelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set('status', data[4])
            .set('updatedAt', DateTime.now())
            .set("updatedBy", data[5]));

    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "oke"));

      Message message2 = Message(agentName, 'Agent Pencarian', "REQUEST",
          Tasks('cari pelayanan pendaftaran', data));
      MessagePassing messagePassing = MessagePassing();
      await messagePassing.sendMessage(message2);

      return message;
    } else {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('update', "failed"));
      return message;
    }
  }

  Future<Message> sendFCM(dynamic data, String sender) async {
    String Pelayanan = "";
    DateTime tanggal = DateTime.now();
    print(data[1]);
    print(data[0]);
    if (data[0][0] == "baptis") {
      Pelayanan = "Baptis";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "komuni") {
      Pelayanan = "Komuni";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "krisma") {
      Pelayanan = "Krisma";
      tanggal = data[1][0]['jadwalBuka'];
    }
    if (data[0][0] == "umum") {
      Pelayanan = "Kegiatan Umum";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "sakramentali") {
      Pelayanan = "Pemberkatan";
      tanggal = data[1][0]['tanggal'];
    }
    if (data[0][0] == "perkawinan") {
      Pelayanan = "Perkawinan";
      tanggal = data[1][0]['tanggal'];
    }

    String status = "";
    String body = "";
    String statusSoon = "";
    String bodySoon = "";
    if (data[0][4] == 1) {
      status = "Permintaan " + Pelayanan + " Diterima";
      body = "Permintaan baptis pada tanggal " +
          tanggal.toString().substring(0, 10) +
          " telah dikonfirmasi";
      statusSoon = "Baptis " + tanggal.toString().substring(0, 10);
      bodySoon = "Besok, Baptis " +
          tanggal.toString().substring(0, 10) +
          " Akan Dilaksakan";
    } else {
      status = "Permintaan" + Pelayanan + "Ditolak";
      body = "Maaf, permintaan " +
          Pelayanan +
          " pada tanggal " +
          tanggal.toString().substring(0, 10) +
          " ditolak";
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

    var FCMStatus = 0;
    try {
      if (data[0][4] == 1) {
        String constructFCMPayloadSoon(String token) {
          return jsonEncode({
            'to': token,
            'data': {
              "title": statusSoon,
              "message": bodySoon,
              "isScheduled": "true",
              "scheduledTime": tanggal.subtract(Duration(days: 1)).toString()
            },
          });
        }

        await http
            .post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
          },
          body: constructFCMPayloadSoon(data[0][2]),
        )
            .then((value) {
          FCMStatus = value.statusCode;
          print(value.statusCode);
          print("success fcm for soon!");
        });
      }

      await http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAYYV30kU:APA91bGB3D4X8KgkLH0ZNAOoYspjk9RjYoMk9EFguX6STuz1IUnRkfx2JCwT1HIekpUVPMcISFZ7n1rDSeZ7z-OLprkZv1Jyzb-hI8EcFK_HYUkUBJZ1UBw1T9RpALWxLGAS91VPct_V'
        },
        body: constructFCMPayload(data[0][2]),
      )
          .then((value) {
        FCMStatus = value.statusCode;
        print(value.statusCode);
      });
    } catch (e) {
      print(e);
    }

    if (FCMStatus == 200) {
      Message message =
          Message(agentName, "View", "INFORM", Tasks('cari', "oke"));
      print('FCM request for device sent!');
      return message;
    } else {
      Message message =
          Message(agentName, "View", "INFORM", Tasks('cari', "failed"));
      print('FCM request for device failed!');
      return message;
    }
  }

  Future<Message> editPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);

    if (data[4] == true) {
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(
          now.year, now.month, now.day, now.hour, now.minute, now.second);
      final filename = date.toString();
      final destination = 'files/$filename';
      UploadTask? task = FirebaseApi.uploadFile(destination, data[3]);
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      var update = await pengumumanCollection.updateOne(
          where.eq('_id', data[2]),
          modify
              .set('title', data[1])
              .set("caption", data[2])
              .set("gambar", urlDownload));
      if (update.isSuccess) {
        Message message = Message(
            'Agent Pendaftaran', sender, "INFORM", Tasks('cari', "oke"));
        return message;
      } else {
        Message message = Message(
            'Agent Pendaftaran', sender, "INFORM", Tasks('cari', "failed"));
        return message;
      }
    } else {
      var update = await pengumumanCollection.updateOne(
          where.eq('_id', data[0]),
          modify.set('title', data[1]).set("caption", data[2]));
      if (update.isSuccess) {
        Message message = Message(
            'Agent Pendaftaran', sender, "INFORM", Tasks('cari', "oke"));
        return message;
      } else {
        Message message = Message(
            'Agent Pendaftaran', sender, "INFORM", Tasks('cari', "failed"));
        return message;
      }
    }
  }

  Future<Message> addPelayanan(dynamic data, String sender) async {
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

      var add = await pelayananCollection.insertOne({
        'idGereja': data[1],
        'namaKegiatan': data[2],
        'temaKegiatan': data[3],
        'jenisKegiatan': data[4],
        'deskripsiKegiatan': data[5],
        'tamu': data[6],
        'tanggal': DateTime.parse(data[7]),
        'kapasitas': int.parse(data[8]),
        'lokasi': data[9][0],
        'status': 0,
        "createdAt": DateTime.now(),
        "createdBy": data[10],
        "updatedAt": DateTime.now(),
        "updatedBy": data[10],
      });
      if (add.isSuccess) {
        Message message =
            Message(agentName, sender, "INFORM", Tasks('add pelayanan', "oke"));
        return message;
      } else {
        Message message = Message(
            agentName, sender, "INFORM", Tasks('add pelayanan', "failed"));
        return message;
      }
    }

    var add = await pelayananCollection.insertOne({
      'idGereja': data[1],
      'kapasitas': int.parse(data[2]),
      'jadwalBuka': DateTime.parse(data[3]),
      'jadwalTutup': DateTime.parse(data[4]),
      'status': 0,
      "createdAt": DateTime.now(),
      "createdBy": data[5],
      "updatedAt": DateTime.now(),
      "updatedBy": data[5],
    });
    if (add.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('add pelayanan', "oke"));
      return message;
    } else {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('add pelayanan', "failed"));
      return message;
    }
  }

  Future<Message> updateStatusPelayanan(dynamic data, String sender) async {
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
    }

    var update = await pelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set('status', data[2])
            .set("updatedAt", DateTime.now())
            .set("updatedBy", data[3]));

    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('add pelayanan', "oke"));
      return message;
    } else {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('add pelayanan', "failed"));
      return message;
    }
  }

  Future<Message> updateStatusPengumuman(dynamic data, String sender) async {
    var pengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    var update = await pengumumanCollection.updateOne(
        where.eq('_id', data[0]),
        modify.set('status', data[1]).set("updatedAt", DateTime.now())
          ..set("updatedBy", data[2]));

    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('add pelayanan', "oke"));
      return message;
    } else {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('add pelayanan', "failed"));
      return message;
    }
  }

  Future<Message> editPelayanan(dynamic data, String sender) async {
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
      print(data);
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

      if (update.isSuccess) {
        Message message = Message(
            agentName, sender, "INFORM", Tasks('edit pelayanan', "oke"));
        return message;
      } else {
        Message message = Message(
            agentName, sender, "INFORM", Tasks('edit pelayanan', "failed"));
        return message;
      }
    }

    var update = await pelayananCollection.updateOne(
        where.eq('_id', data[1]),
        modify
            .set("kapasitas", int.parse(data[2]))
            .set("jadwalBuka", DateTime.parse(data[3]))
            .set("jadwalTutup", DateTime.parse(data[4]))
            .set("updatedAt", DateTime.now())
            .set("updatedBy", data[5]));
    if (update.isSuccess) {
      Message message =
          Message(agentName, sender, "INFORM", Tasks('edit pelayanan', "oke"));
      return message;
    } else {
      Message message = Message(
          agentName, sender, "INFORM", Tasks('edit pelayanan', "failed"));
      return message;
    }
  }

  Future<Message> addPengumuman(dynamic data, String sender) async {
    var PengumumanCollection =
        MongoDatabase.db.collection(GAMBAR_GEREJA_COLLECTION);
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, data[1]);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    var add = await PengumumanCollection.insertOne({
      'idGereja': data[0],
      'gambar': urlDownload,
      'caption': data[2],
      'tanggal': DateTime.now(),
      'status': 0,
      'title': data[3],
      "createdAt": DateTime.now(),
      "createdBy": data[4],
      "updatedAt": DateTime.now(),
      "updatedBy": data[4],
    });

    if (add.isSuccess) {
      Message message =
          Message('Agent Pendaftaran', sender, "INFORM", Tasks('cari', "oke"));
      return message;
    } else {
      Message message = Message(
          'Agent Pendaftaran', sender, "INFORM", Tasks('cari', "failed"));
      return message;
    }
  }

  Message rejectTask(dynamic task, sender) {
    Message message = Message(
        "Agent Pendaftaran",
        sender,
        "INFORM",
        Tasks('error', [
          ['failed']
        ]));

    print(this.agentName + ' rejected task form $sender: ${task.action}');
    return message;
  }

  Message overTime(sender) {
    Message message = Message(
        sender,
        "Agent Pendaftaran",
        "INFORM",
        Tasks('error', [
          ['reject over time']
        ]));
    return message;
  }

  void _initAgent() {
    this.agentName = "Agent Pendaftaran";
    _plan = [
      Plan("add pelayanan", "REQUEST", _estimatedTime),
      Plan("add pengumuman", "REQUEST", _estimatedTime),
      Plan("edit pelayanan", "REQUEST", _estimatedTime),
      Plan("edit pengumuman", "REQUEST", _estimatedTime),
      Plan("update status pelayanan", "REQUEST", _estimatedTime),
      Plan("update status pengumuman", "REQUEST", _estimatedTime),
      Plan("update pelayanan user", "REQUEST", _estimatedTime),
      Plan("send FCM", "INFORM", _estimatedTime),
    ];
    _goals = [
      Goals("add pelayanan", String, 2),
      Goals("add pengumuman", String, 2),
      Goals("edit pelayanan", String, 2),
      Goals("edit pengumuman", String, 2),
      Goals("update status pelayanan", String, 2),
      Goals("update status pengumuman", String, 2),
      Goals("update pelayanan user", String, 2),
      Goals("send FCM", String, 4),
    ];
  }
}
