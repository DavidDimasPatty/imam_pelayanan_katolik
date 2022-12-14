import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/fireBase.dart';
import 'package:imam_pelayanan_katolik/history.dart';
import 'package:imam_pelayanan_katolik/homePage.dart';
import 'package:imam_pelayanan_katolik/kegiatanUmum.dart';
import 'package:imam_pelayanan_katolik/sakramen.dart';
import 'package:imam_pelayanan_katolik/sakramentali.dart';
import 'package:file_picker/file_picker.dart';
import 'package:imam_pelayanan_katolik/setting.dart';
import 'package:imam_pelayanan_katolik/updateprofil.dart';
import 'DatabaseFolder/mongodb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatelessWidget {
  var names;
  var iduser;
  var idGereja;
  var dataUser;
  var data;

  Profile(this.names, this.iduser, this.idGereja);
  @override
  Future<List> callDb() async {
    return await MongoDatabase.callAdmin(iduser);
  }

  Future<List> calljumlahTotal() async {
    return await MongoDatabase.callJumlahTotal(idGereja);
  }

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    uploadFile(file, context);
  }

  Future uploadFile(File file, context) async {
    if (file == null) return;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);
    final filename = date.toString();
    final destination = 'files/$filename';
    UploadTask? task = FirebaseApi.uploadFile(destination, file);
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await MongoDatabase.updateProfilePicture(iduser, urlDownload).then((value) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(names, iduser, idGereja)),
      );
    });

    //print('Download-Link: $urlDownload');
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
      body: ListView(children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        FutureBuilder(
            future: callDb(),
            builder: (context, AsyncSnapshot snapshot) {
              try {
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      if (snapshot.data[0]['picture'] == null)
                                        CircleAvatar(
                                          backgroundImage: AssetImage(''),
                                          backgroundColor: Colors.greenAccent,
                                          radius: 80.0,
                                        ),
                                      if (snapshot.data[0]['picture'] != null)
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[0]['picture']),
                                          backgroundColor: Colors.greenAccent,
                                          radius: 80.0,
                                        ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        snapshot.data[0]['name'],
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
                                                    FutureBuilder(
                                                        future:
                                                            calljumlahTotal(),
                                                        builder: (context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                          try {
                                                            return Text(
                                                              snapshot.data[0]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            print(e);
                                                            return SizedBox(
                                                                height: 10,
                                                                width: 10,
                                                                child:
                                                                    CircularProgressIndicator());
                                                          }
                                                        }),
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
                                  padding: EdgeInsets.symmetric(vertical: 5),
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
                                              Text(
                                                "Nama Gereja : " +
                                                    snapshot.data[0]
                                                            ['userGereja'][0]
                                                        ['nama'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "Nama Paroki : " +
                                                    snapshot.data[0]
                                                            ['userGereja'][0]
                                                        ['paroki'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "Alamat : " +
                                                    snapshot.data[0]
                                                            ['userGereja'][0]
                                                        ['address'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                "Deskripsi : " +
                                                    snapshot.data[0]
                                                            ['userGereja'][0]
                                                        ['deskripsi'],
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
                              await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
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
                                    builder: (context) =>
                                        UpdateProfile(names, iduser, idGereja)),
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
                    ]);
              } catch (e) {
                print(e);
                return Center(child: CircularProgressIndicator());
              }
            }),
      ]),
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
