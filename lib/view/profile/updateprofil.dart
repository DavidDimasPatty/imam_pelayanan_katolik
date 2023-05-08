import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:geocode/geocode.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';

class UpdateProfile extends StatefulWidget {
  @override
  final role;
  final iduser;
  final idGereja;
  UpdateProfile(this.iduser, this.idGereja, this.role);

  @override
  _UpdateProfile createState() =>
      _UpdateProfile(this.iduser, this.idGereja, this.role);
}

class _UpdateProfile extends State<UpdateProfile> {
  final role;
  final iduser;
  final idGereja;
  var fileImage;
  var fileChange;
  var imageChange = false;
  TextEditingController nama = new TextEditingController(text: "");
  TextEditingController address = new TextEditingController(text: "");
  TextEditingController paroki = new TextEditingController(text: "");
  TextEditingController lingkungan = new TextEditingController(text: "");
  TextEditingController deskripsi = new TextEditingController(text: "");
  double? lattitude = 0;
  double? longttitude = 0;
  _UpdateProfile(this.iduser, this.idGereja, this.role);

  Future submit() async {
    if (imageChange == false) {
      Completer<void> completer = Completer<void>();
      Message message = Message(
          'Agent Page',
          'Agent Akun',
          "REQUEST",
          Tasks('edit profile gereja', [
            idGereja,
            nama.text,
            address.text,
            paroki.text,
            lingkungan.text,
            deskripsi.text,
            fileImage,
            imageChange
          ]));

      MessagePassing messagePassing =
          MessagePassing(); //Memanggil distributor pesan
      var data = await messagePassing
          .sendMessage(message); //Mengirim pesan ke distributor pesan
      completer.complete(); //Batas pengerjaan yang memerlukan completer
      var hasil = await await AgentPage
          .getData(); //Memanggil data yang tersedia di agen Page

      await completer
          .future; //Proses penungguan sudah selesai ketika varibel hasil
      //memiliki nilai

      if (hasil == "failed") {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Gagal Update Informasi Gereja",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (hasil == 'nama') {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Nama sudah digunakan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Berhasil Update Informasi Gereja",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(iduser, idGereja, role)),
        );
      }
    } else {
      Completer<void> completer = Completer<void>();
      Message message = Message(
          'Agent Page',
          'Agent Akun',
          "REQUEST",
          Tasks('edit profile gereja', [
            idGereja,
            nama.text,
            address.text,
            paroki.text,
            lingkungan.text,
            deskripsi.text,
            fileImage,
            imageChange
          ]));

      MessagePassing messagePassing =
          MessagePassing(); //Memanggil distributor pesan
      var data = await messagePassing
          .sendMessage(message); //Mengirim pesan ke distributor pesan
      completer.complete(); //Batas pengerjaan yang memerlukan completer
      var hasil = await await AgentPage
          .getData(); //Memanggil data yang tersedia di agen Page

      await completer
          .future; //Proses penungguan sudah selesai ketika varibel hasil
      //memiliki nilai
      if (hasil == "failed") {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Gagal Update Informasi Gereja",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Berhasil Update Informasi Gereja",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(iduser, idGereja, role)),
        );
      }
    }
  }

  Future selectFile(context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    File file;
    final path = result.files.single.path;
    file = File(path!);
    setState(() {
      fileImage = file;
      fileChange = file;
    });
  }

  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Akun', "REQUEST",
        Tasks('cari data gereja', idGereja));

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil = await await AgentPage
        .getData(); //Memanggil data yang tersedia di agen Page

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return hasil;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: true,
        title: Text("Update Gereja"),
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
      body: ListView(
        children: [
          FutureBuilder(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                try {
                  nama.text = snapshot.data[0]['nama'];
                  address.text = snapshot.data[0]['address'];
                  paroki.text = snapshot.data[0]['paroki'];
                  lingkungan.text = snapshot.data[0]['lingkungan'];
                  deskripsi.text = snapshot.data[0]['deskripsi'];
                  fileImage = snapshot.data[0]['gambar'];
                  return Column(children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Nama Gereja",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        TextField(
                          controller: nama,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Nama Gereja",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Alamat Gereja",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        TextField(
                          controller: address,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Alamat Gereja",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        RaisedButton(
                            textColor: Colors.white,
                            color: Colors.lightBlue,
                            child: Text("Generate Coordinate"),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {
                              try {
                                GeoCode geoCode = GeoCode();
                                Coordinates coordinates = await geoCode
                                    .forwardGeocoding(address: address.text);

                                setState(() {
                                  lattitude = coordinates.latitude;
                                  longttitude = coordinates.longitude;
                                });
                              } catch (e) {
                                print(e);
                              }
                            }),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Lattitude",
                                ),
                                Text(
                                  lattitude.toString(),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5)),
                            Column(
                              children: [
                                Text(
                                  "Longtittude",
                                ),
                                Text(
                                  longttitude.toString(),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Nama Paroki",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        TextField(
                          controller: paroki,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Nama Paroki",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Nama Lingkungan",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        TextField(
                          controller: lingkungan,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Nama Lingkungan",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        Text(
                          "Deskripsi Gereja",
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        TextField(
                          controller: deskripsi,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: "Deskripsi Gereja",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Text(
                      "Gambar Gereja",
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    Container(
                      child: RaisedButton(
                          onPressed: () async {
                            imageChange = true;
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
                                  maxWidth: 170.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Upload Image",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                    SizedBox(height: 10),
                    if (fileImage == null ||
                        fileImage == "" && imageChange == false)
                      Text(
                        "Belum ada Gambar",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                      ),
                    if (fileImage != null && imageChange == false)
                      Center(
                        child: Image.network(
                          fileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imageChange == true)
                      Text(
                        "File Image Path: \n" + fileChange.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.lightBlue,
                          child: Text("Update Informasi Gereja"),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          onPressed: () async {
                            submit();
                          }),
                    ),
                  ]);
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
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
                  label: "History",
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
    );
  }
}
