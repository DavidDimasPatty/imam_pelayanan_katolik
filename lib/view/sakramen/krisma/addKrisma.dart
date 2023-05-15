// import 'dart:async';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
// import 'package:imam_pelayanan_katolik/agen/Message.dart';
// import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
// import 'package:imam_pelayanan_katolik/agen/Task.dart';
// import 'package:imam_pelayanan_katolik/view/homePage.dart';
// import 'package:imam_pelayanan_katolik/view/sakramen/krisma/krisma.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// import 'package:intl/intl.dart';
// import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
// import 'package:imam_pelayanan_katolik/view/history.dart';
// import '../../profile/profile.dart';
// import '../../setting/setting.dart';

// class addKrisma extends StatefulWidget {
//   @override
//   final role;
//   final iduser;
//   final idGereja;
//   addKrisma(this.iduser, this.idGereja, this.role);

//   @override
//   _addKrisma createState() => _addKrisma(this.iduser, this.idGereja, this.role);
// }

// class _addKrisma extends State<addKrisma> {
//   final role;
//   final iduser;
//   final idGereja;
//   _addKrisma(this.iduser, this.idGereja, this.role);
//   String _selectedDate = '';
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//   String tanggalBuka = "";
//   String tanggalTutup = "";
//   TextEditingController kapasitas = new TextEditingController();

//   List jenis = ["Dewasa", "Anak"];
//   String jenisSelected = "";
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is PickerDateRange) {
//         _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
//             // ignore: lines_longer_than_80_chars
//             ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
//         tanggalBuka =
//             '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
//         tanggalTutup =
//             '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value.toString();
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//     });
//   }

//   void submit(idGereja, kapasitas, tanggalbuka, tanggaltutup) async {
//     if (kapasitas != "" &&
//         tanggalBuka != "" &&
//         tanggalTutup != "" &&
//         jenisSelected != "") {
//       Completer<void> completer = Completer<void>();
//       Message message = Message(
//           'Agent Page',
//           'Agent Pendaftaran',
//           "REQUEST",
//           Tasks('add pelayanan', [
//             "krisma",
//             idGereja,
//             kapasitas,
//             tanggalbuka.toString(),
//             tanggaltutup.toString(),
//             iduser,
//             jenisSelected
//           ]));
//       MessagePassing messagePassing =
//           MessagePassing(); //Memanggil distributor pesan
//       var data = await messagePassing
//           .sendMessage(message); //Mengirim pesan ke distributor pesan
//       completer.complete(); //Batas pengerjaan yang memerlukan completer
//       var hasil = await await AgentPage
//           .getData(); //Memanggil data yang tersedia di agen Page

//       await completer
//           .future; //Proses penungguan sudah selesai ketika varibel hasil
//       //memiliki nilai

//       if (hasil == "failed") {
//         Fluttertoast.showToast(
//             /////// Widget toast untuk menampilkan pesan pada halaman
//             msg: "Gagal Mendaftarkan Krisma",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       } else {
//         Fluttertoast.showToast(
//             /////// Widget toast untuk menampilkan pesan pada halaman
//             msg: "Berhasil Mendaftarkan Krisma",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 2,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         Navigator.pop(
//           context,
//           MaterialPageRoute(
//               builder: (context) => Krisma(iduser, idGereja, role)),
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
//         title: Text("Tambah Kegiatan Krisma"),
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
//       body: ListView(children: [
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//             ),
//             Text(
//               "Kapasitas",
//               textAlign: TextAlign.left,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 5),
//             ),
//             TextField(
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//               ],
//               controller: kapasitas,
//               style: TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Colors.blue,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(
//                       color: Colors.black,
//                     ),
//                   ),
//                   hintText: "Kapasitas Pendaftaran",
//                   hintStyle: TextStyle(color: Colors.grey),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   )),
//             ),
//           ],
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//             ),
//             Text(
//               "Jenis",
//               textAlign: TextAlign.left,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 5),
//             ),
//             DropdownSearch<dynamic>(
//               // popupProps: PopupProps.menu(
//               //   showSelectedItems: true,
//               //   disabledItemFn: (String s) => s.startsWith('I'),
//               // ),
//               items: jenis,
//               dropdownDecoratorProps: DropDownDecoratorProps(
//                 dropdownSearchDecoration: InputDecoration(
//                   labelText: "Pilih Jenis",
//                   hintText: "Pilih Jenis",
//                 ),
//               ),
//               onChanged: (dynamic? data) {
//                 jenisSelected = data;
//               },
//             ),
//           ],
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 10),
//         ),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Tanggal Buka dan Tutup Pendaftaran",
//               textAlign: TextAlign.left,
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 5),
//             ),
//             SfDateRangePicker(
//               view: DateRangePickerView.month,
//               onSelectionChanged: _onSelectionChanged,
//               selectionMode: DateRangePickerSelectionMode.range,
//               monthViewSettings:
//                   DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
//             )
//           ],
//         ),
//         SizedBox(
//           width: double.infinity,
//           child: RaisedButton(
//               textColor: Colors.white,
//               color: Colors.lightBlue,
//               child: Text("Submit Kegiatan"),
//               shape: new RoundedRectangleBorder(
//                 borderRadius: new BorderRadius.circular(30.0),
//               ),
//               onPressed: () async {
//                 submit(idGereja, kapasitas.text, tanggalBuka, tanggalTutup);
//               }),
//         ),
//       ]),
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
