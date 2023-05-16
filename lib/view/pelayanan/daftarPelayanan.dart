import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/addPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/editPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/pelayananDetail.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/pelayananUser.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/addBaptis.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/baptisUser.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/editBaptis.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';

class daftarPelayanan extends StatefulWidget {
  var role;
  final iduser;
  final idGereja;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  String jenisPelayanan;
  daftarPelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian, this.jenisSelectedPelayanan);
  @override
  _daftarPelayanan createState() => _daftarPelayanan(
      this.iduser,
      this.idGereja,
      this.role,
      this.jenisPelayanan,
      this.jenisPencarian,
      this.jenisSelectedPelayanan);
}

class _daftarPelayanan extends State<daftarPelayanan> {
  var role;
  var emails;
  List hasil = [];
  StreamController _controller = StreamController();
  ScrollController _scrollController = ScrollController();
  String jenisSelectedPelayanan;
  String jenisPencarian;
  String jenisPelayanan;
  int data = 5;
  List dummyTemp = [];
  final iduser;
  final idGereja;
  TextEditingController searchController = TextEditingController();
  _daftarPelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian, this.jenisSelectedPelayanan);

  Future callDb() async {
    Message message;
    Completer<void> completer = Completer<void>();
    if (jenisPelayanan == "Sakramen" &&
        jenisSelectedPelayanan != "Perkawinan") {
      message = Message(
          'Agent Page',
          'Agent Pencarian',
          "REQUEST",
          Tasks('cari pelayanan',
              [idGereja, jenisSelectedPelayanan, jenisPencarian]));
    } else if (jenisPelayanan == "Sakramen" &&
        jenisSelectedPelayanan == "Perkawinan") {
      message = Message(
          'Agent Page',
          'Agent Pencarian',
          "REQUEST",
          Tasks('cari pelayanan',
              [iduser, jenisSelectedPelayanan, jenisPencarian]));
    } else if (jenisPelayanan == "Sakramentali") {
      message = Message(
          'Agent Page',
          'Agent Pencarian',
          "REQUEST",
          Tasks('cari pelayanan',
              [iduser, jenisSelectedPelayanan, jenisPencarian]));
    } else {
      message = Message(
          'Agent Page',
          'Agent Pencarian',
          "REQUEST",
          Tasks('cari pelayanan', [
            idGereja,
            jenisPelayanan,
            jenisPencarian,
            jenisSelectedPelayanan
          ]));
    }
    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    var data = await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    var hasilPencarian =
        await AgentPage.getData(); //Memanggil data yang tersedia di agen Page

    completer.complete(); //Batas pengerjaan yang memerlukan completer

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasilPencarian;
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

  Future updateKegiatan(id, status) async {
    Completer<void> completer = Completer<void>();
    String jenis;
    if (jenisPelayanan == "Umum") {
      jenis = jenisPelayanan;
    } else {
      jenis = jenisSelectedPelayanan;
    }
    Message message = Message('Agent Page', 'Agent Pendaftaran', "REQUEST",
        Tasks('update status pelayanan', [jenis, id, status, iduser]));

    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasilDaftar = await await AgentPage
        .getData(); //Memanggil data yang tersedia di agen Page

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    if (hasilDaftar == "oke") {
      Fluttertoast.showToast(
          /////// Widget toast untuk menampilkan pesan pada halaman
          msg: "Berhasil Deactive Kegiatan " + jenisSelectedPelayanan,
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
          msg: "Gagal Deactive Kegiatan " + jenisSelectedPelayanan,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
        if (jenisPelayanan == "Sakramen" &&
            jenisSelectedPelayanan != "Perkawinan") {
          if (item['jadwalBuka']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            listOMaps.add(item);
          }
        }
        if (jenisPelayanan == "Umum") {
          if (item['namaKegiatan']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            listOMaps.add(item);
          }
        }
        if (jenisPelayanan == "Sakramen" &&
            jenisSelectedPelayanan == "Perkawinan") {
          if (item['userDaftar'][0]['nama']
              .toLowerCase()
              .contains(query.toLowerCase())) {
            listOMaps.add(item);
          }
        }
        if (jenisPelayanan == "Sakramentali") {
          if (item['namaLengkap'].toLowerCase().contains(query.toLowerCase())) {
            listOMaps.add(item);
          }
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

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() async {
      await filterSearchResults(searchController.text);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
                helpText: 'Cari ' + jenisSelectedPelayanan,
                textController: searchController,
                onSuffixTap: () {
                  setState(() {
                    searchController.clear();
                  });
                },
              ),
            ),
            if (jenisSelectedPelayanan != "Perkawinan" &&
                jenisSelectedPelayanan != "Pemberkatan")
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
                                builder: (context) => addPelayanan(
                                    iduser,
                                    idGereja,
                                    role,
                                    jenisPelayanan,
                                    jenisPencarian,
                                    jenisSelectedPelayanan)),
                          );
                        },
                        splashColor: Colors.blue,
                        splashRadius: 30,
                        icon: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Text("Add " + jenisSelectedPelayanan)
                ],
              ),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
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
                          onTap: () {
                            if (jenisSelectedPelayanan == "Perkawinan" ||
                                jenisSelectedPelayanan == "Pemberkatan") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pelayananDetail(
                                        iduser,
                                        idGereja,
                                        role,
                                        jenisPelayanan,
                                        jenisPencarian,
                                        jenisSelectedPelayanan,
                                        i['_id'])),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pelayananUser(
                                        iduser,
                                        idGereja,
                                        role,
                                        jenisPelayanan,
                                        jenisPencarian,
                                        jenisSelectedPelayanan,
                                        i['_id'])),
                              );
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(children: <Widget>[
                                //Color(Colors.blue);
                                if (jenisSelectedPelayanan == "Baptis" ||
                                    jenisSelectedPelayanan == "Krisma" ||
                                    jenisSelectedPelayanan == "Komuni")
                                  Column(
                                    children: [
                                      Text(
                                        jenisSelectedPelayanan +
                                            " " +
                                            i['jadwalBuka']
                                                .toString()
                                                .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Kapasitas: ' +
                                            i['kapasitas'].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        'Jenis: ' + i['jenis'].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        'Jadwal Tutup: ' +
                                            i['jadwalTutup'].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                if (jenisPelayanan == "Umum")
                                  Column(
                                    children: [
                                      Text(
                                        i['namaKegiatan'].toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Kapasitas: ' +
                                            i['kapasitas'].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                      Text(
                                        'Tanggal: ' + i['tanggal'].toString(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                if (jenisSelectedPelayanan == "Perkawinan")
                                  Column(children: [
                                    Text(
                                      i['userDaftar'][0]['nama'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26.0,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      'Alamat: ' + i['alamat'],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      'Tanggal: ' +
                                          i['tanggal']
                                              .toString()
                                              .substring(0, 10),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      'Jam: ' +
                                          i['tanggal']
                                              .toString()
                                              .substring(10, 16),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    if (i["status"] == 1)
                                      Text("Diterima",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    if (i["status"] == 2)
                                      Text("Selesai",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    if (i["status"] == -1)
                                      Text("Ditolak",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15))
                                  ]),
                                if (jenisSelectedPelayanan == "Pemberkatan")
                                  Column(
                                    children: [
                                      Text(
                                        i['namaLengkap'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26.0,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'Jenis Pemberkatan: ' + i['jenis'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      Text(
                                        'Alamat: ' + i['alamat'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      Text(
                                        'Tanggal: ' +
                                            i['tanggal']
                                                .toString()
                                                .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      Text(
                                        'Jam: ' +
                                            i['tanggal']
                                                .toString()
                                                .substring(10, 16),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                      if (i["status"] == 0)
                                        Text("Menunggu Konfirmasi"),
                                      if (i["status"] == 1)
                                        Text("Diterima",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15)),
                                      if (i["status"] == 2)
                                        Text("Selesai",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15)),
                                      if (i["status"] == -1)
                                        Text("Ditolak",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15))
                                    ],
                                  ),
                                if (jenisSelectedPelayanan != "Perkawinan" &&
                                    jenisSelectedPelayanan != "Pemberkatan")
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.lightBlue,
                                        child: Text(
                                            "Edit " + jenisSelectedPelayanan),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    editPelayanan(
                                                        iduser,
                                                        idGereja,
                                                        role,
                                                        jenisPelayanan,
                                                        jenisPencarian,
                                                        jenisSelectedPelayanan,
                                                        i['_id'])),
                                          );
                                        }),
                                  ),
                                if (jenisSelectedPelayanan != "Perkawinan" &&
                                    jenisSelectedPelayanan != "Pemberkatan")
                                  SizedBox(
                                    width: double.infinity,
                                    child: RaisedButton(
                                        textColor: Colors.white,
                                        color: Colors.lightBlue,
                                        child: Text("Deactive " +
                                            jenisSelectedPelayanan),
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
                                                  'Confirm Deactive'),
                                              content: Text(
                                                  'Yakin ingin mendeactive ' +
                                                      jenisSelectedPelayanan +
                                                      ' ini?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Tidak'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    updateKegiatan(i["_id"], 1);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Ya'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                              ])),
                        )
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
