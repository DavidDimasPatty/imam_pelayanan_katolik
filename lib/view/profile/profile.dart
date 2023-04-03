import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/homepage.dart';
import 'package:imam_pelayanan_katolik/view/profile/aturanPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/profile/editprofile.dart';
import 'package:imam_pelayanan_katolik/view/profile/updateprofil.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/view/umum/kegiatanUmum.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../history/history.dart';

class Profile extends StatefulWidget {
  var names;
  var iduser;
  var idGereja;

  Profile(this.names, this.iduser, this.idGereja);

  _Profile createState() => _Profile(this.names, this.iduser, this.idGereja);
}

class _Profile extends State<Profile> {
  var names;
  var iduser;
  var idGereja;
  var statusPem;
  var statusPerm;
  var statusPerk;
  var statusTob;

  _Profile(this.names, this.iduser, this.idGereja);
  @override
  Future callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Profile"],
    //   [idGereja],
    //   [iduser]
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
    Message message = Message('View', 'Agent Akun', "REQUEST",
        Tasks('cari profile', [idGereja, iduser]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await messagePassing.messageGetToView();

    await completer.future;
    print(result[1]);
    return result;
  }

  Future gantiStatus(pelayanan, status) async {
    // Messages msg = new Messages();

    // msg.addReceiver("agenAkun");
    // msg.setContent([
    //   ["ganti Status"],
    //   [iduser],
    //   [status]
    // ]);
    // var k;
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // k = await AgenPage().receiverTampilan();
    Completer<void> completer = Completer<void>();
    Message message = Message('View', 'Agent Akun', "REQUEST",
        Tasks('edit status', [iduser, status, pelayanan]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await messagePassing.messageGetToView();

    await completer.future;

    if (result == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Ganti Status Pelayanan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => Profile(name, email, idUser)),
      // );
    }
  }

  // Future gantiStatusPerminyakan(status) async {
  //   Messages msg = new Messages();

  //   msg.addReceiver("agenAkun");
  //   msg.setContent([
  //     ["ganti Status Perminyakan"],
  //     [iduser],
  //     [status]
  //   ]);
  //   var k;
  //   await msg.send().then((res) async {
  //     print("masuk");
  //     print(await AgenPage().receiverTampilan());
  //   });
  //   await Future.delayed(Duration(seconds: 1));
  //   k = await AgenPage().receiverTampilan();

  //   if (k == 'oke') {
  //     Fluttertoast.showToast(
  //         msg: "Berhasil Ganti Status Pelayanan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => Profile(name, email, idUser)),
  //     // );
  //   }
  // }

  // Future gantiStatusTobat(status) async {
  //   Messages msg = new Messages();

  //   msg.addReceiver("agenAkun");
  //   msg.setContent([
  //     ["ganti Status Tobat"],
  //     [iduser],
  //     [status]
  //   ]);
  //   var k;
  //   await msg.send().then((res) async {
  //     print("masuk");
  //     print(await AgenPage().receiverTampilan());
  //   });
  //   await Future.delayed(Duration(seconds: 1));
  //   k = await AgenPage().receiverTampilan();

  //   if (k == 'oke') {
  //     Fluttertoast.showToast(
  //         msg: "Berhasil Ganti Status Pelayanan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => Profile(name, email, idUser)),
  //     // );
  //   }
  // }

  // Future gantiStatusPerkawinan(status) async {
  //   Messages msg = new Messages();

  //   msg.addReceiver("agenAkun");
  //   msg.setContent([
  //     ["ganti Status Perkawinan"],
  //     [iduser],
  //     [status]
  //   ]);
  //   var k;
  //   await msg.send().then((res) async {
  //     print("masuk");
  //     print(await AgenPage().receiverTampilan());
  //   });
  //   await Future.delayed(Duration(seconds: 1));
  //   k = await AgenPage().receiverTampilan();

  //   if (k == 'oke') {
  //     Fluttertoast.showToast(
  //         msg: "Berhasil Ganti Status Pelayanan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => Profile(name, email, idUser)),
  //     // );
  //   }
  // }

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    uploadFile(file, context);
  }

  Future uploadFile(File file, context) async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenAkun");
    // msg.setContent([
    //   ["change Picture"],
    //   [iduser],
    //   [file]
    // ]);
    // var k;
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // k = await AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message = Message('View', 'Agent Akun', "REQUEST",
        Tasks('change profile picture', [iduser, file]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await messagePassing.messageGetToView();

    await completer.future;
    if (hasil == 'oke') {
      Fluttertoast.showToast(
          msg: "Berhasil Ganti Profile Picture",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(names, iduser, idGereja)),
      );
    }
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
        title: Text('Profile'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Profile(names, emails, iduser)),
              // );
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
          child: ListView(children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    statusPem = snapshot.data[0][0]['statusPemberkatan'];
                    statusPerm = snapshot.data[0][0]['statusPerminyakan'];
                    statusPerk = snapshot.data[0][0]['statusPerkawinan'];
                    statusTob = snapshot.data[0][0]['statusTobat'];

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30)),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 350.0,
                                    height: 350.0,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          if (snapshot.data[0][0]['picture'] ==
                                              null)
                                            CircleAvatar(
                                              backgroundImage: AssetImage(''),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              radius: 80.0,
                                            ),
                                          if (snapshot.data[0][0]['picture'] !=
                                              null)
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  snapshot.data[0][0]
                                                      ['picture']),
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              radius: 80.0,
                                            ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            snapshot.data[0][0]['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 5.0),
                                            clipBehavior: Clip.antiAlias,
                                            color: Colors.white,
                                            elevation: 20.0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 7.0,
                                                      vertical: 22.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          "User Mendaftar Pelayanan :",
                                                          style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 20.0,
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
                                                            fontSize: 20.0,
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
                                        ],
                                      ),
                                    ),
                                  ))),
                          Container(
                              height: 150,
                              width: 350,
                              decoration: BoxDecoration(
                                color: Colors.indigo[100],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)),
                              ),
                              child: ListView(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                    ),
                                    Text(
                                      'Informasi Gereja:',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
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
                                                  Text(
                                                    "Nama Gereja : " +
                                                        snapshot.data[0][0]
                                                                ['userGereja']
                                                            [0]['nama'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "Nama Paroki : " +
                                                        snapshot.data[0][0]
                                                                ['userGereja']
                                                            [0]['paroki'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "Alamat : " +
                                                        snapshot.data[0][0]
                                                                ['userGereja']
                                                            [0]['address'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    "Deskripsi : " +
                                                        snapshot.data[0][0]
                                                                ['userGereja']
                                                            [0]['deskripsi'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
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
                                  ],
                                ),
                              ])),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  // await ImagePicker()
                                  //     .pickImage(source: ImageSource.gallery);
                                  await selectFile(context);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Change Profile Picture",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateProfile(
                                            names, iduser, idGereja)),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Edit Informasi Gereja",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile(
                                            names, iduser, idGereja)),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Edit Profile Imam",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AturanPelayanan(
                                            names, iduser, idGereja)),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Aturan Pelayanan Gereja",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  var temp;
                                  if (snapshot.data[0][0]
                                          ['statusPemberkatan'] ==
                                      0) {
                                    temp = 1;
                                  } else {
                                    temp = 0;
                                  }
                                  await gantiStatus("sakramentali", temp);
                                  setState(() {
                                    // callDb();

                                    statusPem = snapshot.data[0][0]
                                        ['statusPemberkatan'];
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      Text(
                                        "Ganti Status Sakramentali",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      if (statusPem == 0)
                                        Text(
                                          "Melayani",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      if (statusPem == 1)
                                        Text(
                                          "Tidak Melayani",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        )
                                    ]),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  var temp;
                                  if (snapshot.data[0][0]
                                          ['statusPerminyakan'] ==
                                      0) {
                                    temp = 1;
                                  } else {
                                    temp = 0;
                                  }
                                  await gantiStatus("perminyakan", temp);
                                  setState(() {
                                    // callDb();

                                    statusPerm = snapshot.data[0][0]
                                        ['statusPerminyakan'];
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      Text(
                                        "Ganti Status Perminyakan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      if (statusPerm == 0)
                                        Text(
                                          "Melayani",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      if (statusPerm == 1)
                                        Text(
                                          "Tidak Melayani",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        )
                                    ]),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  var temp;
                                  if (snapshot.data[0][0]['statusTobat'] == 0) {
                                    temp = 1;
                                  } else {
                                    temp = 0;
                                  }
                                  await gantiStatus("tobat", temp);
                                  setState(() {
                                    // callDb();

                                    statusTob =
                                        snapshot.data[0][0]['statusTobat'];
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      Text(
                                        "Ganti Status Tobat",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      if (statusTob == 0)
                                        Text(
                                          "Melayani",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      if (statusTob == 1)
                                        Text(
                                          "Tidak Melayani",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        )
                                    ]),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                          Container(
                            width: 300.00,
                            child: RaisedButton(
                                onPressed: () async {
                                  var temp;
                                  if (snapshot.data[0][0]['statusPerkawinan'] ==
                                      0) {
                                    temp = 1;
                                  } else {
                                    temp = 0;
                                  }
                                  await gantiStatus("perkawinan", temp);
                                  setState(() {
                                    // callDb();

                                    statusPerk =
                                        snapshot.data[0][0]['statusPerkawinan'];
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                elevation: 0.0,
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.topLeft,
                                        colors: [
                                          Colors.blueAccent,
                                          Colors.lightBlue,
                                        ]),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 300.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      Text(
                                        "Ganti Status Perkawinan",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      if (statusPerk == 0)
                                        Text(
                                          "Melayani",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      if (statusPerk == 1)
                                        Text(
                                          "Tidak Melayani",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w600),
                                        )
                                    ]),
                                  ),
                                )),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                        ]);
                  } catch (e) {
                    print(e);
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ])),
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
    );
  }
}
