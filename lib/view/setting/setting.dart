import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:imam_pelayanan_katolik/view/setting/customerService.dart';
import 'package:imam_pelayanan_katolik/view/setting/privacySafety.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';
import '../profile/profile.dart';

class Settings extends StatelessWidget {
  var role;
  var iduser;
  var idGereja;
  var dataUser;
  var data;

  Future LogOut() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Setting', "REQUEST", Tasks('log out', null));

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil = await await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai

    if (hasil == 'oke') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Berhasil Log Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Settings(this.iduser, this.idGereja, this.role);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: true,
        title: Text("Setting"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(iduser, idGereja, role)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(iduser, idGereja, role)),
              );
            },
          ),
        ],
      ),
      body: Center(
          child: Column(children: <Widget>[
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => privacySafety(this.iduser, this.idGereja, role)));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                    ]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Privacy & Safety",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => customerService(this.iduser, this.idGereja, role)));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                    ]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Customer Service",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )),
            Padding(padding: EdgeInsets.symmetric(vertical: 14)),
            RaisedButton(
                onPressed: () async {
                  await LogOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                elevation: 10.0,
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                      Colors.blueAccent,
                      Colors.lightBlue,
                    ]),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: double.maxFinite, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight: FontWeight.w300),
                    ),
                  ),
                )),

            /////////
          ],
        )
      ])),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              unselectedItemColor: Colors.blue,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "Histori",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => History(iduser, idGereja, role)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(iduser, idGereja, role)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
