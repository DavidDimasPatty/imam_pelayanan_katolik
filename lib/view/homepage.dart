//import
import 'dart:async';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/history/history.dart';
import 'package:imam_pelayanan_katolik/view/pengumuman/pengumumanGereja.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/sakramen.dart';
import 'package:imam_pelayanan_katolik/view/sakramentali/pemberkatan/sakramentali.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/view/umum/kegiatanUmum.dart';

//stateless dan class
class HomePage extends StatefulWidget {
  var names;
  var iduser;
  var idGereja;
  HomePage(this.names, this.iduser, this.idGereja);
  _HomePage createState() => _HomePage(this.names, this.iduser, this.idGereja);
}

class _HomePage extends State<HomePage> {
  var names;
  var iduser;
  var idGereja;

  _HomePage(this.names, this.iduser, this.idGereja);

  @override

  //function
  // Future callDb() async {
  //   //async
  //   return await MongoDatabase.callAdmin(iduser);
  // }

  Future callJumlah() async {
    // List hasil = [];
    // Messages msg = new Messages();
    // await msg.addReceiver("agenPencarian");
    // await msg.setContent([
    //   ["cari jumlah"],
    //   [idGereja],
    //   [iduser]
    // ]);
    // await msg.send();
    // await Future.delayed(Duration(seconds: 2));
    // hasil = await AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('cari jumlah', [idGereja, iduser]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getDataPencarian();

    await completer.future;
    return hasil;
  }

  Future pullRefresh() async {
    setState(() {
      callJumlah();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              SizedBox(
                height: 10,
              ),
              Container(
                  height: 305,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  child: ListView(children: [
                    FutureBuilder(
                        future: callJumlah(),
                        builder: (context, AsyncSnapshot snapshot) {
                          //exception

                          try {
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
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
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
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Halo, \n" + names,
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Column(children: <Widget>[
                                                    //control flow statement
                                                    if (snapshot.data[4][0]
                                                            ['picture'] !=
                                                        null)
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                snapshot.data[4]
                                                                        [0][
                                                                    'picture']),
                                                        backgroundColor:
                                                            Colors.greenAccent,
                                                        radius: 30.0,
                                                      ),
                                                    if (snapshot.data[4][0]
                                                            ['picture'] ==
                                                        null)
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(''),
                                                        backgroundColor:
                                                            Colors.greenAccent,
                                                        radius: 30.0,
                                                      ),
                                                  ])
                                                ],
                                              ),
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
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
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
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      15.0,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      16.0,
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
                                                Expanded(
                                                  child: Card(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      12.0,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      16.0,
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
                                                Expanded(
                                                  child: Card(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5.0,
                                                            vertical: 5.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      15.0,
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
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize:
                                                                      16.0,
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
                    MaterialPageRoute(
                        builder: (context) =>
                            Sakramen(names, iduser, idGereja)),
                  );
                },
                child: Container(
                    height: 120,
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
                        children: [
                          Text(
                            "Pendaftaran Sakramen",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Buat kegiatan pelayanan sakramen baru, \n active/ deactive kegiatan  \n pelayanan sakramen, \n Konfirmasi pendaftaran user",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
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
                            Sakramentali(names, iduser, idGereja)),
                  );
                },
                child: Container(
                    height: 120,
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
                    ),
                    child: Row(children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Pendaftaran Sakramentali",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            " Konfirmasi pendaftaran user yang \n mendaftarkan pelayanan pemberkatan \npada gereja",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
                    ])),
              ),

              InkWell(
                borderRadius: new BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            KegiatanUmum(names, iduser, idGereja)),
                  );
                },
                child: Container(
                    height: 120,
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
                        children: [
                          Text(
                            "Pendaftaran Kegiatan Umum",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Buat kegiatan umum gereja, active/ \n  deactive kegiatan  \n umum gereja,  Konfirmasi \n pendaftaran user",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
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
                            PengumumanGereja(names, iduser, idGereja)),
                  );
                },
                child: Container(
                    height: 120,
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
                    ),
                    child: Row(children: <Widget>[
                      Column(
                        children: [
                          Text(
                            "Buat Pengumuman Gereja",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Buat Pengumuman untuk para Umat \n Katolik mengenai Gereja",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
                    ])),
              ),
              /////////
            ],
          )),
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
                    MaterialPageRoute(
                        builder: (context) => History(names, iduser, idGereja)),
                  );
                } else if (index == 0) {}
              },
            ),
          )),
    );
  }
}
