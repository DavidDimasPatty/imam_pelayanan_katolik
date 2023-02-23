import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/agen/messages.dart';
import 'package:imam_pelayanan_katolik/history.dart';
import 'package:imam_pelayanan_katolik/homePage.dart';
import 'package:imam_pelayanan_katolik/profile.dart';
import 'package:imam_pelayanan_katolik/sakramentali.dart';

class DetailPerkawinan extends StatefulWidget {
  final name;

  final idUser;
  final idGereja;
  final idPerkawinan;

  DetailPerkawinan(this.name, this.idUser, this.idGereja, this.idPerkawinan);
  @override
  _DetailPerkawinan createState() => _DetailPerkawinan(
      this.name, this.idUser, this.idGereja, this.idPerkawinan);
}

class _DetailPerkawinan extends State<DetailPerkawinan> {
  final name;

  final idUser;
  final idGereja;
  final idPerkawinan;
  _DetailPerkawinan(this.name, this.idUser, this.idGereja, this.idPerkawinan);
  @override
  Future<List> callDb() async {
    Messages msg = new Messages();
    msg.addReceiver("agenPencarian");
    msg.setContent([
      ["cari Perkawinan Detail"],
      [idPerkawinan]
    ]);
    List k = [];
    await msg.send().then((res) async {
      print("masuk");
    });
    await Future.delayed(Duration(seconds: 1));
    k = await AgenPage().receiverTampilan();

    return k;
  }

  void updateAccept(token, idTarget) async {
    Messages msg = new Messages();
    msg.addReceiver("agenPendaftaran");
    msg.setContent([
      ["update Perkawinan"],
      [idPerkawinan],
      [token],
      [idTarget],
      [1]
    ]);
    var hasil;
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    hasil = await AgenPage().receiverTampilan();

    if (hasil == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Menerima Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Menerima Pelayanan Perkawinan",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void updateReject(token, idTarget) async {
    Messages msg = new Messages();
    msg.addReceiver("agenPendaftaran");
    msg.setContent([
      ["update Perkawinan"],
      [idPerkawinan],
      [token],
      [idTarget],
      [-1]
    ]);
    var hasil;
    await msg.send().then((res) async {
      print("masuk");
      print(await AgenPage().receiverTampilan());
    });
    await Future.delayed(Duration(seconds: 1));
    hasil = await AgenPage().receiverTampilan();

    if (hasil == "fail") {
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
                    builder: (context) => Profile(name, idUser, idGereja)),
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
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10, left: 10, top: 10),
              ),
              FutureBuilder<List>(
                  future: callDb(),
                  builder: (context, AsyncSnapshot snapshot) {
                    try {
                      // print(snapshot.data[0][0][0]);
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
                              Text(snapshot.data[1][0][0]["name"])
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
                              Text(snapshot.data[0][0][0]["namaPria"] +
                                  " & " +
                                  snapshot.data[0][0][0]["namaPerempuan"])
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
                              Text(snapshot.data[0][0][0]["notelp"])
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
                              Text(snapshot.data[0][0][0]["email"])
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
                              Text(snapshot.data[0][0][0]["alamat"])
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
                              Text(snapshot.data[0][0][0]["tanggal"].toString())
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
                              Text(snapshot.data[0][0][0]["note"])
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
                              if (snapshot.data[0][0][0]["status"] == 0)
                                Text("Menunggu"),
                              if (snapshot.data[0][0][0]["status"] == 1)
                                Text("Diterima"),
                              if (snapshot.data[0][0][0]["status"] == -1)
                                Text("Ditolak")
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 11),
                          ),
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
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text('Confirm Accept'),
                                            content: const Text(
                                                'Yakin ingin melakukan pelayanan perkawinan ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Tidak'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateAccept(
                                                      snapshot.data[1][0][0]
                                                          ['token'],
                                                      snapshot.data[1][0][0]
                                                          ['_id']);
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
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20)),
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
                                            title: const Text('Confirm Reject'),
                                            content: const Text(
                                                'Yakin ingin menolak pelayanan perkawinan ini?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'Cancel'),
                                                child: const Text('Tidak'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  updateReject(
                                                      snapshot.data[1][0][0]
                                                          ['token'],
                                                      snapshot.data[1][0][0]
                                                          ['_id']);
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
                        builder: (context) => History(name, idUser, idGereja)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(name, idUser, idGereja)),
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
