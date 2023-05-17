import 'dart:async';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';

class pelayananUser extends StatefulWidget {
  var role;
  final iduser;
  final idGereja;
  final idPelayanan;
  String jenisPelayanan;
  String jenisPencarian;
  String jenisSelectedPelayanan;
  pelayananUser(this.iduser, this.idGereja, this.role, this.jenisPelayanan, this.jenisPencarian, this.jenisSelectedPelayanan, this.idPelayanan);
  @override
  _pelayananUser createState() => _pelayananUser(this.iduser, this.idGereja, this.role, this.jenisPelayanan, this.jenisPencarian, this.jenisSelectedPelayanan, this.idPelayanan);
}

class _pelayananUser extends State<pelayananUser> {
  var role;
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  int data = 5;
  List dummyTemp = [];
  final iduser;
  final idGereja;
  final idPelayanan;
  String jenisPelayanan;
  String jenisPencarian;
  String jenisSelectedPelayanan;
  _pelayananUser(this.iduser, this.idGereja, this.role, this.jenisPelayanan, this.jenisPencarian, this.jenisSelectedPelayanan, this.idPelayanan);

  Future<List> callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST", Tasks('cari pelayanan user', [idPelayanan, jenisSelectedPelayanan, jenisPencarian]));

    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilPencarian = await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer.future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasilPencarian;
  }

  @override
  void initState() {
    super.initState();
    callDb().then((result) {
      setState(() {
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> listOMaps = <Map<String, dynamic>>[];
      for (var item in dummyTemp) {
        if (item['userPelayanan'][0]['nama'].toString().toLowerCase().contains(query.toLowerCase())) {
          listOMaps.add(item);
        }
      }
      setState(() {
        hasil.clear();
        hasil.addAll(listOMaps);
      });
    } else {
      setState(() {
        hasil.clear();
        hasil.addAll(dummyTemp);
      });
    }
  }

  Future updateUserStatus(int status, id, token, idTarget, bool notif) async {
    Completer<void> completer = Completer<void>();
    String umumSakramen = jenisSelectedPelayanan;
    if (jenisPelayanan == "Umum") {
      umumSakramen = jenisPelayanan;
    }
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST", Tasks('update pelayanan user', [umumSakramen, id, token, idTarget, status, iduser, notif]));
    MessagePassing messagePassing = MessagePassing(); //Memanggil distributor pesan
    await messagePassing.sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasilDaftar = await await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    String statusKonfirmasi = "Menerima";
    if (hasilDaftar == "oke") {
      if (status == -1) {
        statusKonfirmasi = "Menolak";
      }
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Berhasil " + statusKonfirmasi + " User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      callDb().then((result) {
        setState(() {
          hasil.clear();
          dummyTemp.clear();
          hasil.addAll(result);
          dummyTemp.addAll(result);
          _controller.add(result);
        });
      });
    } else {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Gagal " + statusKonfirmasi + " User",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    callDb().then((result) {
      setState(() {
        data = 5;
        hasil.clear();
        dummyTemp.clear();
        hasil.clear();
        hasil.addAll(result);
        dummyTemp.addAll(result);
        _controller.add(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() async {
      await filterSearchResults(searchController.text);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          data = data + 5;
        });
      }
    });
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(jenisSelectedPelayanan),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile(iduser, idGereja, role)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings(iduser, idGereja, role)),
              );
            },
          ),
        ],
      ),
      //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
        //Widget untuk refresh body halaman
        onRefresh: pullRefresh,
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 15, left: 15),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: AnimSearchBar(
                color: Colors.blue,
                autoFocus: false,
                width: 400,
                rtl: true,
                helpText: 'Cari Umat',
                textController: searchController,
                onSuffixTap: () {
                  setState(() {
                    searchController.clear();
                  });
                },
              ),
            ),

            /////////
            StreamBuilder(
                stream: _controller.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  try {
                    return Column(children: [
                      for (var i in hasil.take(data))
                        InkWell(
                          borderRadius: new BorderRadius.circular(24),
                          onTap: () {},
                          child: Container(
                              margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.topLeft, colors: [
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
                                  "Nama :" + i['userPelayanan'][0]['nama'].toString(),
                                  style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                Text(
                                  "Tanggal Daftar :" + i['tanggalDaftar'].toString().substring(0, 10),
                                  style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.left,
                                ),
                                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                                if (i['status'] == "0")
                                  Text(
                                    'Status: Menunggu',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                if (i['status'] == 1)
                                  Text(
                                    'Status: Accept',
                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                  ),
                                if (i['status'] == -1)
                                  Text(
                                    'Status: Reject',
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
                                            if (jenisPelayanan == "Sakramen") {
                                              updateUserStatus(1, i['_id'], i['userPelayanan'][0]['token'], i['id' + jenisSelectedPelayanan], i['userPelayanan'][0]['notifGD']);
                                            } else {
                                              updateUserStatus(1, i['_id'], i['userPelayanan'][0]['token'], i['id' + jenisPelayanan], i['userPelayanan'][0]['notifGD']);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: RaisedButton(
                                            textColor: Colors.white,
                                            color: Colors.lightBlue,
                                            child: Text("Reject"),
                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(30.0),
                                            ),
                                            onPressed: () async {
                                              if (jenisPelayanan == "Sakramen") {
                                                updateUserStatus(-1, i['_id'], i['userPelayanan'][0]['token'], i['id' + jenisSelectedPelayanan], i['userPelayanan'][0]['notifGD']);
                                              } else {
                                                updateUserStatus(-1, i['_id'], i['userPelayanan'][0]['token'], i['id' + jenisPelayanan], i['userPelayanan'][0]['notifGD']);
                                              }
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ])),
                        ),
                    ]);
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
            borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
                    MaterialPageRoute(builder: (context) => History(iduser, idGereja, role)),
                  );
                } else if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(iduser, idGereja, role)),
                  );
                }
              },
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
