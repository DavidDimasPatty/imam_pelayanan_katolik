import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/history.dart';
import 'package:imam_pelayanan_katolik/komuni.dart';
import 'package:imam_pelayanan_katolik/sakramentalidetail.dart';
import 'DatabaseFolder/mongodb.dart';
import 'homePage.dart';

class KomuniUser extends StatefulWidget {
  var names;
  final idUser;
  final idGereja;
  final idKomuni;
  KomuniUser(this.names, this.idUser, this.idGereja, this.idKomuni);
  @override
  _KomuniUser createState() =>
      _KomuniUser(this.names, this.idUser, this.idGereja, this.idKomuni);
}

class _KomuniUser extends State<KomuniUser> {
  var names;
  var emails;
  var distance;
  List daftarUser = [];

  List dummyTemp = [];
  final idUser;
  final idGereja;
  final idKomuni;
  _KomuniUser(this.names, this.idUser, this.idGereja, this.idKomuni);

  Future<List> callDb() async {
    return await MongoDatabase.UserKomuniTerdaftar(idKomuni);
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
        if (item['userKomuni'][0]['name']
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

  void updateReject(id) async {
    var hasil = await MongoDatabase.rejectKomuni(id);
  }

  void updateAccept(id) async {
    var hasil = await MongoDatabase.acceptKomuni(id);
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    editingController.addListener(() async {
      await filterSearchResults(editingController.text);
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Komuni(names, idUser, idGereja)),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text('Komuni'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Profile(names, emails, idUser)),
              // );
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
                helpText: 'Cari Gereja',
                textController: editingController,
                onSuffixTap: () {
                  setState(() {
                    editingController.clear();
                  });
                },
              ),
            ),

            /////////
            for (var i in daftarUser)
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
                        "Nama :" + i['userKomuni'][0]['name'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      Text(
                        "Tanggal Daftar :" +
                            i['tanggalDaftar'].toString().substring(0, 10),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.left,
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                      if (i['status'] == "0")
                        Text(
                          'Status: Menunggu',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                onPressed: () async {
                                  updateAccept(i['_id']);
                                  callDb().then((result) {
                                    setState(() {
                                      daftarUser.clear();
                                      dummyTemp.clear();
                                      daftarUser.addAll(result);
                                      dummyTemp.addAll(result);
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10)),
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
                                    updateReject(i['_id']);
                                    callDb().then((result) {
                                      setState(() {
                                        daftarUser.clear();
                                        dummyTemp.clear();
                                        daftarUser.addAll(result);
                                        dummyTemp.addAll(result);
                                      });
                                    });
                                  }),
                            ),
                          ),
                        ],
                      ),
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
