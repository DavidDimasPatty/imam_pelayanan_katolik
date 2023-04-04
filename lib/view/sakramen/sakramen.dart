import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history/history.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/baptis.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/komuni/komuni.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/krisma/krisma.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/perkawinan/perkawinan.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';

class Sakramen extends StatefulWidget {
  var names;
  var iduser;
  var idGereja;
  Sakramen(this.names, this.iduser, this.idGereja);
  _Sakramen createState() => _Sakramen(this.names, this.iduser, this.idGereja);
}

class _Sakramen extends State<Sakramen> {
  var names;
  var iduser;
  var idGereja;

  _Sakramen(this.names, this.iduser, this.idGereja);

  Future callJumlah() async {
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari jumlah Sakramen"],
    //   [idGereja],
    //   [iduser]
    // ]);
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();

    // return await hasil;
    Completer<void> completer = Completer<void>();
    Message message = Message('View', 'Agent Pencarian', "REQUEST",
        Tasks('cari jumlah sakramen', [idGereja, iduser]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await messagePassing.messageGetToView();

    await completer.future;

    return await hasil;
  }

  Future pullRefresh() async {
    setState(() {
      callJumlah();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Sakramen"),
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
                    builder: (context) => Profile(names, iduser, idGereja)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, iduser, idGereja)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Total Pendaftaran Sakramen :",
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
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[1]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                                          color: Colors.blue,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[2]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[3]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                        Expanded(
                                          child: Card(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0, vertical: 5.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                                        "Kawin",
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        snapshot.data[4]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                }),
            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Baptis(names, iduser, idGereja)),
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
                      "Baptis",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),

            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Komuni(names, iduser, idGereja)),
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
                      "Komuni",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),

            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Krisma(names, iduser, idGereja)),
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
                      "Krisma",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.left,
                    ),
                  ])),
            ),

            InkWell(
              borderRadius: new BorderRadius.circular(24),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Perkawinan(names, iduser, idGereja)),
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
                      "Perkawinan",
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
                        builder: (context) => History(names, iduser, idGereja)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(names, iduser, idGereja)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
