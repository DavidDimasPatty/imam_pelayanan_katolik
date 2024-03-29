import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';
import 'package:imam_pelayanan_katolik/view/login.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/daftarPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/pelayanan.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';

//stateless dan class
class homePage extends StatefulWidget {
  var iduser;
  var idGereja;
  var role;
  homePage(this.iduser, this.idGereja, this.role);
  _homePage createState() => _homePage(this.iduser, this.idGereja, this.role);
}

class _homePage extends State<homePage> {
  var role;
  var iduser;
  var idGereja;
  _homePage(this.iduser, this.idGereja, this.role);
  @override
  Future callJumlah() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Akun', "REQUEST", Tasks('cari jumlah', [idGereja, iduser, role]));
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil = await await agenPage.getData(); //Memanggil data yang tersedia di agen Page
    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return hasil;
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      callJumlah();
    });
  }

  Future LogOut() async {
    Completer<void> completer = Completer<void>();
    Messages message = Messages('Agent Page', 'Agent Setting', "REQUEST", Tasks('log out', null));

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil = await await agenPage.getData(); //Memanggil data yang tersedia di agen Page

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai

    if (hasil == 'oke') {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Akun anda telah di banned",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => logIn()),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////
      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: false,
        //Tombol back halaman dimatikan
        title: Text('Imam Pelayanan Katolik'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile(iduser, idGereja, role)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => setting(iduser, idGereja, role)),
              );
            },
          ),
        ],
      ),
      //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
          //Widget untuk refresh body halaman
          onRefresh: pullRefresh,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(right: 15, left: 15),
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 305,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: ListView(children: [
                    FutureBuilder(
                        future: callJumlah(),
                        builder: (context, AsyncSnapshot snapshot) {
                          //exception

                          try {
                            if (snapshot.data[4][0]['banned'] == 1) {
                              LogOut();
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      if (snapshot.data[4][0]['nama'].length < 20)
                                                        FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            "Halo, \n" + snapshot.data[4][0]['nama'].toString(),
                                                            style: TextStyle(
                                                              color: Colors.blue,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      if (snapshot.data[4][0]['nama'].length >= 20)
                                                        FittedBox(
                                                          fit: BoxFit.fitWidth,
                                                          child: Text(
                                                            "Halo, \n" + snapshot.data[4][0]['nama'].toString().substring(0, 20) + "...",
                                                            style: TextStyle(
                                                              color: Colors.blue,
                                                              fontSize: 13.0,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(width: 2),
                                                      Column(children: <Widget>[
                                                        //control flow statement
                                                        if (snapshot.data[4][0]['picture'] != null)
                                                          CircleAvatar(
                                                            backgroundImage: NetworkImage(snapshot.data[4][0]['picture']),
                                                            backgroundColor: Colors.greenAccent,
                                                            radius: 30.0,
                                                          ),
                                                        if (snapshot.data[4][0]['picture'] == null)
                                                          CircleAvatar(
                                                            backgroundImage: NetworkImage(''),
                                                            backgroundColor: Colors.greenAccent,
                                                            radius: 30.0,
                                                          ),
                                                      ])
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 20.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 22.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Total User Mendaftar Pelayanan :",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                snapshot.data[0].toString(),
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(children: <Widget>[
                                                Expanded(
                                                  child: Card(
                                                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30.0),
                                                    ),
                                                    clipBehavior: Clip.antiAlias,
                                                    color: Colors.white,
                                                    elevation: 20.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            children: <Widget>[
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Text(
                                                                "Sakramen",
                                                                style: TextStyle(
                                                                  color: Colors.blue,
                                                                  fontSize: 15.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Text(
                                                                snapshot.data[1].toString(),
                                                                style: TextStyle(
                                                                  color: Colors.blue,
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if (role == 0)
                                                  Expanded(
                                                    child: Card(
                                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.0),
                                                      ),
                                                      clipBehavior: Clip.antiAlias,
                                                      color: Colors.white,
                                                      elevation: 20.0,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                                Text(
                                                                  "Sakramentali",
                                                                  style: TextStyle(
                                                                    color: Colors.blue,
                                                                    fontSize: 12.0,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10.0,
                                                                ),
                                                                Text(
                                                                  snapshot.data[2].toString(),
                                                                  style: TextStyle(
                                                                    color: Colors.blue,
                                                                    fontSize: 16.0,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                if (role == 1)
                                                  Expanded(
                                                    child: Card(
                                                      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.0),
                                                      ),
                                                      clipBehavior: Clip.antiAlias,
                                                      color: Colors.white,
                                                      elevation: 20.0,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Column(
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                                Text(
                                                                  "Umum",
                                                                  style: TextStyle(
                                                                    color: Colors.blue,
                                                                    fontSize: 15.0,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                                Text(
                                                                  snapshot.data[3].toString(),
                                                                  style: TextStyle(
                                                                    color: Colors.blue,
                                                                    fontSize: 16.0,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5.0,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                              ])
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            );
                          } catch (e) {
                            print(e);
                            return Center(child: CircularProgressIndicator());
                          }
                        })
                  ])),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pelayanan(iduser, idGereja, role, "Sakramen", "current")),
                  );
                },
                child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                        Colors.blueGrey,
                        Colors.lightBlue,
                      ]),
                      border: Border.all(
                        color: Colors.lightBlue,
                      ),
                    ),
                    child: Row(children: <Widget>[
                      Container(
                        height: 119,
                        width: 120,
                        child: Image.network(
                          'https://cdn.pixabay.com/photo/2018/08/21/11/18/priest-3621038_960_720.jpg',
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Pendaftaran Sakramen",
                              style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Buat kegiatan pelayanan sakramen \n baru, active/ deactive kegiatan  \n pelayanan sakramen, \n Konfirmasi pendaftaran user",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
              ),
              if (role == 0)
                InkWell(
                  borderRadius: new BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => daftarPelayanan(iduser, idGereja, role, "Sakramentali", "current", "Pemberkatan")),
                    );
                  },
                  child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                          Colors.blueGrey,
                          Colors.lightBlue,
                        ]),
                        border: Border.all(
                          color: Colors.lightBlue,
                        ),
                      ),
                      child: Row(children: <Widget>[
                        Container(
                          height: 119,
                          width: 123,
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2013/02/09/04/33/church-79607_960_720.jpg',
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Pendaftaran Sakramentali",
                                style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                " Konfirmasi pendaftaran user \n yang mendaftarkan pelayanan\n pemberkatan pada gereja",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ])),
                ),
              if (role == 1)
                InkWell(
                  borderRadius: new BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pelayanan(iduser, idGereja, role, "Umum", "current")),
                    );
                  },
                  child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
                          Colors.blueGrey,
                          Colors.lightBlue,
                        ]),
                        border: Border.all(
                          color: Colors.lightBlue,
                        ),
                      ),
                      child: Row(children: <Widget>[
                        Container(
                          height: 119,
                          width: 120,
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2019/07/01/07/25/last-supper-4309347_960_720.jpg',
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Pendaftaran Umum",
                                style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                "Buat kegiatan umum gereja,\n  active/  deactive kegiatan  \n umum gereja,  Konfirmasi \n pendaftaran user",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ])),
                ),
            ],
          )),
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
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.token, color: Color.fromARGB(255, 0, 0, 0)),
                  label: "History",
                )
              ],
              onTap: (index) {
                if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => history(iduser, idGereja, role)),
                  );
                } else if (index == 0) {}
              },
            ),
          )),
    );
  }
}
