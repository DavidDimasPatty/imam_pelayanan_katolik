import 'dart:async';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import '../history.dart';
import '../profile/profile.dart';

class notification extends StatefulWidget {
  final role;
  final idGereja;
  final iduser;
  notification(this.iduser, this.idGereja, this.role);
  @override
  _notifClass createState() =>
      _notifClass(this.iduser, this.idGereja, this.role);
}

class _notifClass extends State<notification> {
  final role;
  final iduser;
  final idGereja;
  var checknotif;
  _notifClass(this.iduser, this.idGereja, this.role);
  bool switch1 = false;
  void isSwitch() {
    switch1 = true;
  }

  bool switch2 = false;
  void isSwitch2() {
    switch2 = true;
  }

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message(
        'Agent Page', 'Agent Akun', "REQUEST", Tasks('cari data imam', iduser));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var checknotif = await await AgentPage.getDataPencarian();

    await completer.future;

    return checknotif;
  }

  Future updateNotif(notif) async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('update notification', [iduser, notif]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getDataPencarian();

    await completer.future;

    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Update Notif",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
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
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    switch1 = snapshot.data[0]['notif'];

                    return Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6)),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Pengingat Gereja',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'Jika dimatikan tidak akan mendapatkan notifikasi gereja dimulai 1 jam sebelumnya',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Switch(
                              value: switch1,
                              onChanged: (value) {
                                setState(() async {
                                  switch1 = value;
                                  await updateNotif(switch1);
                                  // await callDb();
                                  setState(() {
                                    switch1 = snapshot.data[0]['notif'];
                                  });
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      ],
                    );
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
                  label: "Jadwalku",
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
