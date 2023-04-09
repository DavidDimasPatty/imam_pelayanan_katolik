import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';

import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';
import '../../profile/profile.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';

class RekoleksiUser extends StatefulWidget {
  var role;
  final iduser;
  final idGereja;
  final idRekoleksi;
  RekoleksiUser(this.iduser, this.idGereja, this.role, this.idRekoleksi);
  @override
  _RekoleksiUser createState() =>
      _RekoleksiUser(this.iduser, this.idGereja, this.role, this.idRekoleksi);
}

class _RekoleksiUser extends State<RekoleksiUser> {
  var role;
  var emails;
  var distance;
  List hasil = [];
  StreamController _controller = StreamController();

  List dummyTemp = [];
  final iduser;
  final idGereja;
  final idRekoleksi;
  _RekoleksiUser(this.iduser, this.idGereja, this.role, this.idRekoleksi);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Rekoleksi User"],
    //   [idRekoleksi]
    // ]);
    // List k = [];
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // k = await AgenPage().receiverTampilan();

    // return k;
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan user', [idRekoleksi, "rekoleksi", "current"]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    var hasilPencarian = await AgentPage.getDataPencarian();

    completer.complete();

    await completer.future;
    return await hasilPencarian;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['userRekoleksi'][0]['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
    } else {
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future updateReject(id, token, idTarget) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPendaftaran");
    // msg.setContent([
    //   ["update Kegiatan User"],
    //   [id],
    //   [token],
    //   [idTarget],
    //   [-1]
    // ]);
    // var hasil;
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('update pelayanan user',
            ["umum", id, token, idTarget, -1, iduser]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasilDaftar = await await AgentPage.getDataPencarian();

    if (hasilDaftar == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Reject User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Reject User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      callDb().then((result) {
        setState(() {
          hasil.clear();
          dummyTemp.clear();
          hasil.addAll(result);
          dummyTemp.addAll(result);
          _controller.add(result);
        });
      });
    }
  }

  Future updateAccept(id, token, idTarget) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPendaftaran");
    // msg.setContent([
    //   ["update Kegiatan User"],
    //   [id],
    //   [token],
    //   [idTarget],
    //   [1]
    // ]);
    // var hasil;
    // await msg.send();
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks(
            'update pelayanan user', ["umum", id, token, idTarget, 1, iduser]));
    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasilDaftar = await await AgentPage.getDataPencarian();

    if (hasilDaftar == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Accept User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Accept User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      callDb().then((result) {
        setState(() {
          hasil.clear();
          dummyTemp.clear();
          hasil.addAll(result);
          dummyTemp.addAll(result);
          _controller.add(result);
        });
      });
    }
  }

  Future pullRefresh() async {
    callDb().then((result) {
      setState(() {
        hasil.clear();
        dummyTemp.clear();
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
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
        title: Text('Rekoleksi'),
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
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  try {
                    return Column(children: [
                      for (var i in hasil)
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => DetailSakramentali(
                            //           names, idUser, idGereja, i['_id'])),
                            // );
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
                                  "Nama :" +
                                      i['userRekoleksi'][0]['name'].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                                Text(
                                  "Tanggal Daftar :" +
                                      i['tanggalDaftar']
                                          .toString()
                                          .substring(0, 10),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                                if (i['status'] == "0")
                                  Text(
                                    'Status: Menunggu',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lightBlue,
                                          child: Text("Accept"),
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () async {
                                            updateAccept(
                                                i['_id'],
                                                i['userRekoleksi'][0]['token'],
                                                i['idKegiatan']);
                                            callDb().then((result) {});
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10)),
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                            textColor: Colors.white,
                                            color: Colors.lightBlue,
                                            child: Text("Reject"),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            onPressed: () async {
                                              updateReject(
                                                  i['_id'],
                                                  i['userRekoleksi'][0]
                                                      ['token'],
                                                  i['idKegiatan']);
                                              callDb().then((result) {});
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
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
