// import 'dart:async';

// import 'package:anim_search_bar/anim_search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:imam_pelayanan_katolik/agen/Message.dart';
// import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
// import 'package:imam_pelayanan_katolik/agen/Task.dart';
// import 'package:imam_pelayanan_katolik/view/sakramen/krisma/addKrisma.dart';
// import 'package:imam_pelayanan_katolik/view/sakramen/krisma/editKrisma.dart';
// import 'package:imam_pelayanan_katolik/view/sakramen/krisma/krismaUser.dart';
// import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
// import 'package:imam_pelayanan_katolik/view/homePage.dart';
// import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
// import '../../history.dart';
// import '../../profile/profile.dart';

// class Krisma extends StatefulWidget {
//   var role;
//   final iduser;
//   final idGereja;
//   Krisma(this.iduser, this.idGereja, this.role);
//   @override
//   _Krisma createState() => _Krisma(this.iduser, this.idGereja, this.role);
// }

// class _Krisma extends State<Krisma> {
//   var role;
//   var emails;
//   var distance;
//   List hasil = [];
//   StreamController _controller = StreamController();
//   ScrollController _scrollController = ScrollController();
//   int data = 5;
//   List dummyTemp = [];
//   final iduser;
//   final idGereja;
//   _Krisma(this.iduser, this.idGereja, this.role);

//   Future<List> callDb() async {
//     Completer<void> completer = Completer<void>();
//     Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
//         Tasks('cari pelayanan', [idGereja, "krisma", "current"]));

//     MessagePassing messagePassing =
//         MessagePassing(); //Memanggil distributor pesan
//     var data = await messagePassing
//         .sendMessage(message); //Mengirim pesan ke distributor pesan
//     var hasilPencarian =
//         await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

//     completer.complete(); //Batas pengerjaan yang memerlukan completer

//     await completer
//         .future; //Proses penungguan sudah selesai ketika varibel hasil
//     //memiliki nilai
//     return await hasilPencarian;
//   }

//   @override
//   void initState() {
//     super.initState();
//     callDb().then((result) {
//       setState(() {
//         hasil.addAll(result);
//         dummyTemp.addAll(result);
//         _controller.add(result);
//       });
//     });
//   }

//   filterSearchResults(String query) {
//     if (query.isNotEmpty) {
//       List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
//       for (var item in dummyTemp) {
//         if (item['jadwalBuka']
//             .toString()
//             .toLowerCase()
//             .contains(query.toLowerCase())) {
//           listOMaps.add(item);
//         }
//       }
//       setState(() {
//         hasil.clear();
//         hasil.addAll(listOMaps);
//       });
//     } else {
//       setState(() {
//         hasil.clear();
//         hasil.addAll(dummyTemp);
//       });
//     }
//   }

//   void updateKegiatan(id, status) async {
//     Completer<void> completer = Completer<void>();
//     Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
//         Tasks('update status pelayanan', ["krisma", id, status, iduser]));

//     MessagePassing messagePassing =
//         MessagePassing(); //Memanggil distributor pesan
//     await messagePassing
//         .sendMessage(message); //Mengirim pesan ke distributor pesan
//     completer.complete(); //Batas pengerjaan yang memerlukan completer
//     var hasilDaftar = await await AgentPage
//         .getData(); //Memanggil data yang tersedia di agen Page
//     if (hasilDaftar == "failed") {
//       Fluttertoast.showToast(
//           /////// Widget toast untuk menampilkan pesan pada halaman
//           msg: "Gagal Deactive Kegiatan Krisma",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     } else {
//       Fluttertoast.showToast(
//           /////// Widget toast untuk menampilkan pesan pada halaman
//           msg: "Berhasil Deactive Kegiatan Krisma",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       callDb().then((result) {
//         setState(() {
//           hasil.clear();
//           dummyTemp.clear();
//           hasil.addAll(result);
//           dummyTemp.addAll(result);
//           _controller.add(result);
//         });
//       });
//     }
//   }

//   Future pullRefresh() async {
//     //Fungsi refresh halaman akan memanggil fungsi callDb
//     callDb().then((result) {
//       setState(() {
//         data = 5;
//         hasil.clear();
//         dummyTemp.clear();
//         hasil.clear();
//         hasil.addAll(result);
//         dummyTemp.addAll(result);
//         _controller.add(result);
//       });
//     });
//   }

//   TextEditingController searchController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     searchController.addListener(() async {
//       await filterSearchResults(searchController.text);
//     });
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         setState(() {
//           data = data + 5;
//         });
//       }
//     });
//     return Scaffold(
//       // Widget untuk membangun struktur halaman
//       //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

//       appBar: AppBar(
//         // widget Top Navigation Bar
//         automaticallyImplyLeading: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         title: Text('Krisma'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.account_circle_rounded),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Profile(iduser, idGereja, role)),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Settings(iduser, idGereja, role)),
//               );
//             },
//           ),
//         ],
//       ),
//       //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
//       body: RefreshIndicator(
//         //Widget untuk refresh body halaman
//         onRefresh: pullRefresh,
//         child: ListView(
//           controller: _scrollController,
//           shrinkWrap: true,
//           padding: EdgeInsets.only(right: 15, left: 15),
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(right: 10, left: 10),
//               child: AnimSearchBar(
//                 autoFocus: false,
//                 width: 400,
//                 rtl: true,
//                 helpText: 'Cari Krisma',
//                 textController: searchController,
//                 onSuffixTap: () {
//                   setState(() {
//                     editingController.clear();
//                   });
//                 },
//               ),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(right: 10, left: 10),
//                   child: CircleAvatar(
//                     backgroundColor: Colors.white,
//                     child: IconButton(
//                       color: Colors.black,
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   addKrisma(iduser, idGereja, role)),
//                         );
//                       },
//                       splashColor: Colors.blue,
//                       splashRadius: 30,
//                       icon: Icon(Icons.add),
//                     ),
//                   ),
//                 ),
//                 Text("Add Krisma")
//               ],
//             ),
//             Padding(padding: EdgeInsets.symmetric(vertical: 10)),
//             /////////
//             StreamBuilder(
//                 stream: _controller.stream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(
//                       child: Text('Error: ${snapshot.error}'),
//                     );
//                   }

//                   if (!snapshot.hasData) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   try {
//                     return Column(children: [
//                       for (var i in hasil.take(data))
//                         InkWell(
//                           borderRadius: new BorderRadius.circular(24),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => KrismaUser(
//                                       iduser, idGereja, role, i['_id'])),
//                             );
//                           },
//                           child: Container(
//                               margin: EdgeInsets.only(
//                                   right: 15, left: 15, bottom: 20),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                     begin: Alignment.topRight,
//                                     end: Alignment.topLeft,
//                                     colors: [
//                                       Colors.blueGrey,
//                                       Colors.lightBlue,
//                                     ]),
//                                 border: Border.all(
//                                   color: Colors.lightBlue,
//                                 ),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               child: Column(children: <Widget>[
//                                 //Color(Colors.blue);

//                                 Text(
//                                   "Krisma " +
//                                       i['jadwalBuka']
//                                           .toString()
//                                           .substring(0, 10),
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w300),
//                                   textAlign: TextAlign.left,
//                                 ),
//                                 Text(
//                                   'Kapasitas: ' + i['kapasitas'].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 Text(
//                                   'Jenis: ' + i['jenis'].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 Text(
//                                   'Jadwal Tutup: ' +
//                                       i['jadwalTutup'].toString(),
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 12),
//                                 ),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: RaisedButton(
//                                       textColor: Colors.white,
//                                       color: Colors.lightBlue,
//                                       child: Text("Edit Krisma"),
//                                       shape: new RoundedRectangleBorder(
//                                         borderRadius:
//                                             new BorderRadius.circular(30.0),
//                                       ),
//                                       onPressed: () async {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) => editKrisma(
//                                                   iduser,
//                                                   idGereja,
//                                                   role,
//                                                   i['_id'])),
//                                         );
//                                       }),
//                                 ),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: RaisedButton(
//                                       textColor: Colors.white,
//                                       color: Colors.lightBlue,
//                                       child: Text("Deactive Kegiatan"),
//                                       shape: new RoundedRectangleBorder(
//                                         borderRadius:
//                                             new BorderRadius.circular(30.0),
//                                       ),
//                                       onPressed: () async {
//                                         showDialog<String>(
//                                           context: context,
//                                           builder: (BuildContext context) =>
//                                               AlertDialog(
//                                             title:
//                                                 const Text('Confirm Deactive'),
//                                             content: const Text(
//                                                 'Yakin ingin mendeactive kegiatan ini?'),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                 onPressed: () => Navigator.pop(
//                                                     context, 'Cancel'),
//                                                 child: const Text('Tidak'),
//                                               ),
//                                               TextButton(
//                                                 onPressed: () async {
//                                                   updateKegiatan(i["_id"], 1);
//                                                   Navigator.pop(context);
//                                                 },
//                                                 child: const Text('Ya'),
//                                               ),
//                                             ],
//                                           ),
//                                         );
//                                       }),
//                                 ),
//                               ])),
//                         ),

//                       /////////
//                     ]);
//                   } catch (e) {
//                     print(e);
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 }),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               showUnselectedLabels: true,
//               unselectedItemColor: Colors.blue,
//               items: <BottomNavigationBarItem>[
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
//                   label: "Histori",
//                 )
//               ],
//               onTap: (index) {
//                 if (index == 1) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => History(iduser, idGereja, role)),
//                   );
//                 } else if (index == 0) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => HomePage(iduser, idGereja, role)),
//                   );
//                 }
//               },
//             ),
//           )),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }
// }
