import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';

import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/daftarPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/baptis.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/komuni/komuni.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/krisma/krisma.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/perkawinan/perkawinan.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';

class pelayanan extends StatefulWidget {
  var role;
  var iduser;
  var idGereja;
  String jenisPelayanan;
  String jenisPencarian;

  pelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian);
  _pelayanan createState() => _pelayanan(this.iduser, this.idGereja, this.role,
      this.jenisPelayanan, this.jenisPencarian);
}

class _pelayanan extends State<pelayanan> {
  var role;
  var iduser;
  var idGereja;
  String jenisPencarian;
  String jenisPelayanan;
  List<String>? selectedPelayanan;
  Map<String, List<String>> pelayananValue = {
    "Sakramen": ["Baptis", "Komuni", "Krisma", "Perkawinan"],
    "Umum": [
      "Rekoleksi",
      "Retret",
    ],
    "Sakramentali": ["Pemberkatan"]
  };
  _pelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian);

  Future callJumlah() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari jumlah ' + jenisPelayanan, [idGereja, iduser, role]));

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai

    return await hasil;
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      callJumlah();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pelayananValue.containsKey(jenisPelayanan))
      selectedPelayanan = pelayananValue[jenisPelayanan];
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: true,
        title: Text(jenisPelayanan),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(iduser, idGereja, role)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(iduser, idGereja, role)),
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
            /////////
            FutureBuilder(
                future: callJumlah(),
                builder: (context, AsyncSnapshot snapshot) {
                  //exception

                  try {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        if (jenisPencarian == "current")
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 20.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7.0, vertical: 22.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Total Pendaftaran " +
                                              jenisPelayanan +
                                              " :",
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
                                          if (role == 1 &&
                                              jenisPelayanan == "Sakramen" &&
                                              jenisPencarian == "current")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Baptis",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[1]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          if (role == 1 &&
                                              jenisPelayanan == "Sakramen" &&
                                              jenisPencarian == "current")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Komuni",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[2]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          if (role == 1 &&
                                              jenisPelayanan == "Sakramen" &&
                                              jenisPencarian == "current")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Krisma",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[3]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          if (role == 0 &&
                                              jenisPelayanan == "Sakramen" &&
                                              jenisPencarian == "current")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Perkawinan",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[4]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          if (role == 1 &&
                                              jenisPelayanan == "Umum" &&
                                              jenisPencarian == "current")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Rekoleksi",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[1]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                          if (role == 1 &&
                                              jenisPelayanan == "Umum")
                                            Expanded(
                                              child: Card(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5.0,
                                                    vertical: 5.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
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
                                                            "Retret",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10.0,
                                                          ),
                                                          Text(
                                                            snapshot.data[2]
                                                                .toString(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                }),
            if (role == 1 && jenisPelayanan == "Sakramen")
              for (var i in selectedPelayanan!)
                if (i != "Perkawinan")
                  InkWell(
                    borderRadius: new BorderRadius.circular(24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => daftarPelayanan(
                                iduser,
                                idGereja,
                                role,
                                jenisPelayanan,
                                jenisPencarian,
                                i)),
                      );
                    },
                    child: Container(
                        margin:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.topLeft,
                              colors: [
                                Colors.blueGrey,
                                Colors.lightBlue,
                              ]),
                          border: Border.all(
                            color: Colors.lightBlue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: <Widget>[
                          Text(
                            i,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.left,
                          ),
                        ])),
                  ),
            if (role == 0 && jenisPelayanan == "Sakramen")
              for (var i in selectedPelayanan!)
                if (i == "Perkawinan")
                  InkWell(
                    borderRadius: new BorderRadius.circular(24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => daftarPelayanan(
                                iduser,
                                idGereja,
                                role,
                                jenisPelayanan,
                                jenisPencarian,
                                i)),
                      );
                    },
                    child: Container(
                        margin:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.topLeft,
                              colors: [
                                Colors.blueGrey,
                                Colors.lightBlue,
                              ]),
                          border: Border.all(
                            color: Colors.lightBlue,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(children: <Widget>[
                          //Color(Colors.blue);

                          Text(
                            i,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.left,
                          ),
                        ])),
                  ),
            if (role == 1 && jenisPelayanan == "Umum")
              for (var i in selectedPelayanan!)
                InkWell(
                  borderRadius: new BorderRadius.circular(24),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => daftarPelayanan(
                              iduser,
                              idGereja,
                              role,
                              jenisPelayanan,
                              jenisPencarian,
                              i)),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.topLeft,
                            colors: [
                              Colors.blueGrey,
                              Colors.lightBlue,
                            ]),
                        border: Border.all(
                          color: Colors.lightBlue,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(children: <Widget>[
                        //Color(Colors.blue);

                        Text(
                          i,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.left,
                        ),
                      ])),
                ),

            /////////
            ///
          ],
        ),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
                    MaterialPageRoute(
                        builder: (context) => History(iduser, idGereja, role)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(iduser, idGereja, role)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
