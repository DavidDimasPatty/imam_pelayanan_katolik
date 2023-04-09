// import 'package:flutter/material.dart';
// import 'package:imam_pelayanan_katolik/history.dart';
// import 'package:imam_pelayanan_katolik/kegiatanUmum.dart';
// import 'package:imam_pelayanan_katolik/profile.dart';
// import 'package:imam_pelayanan_katolik/sakramen.dart';
// import 'package:imam_pelayanan_katolik/sakramentali.dart';
// import 'package:imam_pelayanan_katolik/setting.dart';

// import 'DatabaseFolder/mongodb.dart';

// //stateless dan class
// class HomePage extends StatelessWidget {
//   var role;
//   var iduser;
//   var idGereja;
//   var dataUser;

//   HomePage(this.iduser, this.idGereja,this.role this.role);
//   @override

//   //function
//   Future callDb() async {
//     //async
//     return await MongoDatabase.callAdmin(iduser);
//   }

//   Future callJumlah() async {
//     return await MongoDatabase.callJumlah(idGereja);
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Imam Pelayanan Katolik'),
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
//                     builder: (context) => Profile( iduser, idGereja,role)),
//               );
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => Settings( iduser, idGereja,role)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         padding: EdgeInsets.only(right: 15, left: 15),
//         children: <Widget>[],
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
//                   icon: Icon(Icons.home),
//                   label: "Home",
//                 ),
//                 BottomNavigationBarItem(
//                   icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
//                   label: "History",
//                 )
//               ],
//               onTap: (index) {
//                 //control flow
//                 if (index == 1) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => History( iduser, idGereja,role)),
//                   );
//                 } else if (index == 0) {}
//               },
//             ),
//           )),
//     );
//   }
// }
