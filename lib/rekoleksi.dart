import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/addRekoleksi.dart';
import 'package:imam_pelayanan_katolik/baptisUser.dart';
import 'package:imam_pelayanan_katolik/history.dart';
import 'package:imam_pelayanan_katolik/profile.dart';
import 'package:imam_pelayanan_katolik/rekoleksiUser.dart';
import 'package:imam_pelayanan_katolik/sakramentalidetail.dart';
import 'DatabaseFolder/mongodb.dart';
import 'homePage.dart';

class Rekoleksi extends StatefulWidget {
  var names;
  final idUser;
  final idGereja;
  Rekoleksi(this.names, this.idUser, this.idGereja);
  @override
  _Rekoleksi createState() =>
      _Rekoleksi(this.names, this.idUser, this.idGereja);
}

class _Rekoleksi extends State<Rekoleksi> {
  var names;
  var emails;
  var distance;
  List daftarUser = [];

  List dummyTemp = [];
  final idUser;
  final idGereja;
  _Rekoleksi(this.names, this.idUser, this.idGereja);

  Future<List> callDb() async {
    return await MongoDatabase.RekoleksiTerdaftar(idGereja);
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
        if (item['namaKegiatan']
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

  void updateKegiatan(idKegiatan) async {
    var hasil = await MongoDatabase.updateStatusKegiatan(idKegiatan);

    if (hasil == "fail") {
      Fluttertoast.showToast(
          msg: "Gagal Deactive Kegiatan Rekoleksi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Berhasil Deactive Kegiatan Rekoleksi",
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
        });
      });
    }
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
                    builder: (context) => Profile(names, idUser, idGereja)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Settings(names, emails, idUser)),
              // );
            },
          ),
        ],
      ),
      body: ListView(children: [
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Kegiatan',
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
                                  addRekoleksi(names, idUser, idGereja)),
                        );
                      },
                      splashColor: Colors.blue,
                      splashRadius: 30,
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
                Text("Add Rekoleksi")
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),

            /////////
            for (var i in daftarUser)
              InkWell(
                borderRadius: new BorderRadius.circular(24),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RekoleksiUser(names, idUser, idGereja, i['_id'])),
                  );
                },
                child: Container(
                    margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(children: <Widget>[
                      //Color(Colors.blue);

                      Text(
                        i['namaKegiatan'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Kapasitas: ' + i['kapasitas'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        'Tanggal: ' + i['tanggal'].toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.lightBlue,
                            child: Text("Deactive Kegiatan"),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirm Deactive'),
                                  content: const Text(
                                      'Yakin ingin mendeactive kegiatan ini?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        updateKegiatan(i["_id"]);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ya'),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      // Text(
                      //   'Tanggal: ' + i['tanggal'].toString(),
                      //   style: TextStyle(color: Colors.white, fontSize: 12),
                      // ),
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

            /////////
          ],
        ),
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
