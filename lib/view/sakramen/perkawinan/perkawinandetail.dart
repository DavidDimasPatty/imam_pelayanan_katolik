import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';

import '../../history.dart';
import '../../profile/profile.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';

class DetailPerkawinan extends StatefulWidget {
  final role;

  final iduser;
  final idGereja;
  final idPerkawinan;

  DetailPerkawinan(this.iduser, this.idGereja, this.role, this.idPerkawinan);
  @override
  _DetailPerkawinan createState() => _DetailPerkawinan(
      this.iduser, this.idGereja, this.role, this.idPerkawinan);
}

class _DetailPerkawinan extends State<DetailPerkawinan> {
  final role;

  final iduser;
  final idGereja;
  final idPerkawinan;
  _DetailPerkawinan(this.iduser, this.idGereja, this.role, this.idPerkawinan);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pelayanan', [idPerkawinan, "perkawinan", "detail"]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getData();

    await completer.future;
    return await hasil;
  }

  Future updateAccept(token, idTarget, notif) async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('update pelayanan user', [
          "perkawinan",
          idPerkawinan,
          token,
          idPerkawinan,
          1,
          iduser,
          notif
        ]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getData();

    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Menyelsaikan Pelayanan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Terima Kasih Sudah Menyelsaikan Pelayanan!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      callDb();
    });
  }

  Future updateReject(token, idTarget, notif) async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('update pelayanan user', [
          "perkawinan",
          idPerkawinan,
          token,
          idPerkawinan,
          -1,
          iduser,
          notif
        ]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getData();
    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Menolak Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Menolak Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      callDb();
    });
  }

  Future updateDone(token, idTarget, notif) async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page',
        'Agent Pendaftaran',
        "REQUEST",
        Tasks('update pelayanan user', [
          "perkawinan",
          idPerkawinan,
          token,
          idPerkawinan,
          2,
          iduser,
          false
        ]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getData();
    if (hasil == "failed") {
      Fluttertoast.showToast(
          msg: "Gagal Menolak Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Menolak Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      callDb();
    });
  }

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Detail Perkawinan'),
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
      body: RefreshIndicator(
          onRefresh: pullRefresh,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10, top: 10),
              ),
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(right: 15, left: 15),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nama Pendaftar : ",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[1][0]["nama"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nama Pria dan Wanita: ",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["namaPria"] +
                                  " & " +
                                  snapshot.data[0][0]["namaPerempuan"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nomor Telephone :",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["notelp"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email :",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["email"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Alamat Pernikahan :",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["alamat"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tanggal Pernikahan :",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["tanggal"].toString())
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Note Tambahan",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              Text(snapshot.data[0][0]["note"])
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status :",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              if (snapshot.data[0][0]["status"] == 0)
                                Text("Menunggu"),
                              if (snapshot.data[0][0]["status"] == 1)
                                Text("Diterima"),
                              if (snapshot.data[0][0]["status"] == 2)
                                Text("Selesai"),
                              if (snapshot.data[0][0]["status"] == -1)
                                Text("Ditolak")
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
                          if (snapshot.data[0][0]["status"] != 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (snapshot.data[0][0]["status"] == -1 ||
                                    snapshot.data[0][0]["status"] == 0)
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
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Confirm Accept'),
                                                content: const Text(
                                                    'Yakin ingin melakukan pelayanan perkawinan ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      updateAccept(
                                                          snapshot.data[1][0]
                                                              ['token'],
                                                          snapshot.data[1][0]
                                                              ['_id'],
                                                          snapshot.data[1][0]
                                                              ['notifGD']);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ya'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                if (snapshot.data[0][0]["status"] == 1)
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: RaisedButton(
                                          textColor: Colors.white,
                                          color: Colors.lightBlue,
                                          child: Text("Selesai"),
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          onPressed: () async {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Confirm Selesai'),
                                                content: const Text(
                                                    'Yakin sudah melakukan pelayanan perkawinan ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Tidak'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      updateDone(
                                                          snapshot.data[1][0]
                                                              ['token'],
                                                          snapshot.data[1][0]
                                                              ['_id'],
                                                          snapshot.data[1][0]
                                                              ['notifGD']);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ya'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.lightBlue,
                                        child: Text("Reject"),
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
                                                  const Text('Confirm Reject'),
                                              content: const Text(
                                                  'Yakin ingin menolak pelayanan perkawinan ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    updateReject(
                                                        snapshot.data[1][0]
                                                            ['token'],
                                                        snapshot.data[1][0]
                                                            ['_id'],
                                                        snapshot.data[1][0]
                                                            ['notifGD']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ],
                      );
                    } catch (e) {
                      print(e);
                      return Center(child: CircularProgressIndicator());
                    }
                  })
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
