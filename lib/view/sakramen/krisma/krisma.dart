import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/krisma/addKrisma.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/krisma/editKrisma.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/krisma/krismaUser.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/sakramen.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import '../../history/history.dart';
import '../../profile/profile.dart';

class Krisma extends StatefulWidget {
  var names;
  final idUser;
  final idGereja;
  Krisma(this.names, this.idUser, this.idGereja);
  @override
  _Krisma createState() => _Krisma(this.names, this.idUser, this.idGereja);
}

class _Krisma extends State<Krisma> {
  var names;
  var emails;
  var distance;
  List daftarUser = [];

  List dummyTemp = [];
  final idUser;
  final idGereja;
  _Krisma(this.names, this.idUser, this.idGereja);

  Future<List> callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Krisma"],
    //   [idGereja]
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
        Tasks('cari pelayanan', [idGereja, "krisma", "current"]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getDataPencarian();

    await completer.future;
    return await hasil;
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
        if (item['jadwalBuka']
            .toString()
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

  void updateKegiatan(id, status) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPendaftaran");
    // msg.setContent([
    //   ["update Krisma"],
    //   [idKegiatan],
    //   [status]
    // ]);
    // var hasil;
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('update status pelayanan', ["krisma", id, status, idUser]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getDataPencarian();
    if (hasil == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Deactive Kegiatan Krisma",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Deactive Kegiatan Krisma",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      callDb().then((result) {
        setState(() {
          daftarUser.clear();
          dummyTemp.clear();
          daftarUser.addAll(result);
          dummyTemp.addAll(result);
          filterSearchResults(editingController.text);
        });
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
        automaticallyImplyLeading: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Krisma'),
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
                helpText: 'Cari Krisma',
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  addKrisma(names, idUser, idGereja)),
                        );
                      },
                      splashColor: Colors.blue,
                      splashRadius: 30,
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
                Text("Add Krisma")
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
                                  builder: (context) => KrismaUser(
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
                                  "Krisma " +
                                      i['jadwalBuka']
                                          .toString()
                                          .substring(0, 10),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  'Kapasitas: ' + i['kapasitas'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  'Jadwal Tutup: ' +
                                      i['jadwalTutup'].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                      textColor: Colors.white,
                                      color: Colors.lightBlue,
                                      child: Text("Edit Krisma"),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => editKrisma(
                                                  names,
                                                  idUser,
                                                  idGereja,
                                                  i['_id'])),
                                        );
                                      }),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                      textColor: Colors.white,
                                      color: Colors.lightBlue,
                                      child: Text("Deactive Kegiatan"),
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0),
                                      ),
                                      onPressed: () async {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title:
                                                const Text('Confirm Deactive'),
                                            content: const Text(
                                                'Yakin ingin mendeactive kegiatan ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Tidak'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  updateKegiatan(i["_id"], 1);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ya'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ])),
                        ),

                      /////////
                    ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
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
