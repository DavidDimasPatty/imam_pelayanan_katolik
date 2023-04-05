import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/history/history.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramentali/pemberkatan/sakramentalidetail.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';

class HistorySakramentali extends StatefulWidget {
  var names;
  final idUser;
  final idGereja;
  HistorySakramentali(this.names, this.idUser, this.idGereja);
  @override
  _HistorySakramentali createState() =>
      _HistorySakramentali(this.names, this.idUser, this.idGereja);
}

class _HistorySakramentali extends State<HistorySakramentali> {
  var names;
  List daftarUser = [];

  List dummyTemp = [];
  final idUser;
  final idGereja;
  _HistorySakramentali(this.names, this.idUser, this.idGereja);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Sakramentali History"],
    //   [idGereja]
    // ]);
    // List k = [];
    // await msg.send().then((res) async {
    //   print("masuk");
    // });
    // await Future.delayed(Duration(seconds: 1));
    // k = await AgenPage().receiverTampilan();

    // return k;
    Completer<void> completer = Completer<void>();
    Message message = Message('View', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', [idUser, "sakramentali", "history"]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await messagePassing.messageGetToView();

    await completer.future;

    return result;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        daftarUser.addAll(result);
        dummyTemp.addAll(result);
      });
    });
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['userDaftar'][0]['name']
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        daftarUser.clear();
        daftarUser.addAll(listOMaps);
      });
      return daftarUser;
    } else {
      setState(() {
        daftarUser.clear();
        daftarUser.addAll(dummyTemp);
      });
    }
  }

  Future pullRefresh() async {
    setState(() {
      callDb().then((result) {
        setState(() {
          daftarUser.clear();
          dummyTemp.clear();
          daftarUser.addAll(result);
          dummyTemp.addAll(result);
          filterSearchResults(editingController.text);
        });
      });
      ;
    });
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    editingController.addListener(() async {
      await filterSearchResults(editingController.text);
    });
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('History Sakramentali'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(names, idUser, idGereja)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, idUser, idGereja)),
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
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Umat',
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
              ),
            ),

            /////////
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    return Column(children: [
                      for (var i in daftarUser)
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailSakramentali(
                                      names, idUser, idGereja, i['_id'])),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: <Widget>[
                                //Color(Colors.blue);

                                Text(
                                  i['userDaftar'][0]['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Jenis Pemberkatan: ' + i['jenis'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  'Alamat: ' + i['alamat'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  'Tanggal: ' + i['tanggal'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                if (i['status'] == 0)
                                  Text(
                                    'Status: Menunggu',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                if (i['status'] == 1)
                                  Text(
                                    'Status: Accept',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                if (i['status'] == -1)
                                  Text(
                                    'Status: Reject',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                // FutureBuilder(
                                //     future: jarak(i['GerejaKomuni'][0]['lat'],
                                //         i['GerejaKomuni'][0]['lng']),
                                //     builder: (context, AsyncSnapshot snapshot) {
                                //       try {
                                //         return Column(children: <Widget>[
                                //           Text(
                                //             snapshot.data,
                                //             style: TextStyle(
                                //                 color: Colors.white, fontSize: 12),
                                //           )
                                //         ]);
                                //       } catch (e) {
                                //         print(e);
                                //         return Center(child: CircularProgressIndicator());
                                //       }
                                //     }),
                              ])),
                        ),
                    ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            /////////
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
                        builder: (context) => History(names, idUser, idGereja)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage(names, idUser, idGereja)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     openCamera();
      //   },
      //   tooltip: 'Increment',
      //   child: new Icon(Icons.camera_alt_rounded),
      // ),
    );
  }
}
