// import 'dart:async';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:imam_pelayanan_katolik/agen/Message.dart';
// import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
// import 'package:imam_pelayanan_katolik/agen/Task.dart';
// import 'package:imam_pelayanan_katolik/view/homePage.dart';
// import 'package:imam_pelayanan_katolik/view/sakramen/baptis/baptis.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
// import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
// import 'package:imam_pelayanan_katolik/view/history.dart';
// import '../../profile/profile.dart';
// import '../../setting/setting.dart';

// class editBaptis extends StatefulWidget {
//   @override
//   final role;
//   final iduser;
//   final idGereja;
//   final idBaptis;
//   editBaptis(this.iduser, this.idGereja, this.role, this.idBaptis);

//   @override
//   _editBaptis createState() =>
//       _editBaptis(this.iduser, this.idGereja, this.role, this.idBaptis);
// }

// class _editBaptis extends State<editBaptis> {
//   final role;
//   final iduser;
//   final idGereja;
//   final idBaptis;
//   String tanggalBuka = "";
//   String tanggalTutup = "";
//   TextEditingController kapasitas = new TextEditingController();
//   _editBaptis(this.iduser, this.idGereja, this.role, this.idBaptis);
//   List jenis = ["Dewasa", "Anak"];
//   String jenisSelected = "";
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is PickerDateRange) {
//         tanggalBuka =
//             '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
//         tanggalTutup =
//             '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
//       }
//     });
//   }

//   var hasil = [];
//   Future callDb() async {
//     Completer<void> completer = Completer<void>();
//     Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
//         Tasks('cari data edit pelayanan', [idBaptis, "baptis"]));

//     MessagePassing messagePassing =
//         MessagePassing(); //Memanggil distributor pesan
//     await messagePassing
//         .sendMessage(message); //Mengirim pesan ke distributor pesan
//     completer.complete(); //Batas pengerjaan yang memerlukan completer
//     var hasil = await await AgentPage
//         .getData(); //Memanggil data yang tersedia di agen Page

//     await completer
//         .future; //Proses penungguan sudah selesai ketika varibel hasil
//     //memiliki nilai
//     return await hasil;
//   }

//   Future pullRefresh() async {
//     //Fungsi refresh halaman akan memanggil fungsi callDb
//     setState(() {
//       // callDb();
//     });
//   }

//   Future submit(idGereja, kapasitas, tanggalbuka, tanggaltutup) async {
//     if (tanggalBuka == "") {
//       tanggalBuka = tanggalbuka;
//     }
//     if (tanggalTutup == "") {
//       tanggalTutup = tanggaltutup;
//     }
//     if (kapasitas != "" &&
//         tanggalBuka != "" &&
//         tanggalTutup != "" &&
//         jenisSelected != "") {
//       Completer<void> completer = Completer<void>();
//       Message message = Message(
//           'Agent Page',
//           'Agent Pendaftaran',
//           "REQUEST",
//           Tasks('edit pelayanan', [
//             "baptis",
//             idBaptis,
//             kapasitas,
//             tanggalBuka.toString(),
//             tanggalTutup.toString(),
//             iduser,
//             jenisSelected
//           ]));

//       MessagePassing messagePassing =
//           MessagePassing(); //Memanggil distributor pesan
//       await messagePassing
//           .sendMessage(message); //Mengirim pesan ke distributor pesan
//       completer.complete(); //Batas pengerjaan yang memerlukan completer
//       var hasil = await await AgentPage
//           .getData(); //Memanggil data yang tersedia di agen Page

//       if (hasil == "failed") {
//         Fluttertoast.showToast(
//             /////// Widget toast untuk menampilkan pesan pada halaman
//             msg: "Gagal Edit Baptis",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       } else {
//         Fluttertoast.showToast(
//             /////// Widget toast untuk menampilkan pesan pada halaman
//             msg: "Berhasil memperbarui Baptis",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         Navigator.pop(
//           context,
//           MaterialPageRoute(
//               builder: (context) => Baptis(iduser, idGereja, role)),
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//           /////// Widget toast untuk menampilkan pesan pada halaman
//           msg: "Isi semua bidang",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 2,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Widget untuk membangun struktur halaman
//       //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

//       appBar: AppBar(
//         // widget Top Navigation Bar
//         automaticallyImplyLeading: true,
//         title: Text("Edit Kegiatan Baptis"),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
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
//           children: [
//             FutureBuilder(
//                 future: callDb(),
//                 builder: (context, AsyncSnapshot snapshot) {
//                   try {
//                     kapasitas.text = snapshot.data[0]['kapasitas'].toString();
//                     jenisSelected = snapshot.data[0]['jenis'];

//                     return Column(children: [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                           ),
//                           Text(
//                             "Kapasitas",
//                             textAlign: TextAlign.left,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 5),
//                           ),
//                           TextField(
//                             controller: kapasitas,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                   RegExp("[0-9]")),
//                             ],
//                             style: TextStyle(color: Colors.black),
//                             decoration: InputDecoration(
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                   borderSide: BorderSide(
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 hintText: "Kapasitas Pendaftaran",
//                                 hintStyle: TextStyle(color: Colors.grey),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 10),
//                           ),
//                           Text(
//                             "Jenis",
//                             textAlign: TextAlign.left,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 5),
//                           ),
//                           DropdownSearch<dynamic>(
//                             // popupProps: PopupProps.menu(
//                             //   showSelectedItems: true,
//                             //   disabledItemFn: (String s) => s.startsWith('I'),
//                             // ),
//                             items: jenis,
//                             selectedItem: jenisSelected,
//                             dropdownDecoratorProps: DropDownDecoratorProps(
//                               dropdownSearchDecoration: InputDecoration(
//                                 labelText: "Pilih Jenis",
//                                 hintText: "Pilih Jenis",
//                               ),
//                             ),
//                             onChanged: (dynamic? data) {
//                               jenisSelected = data;
//                             },
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Tanggal Buka dan Tutup Pendaftaran",
//                             textAlign: TextAlign.left,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: 5),
//                           ),
//                           SfDateRangePicker(
//                             view: DateRangePickerView.month,
//                             onSelectionChanged: _onSelectionChanged,
//                             selectionMode: DateRangePickerSelectionMode.range,
//                             monthViewSettings: DateRangePickerMonthViewSettings(
//                                 firstDayOfWeek: 1),
//                             initialSelectedRange: PickerDateRange(
//                                 snapshot.data[0]['jadwalBuka'],
//                                 snapshot.data[0]['jadwalTutup']),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         child: RaisedButton(
//                             textColor: Colors.white,
//                             color: Colors.lightBlue,
//                             child: Text("Submit Kegiatan"),
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(30.0),
//                             ),
//                             onPressed: () async {
//                               submit(
//                                   idGereja,
//                                   kapasitas.text,
//                                   snapshot.data[0]['jadwalBuka'].toString(),
//                                   snapshot.data[0]['jadwalTutup'].toString());
//                             }),
//                       ),
//                     ]);
//                   } catch (e) {
//                     print(e);
//                     return Center(child: CircularProgressIndicator());
//                   }
//                 }),
//             /////////
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
//                   label: "History",
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
//     );
//   }
// }
