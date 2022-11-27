import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';

class DetailSakramentali extends StatefulWidget {
  final name;

  final idUser;
  final idGereja;
  final idPemberkatan;

  DetailSakramentali(this.name, this.idUser, this.idGereja, this.idPemberkatan);
  @override
  _DetailSakramentali createState() => _DetailSakramentali(
      this.name, this.idUser, this.idGereja, this.idPemberkatan);
}

class _DetailSakramentali extends State<DetailSakramentali> {
  final name;

  final idUser;
  final idGereja;
  final idPemberkatan;
  _DetailSakramentali(
      this.name, this.idUser, this.idGereja, this.idPemberkatan);
  @override
  Future<List> callDb() async {
    var data = await MongoDatabase.pemberkatanSpec(idPemberkatan);
    return data;
  }

  // void submitForm(nama, paroki, lingkungan, notelp, alamat, jenis, tanggal,
  //     note, context) async {
  //   var add = await MongoDatabase.addPemberkatan(
  //       idUser, nama, paroki, lingkungan, notelp, alamat, jenis, tanggal, note);
  //   if (add == 'oke') {
  //     Fluttertoast.showToast(
  //         msg: "Berhasil Mendaftar Pemberkatan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(builder: (context) => HomePage(name, email, idUser)),
  //     // );
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Gagal Mendaftar Pemberkatan",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 2,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pemberkatan'),
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
              //       builder: (context) => Profile(name, email, idUser)),
              // );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List>(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama Lengkap",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["namaLengkap"])
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
                        "Paroki",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["paroki"])
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
                        "Lingkungan",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["lingkungan"])
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
                        "Nomor Telephone",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["notelp"])
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
                        "Alamat Lengkap",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["alamat"])
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
                        "Jenis Pemberkatan",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["jenis"])
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
                        "Tanggal",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Text(snapshot.data[0]["tanggal"].toString())
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
                      Text(snapshot.data[0]["note"])
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 11),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {},
                        child: Text('Accept'),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                      RaisedButton(
                        onPressed: () async {},
                        child: Text('Reject'),
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
          }),
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => tiketSaya(names, emails, idUser)),
                  // );
                } else if (index == 0) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => HomePage(names, emails, idUser)),
                  // );
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
