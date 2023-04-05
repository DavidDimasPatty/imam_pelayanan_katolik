import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/umum/pendalamanAlkitab/pendalamanAlkitab.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../history/history.dart';
import '../../profile/profile.dart';
import '../../setting/setting.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';

class editPA extends StatefulWidget {
  @override
  final names;
  final idUser;
  final idGereja;
  final idPA;
  editPA(this.names, this.idUser, this.idGereja, this.idPA);

  @override
  _editPA createState() =>
      _editPA(this.names, this.idUser, this.idGereja, this.idPA);
}

class _editPA extends State<editPA> {
  final names;
  final idUser;
  final idGereja;
  final idPA;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String tanggalBuka = "";
  String tanggalTutup = "";
  TextEditingController kapasitas = new TextEditingController();
  TextEditingController namaKegiatan = new TextEditingController();
  TextEditingController temaKegiatan = new TextEditingController();
  TextEditingController deskripsiKegiatan = new TextEditingController();
  TextEditingController tamuKegiatan = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  _editPA(this.names, this.idUser, this.idGereja, this.idPA);

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      print(args.toString());
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('yyyy-MM-dd').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        tanggalBuka =
            '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
        tanggalTutup =
            '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void submit(tanggal) async {
    if (_selectedDate == "") {
      _selectedDate = tanggal;
    }
    if (namaKegiatan.text != "" &&
        temaKegiatan.text != "" &&
        deskripsiKegiatan.text != "" &&
        tamuKegiatan.text != "" &&
        _selectedDate != "" &&
        kapasitas.text != "" &&
        lokasi.text != "") {
      // Messages msg = new Messages();
      // msg.addReceiver("agenPendaftaran");
      // msg.setContent([
      //   ["edit Kegiatan"],
      //   [idPA],
      //   [namaKegiatan.text],
      //   [temaKegiatan.text],
      //   ["Pendalaman Alkitab"],
      //   [deskripsiKegiatan.text],
      //   [tamuKegiatan.text],
      //   [_selectedDate.toString()],
      //   [kapasitas.text],
      //   [lokasi.text],
      // ]);
      // var hasil;
      // await msg.send().then((res) async {
      //   print("masuk");
      //   print(await AgenPage().receiverTampilan());
      // });
      // await Future.delayed(Duration(seconds: 1));
      // hasil = await AgenPage().receiverTampilan();
      Completer<void> completer = Completer<void>();
      Message message = Message(
          'Agent Page',
          'Agent Pendaftaran',
          "REQUEST",
          Tasks('edit pelayanan', [
            "umum",
            idPA,
            namaKegiatan.text,
            temaKegiatan.text,
            "Pendalaman Alkitab",
            deskripsiKegiatan.text,
            tamuKegiatan.text,
            _selectedDate.toString(),
            kapasitas.text,
            lokasi.text,
            idUser
          ]));

      MessagePassing messagePassing = MessagePassing();
      await messagePassing.sendMessage(message);
      completer.complete();
      var hasil = await await AgentPage.getDataPencarian();

      if (hasil == "failed") {
        Fluttertoast.showToast(
            msg: "Gagal Edit Pendalaman Alkitab",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Berhasil Edit Pendalaman Alkitab",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => PA(names, idUser, idGereja)),
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Isi semua bidang",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  var hasil = [];
  Future callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari edit Kegiatan"],
    //   [idPA]
    // ]);
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // hasil = await AgenPage().receiverTampilan();

    // return hasil;
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari data edit pelayanan', [idPA, "umum"]));

    MessagePassing messagePassing = MessagePassing();
    await messagePassing.sendMessage(message);
    completer.complete();
    var hasil = await await AgentPage.getDataPencarian();

    await completer.future;
    return await hasil;
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
        title: Text("Edit Kegiatan Pendalaman Alkitab"),
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
                    builder: (context) => Profile(names, idUser, idGereja)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(names, idUser, idGereja)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresh,
        child: ListView(
          children: [
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    kapasitas.text = snapshot.data[0]['kapasitas'].toString();
                    namaKegiatan.text = snapshot.data[0]['namaKegiatan'];
                    temaKegiatan.text = snapshot.data[0]['temaKegiatan'];
                    deskripsiKegiatan.text =
                        snapshot.data[0]['deskripsiKegiatan'];
                    tamuKegiatan.text = snapshot.data[0]['tamu'];
                    lokasi.text = snapshot.data[0]['lokasi'];

                    return Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Nama Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: namaKegiatan,
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
                                hintText: "Nama Kegiatan",
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
                            "Tema Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: temaKegiatan,
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
                                hintText: "Tema Kegiatan",
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
                            "Deskripsi Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: deskripsiKegiatan,
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
                                hintText: "Deskripsi Kegiatan",
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
                            "Tamu Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: tamuKegiatan,
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
                                hintText: "Tamu Kegiatan",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                          Text(
                            "Kapasitas",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: kapasitas,
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
                                hintText: "Kapasitas Kegiatan",
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
                            "Lokasi Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          TextField(
                            controller: lokasi,
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
                                hintText: "Lokasi Kegiatan",
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
                          Text(
                            "Tanggal Kegiatan",
                            textAlign: TextAlign.left,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          SfDateRangePicker(
                            view: DateRangePickerView.month,
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.single,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1),
                            initialSelectedDate: snapshot.data[0]['tanggal'],
                          )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.lightBlue,
                            child: Text("Submit Kegiatan"),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {
                              submit(snapshot.data[0]['tanggal'].toString());
                            }),
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
    );
  }
}
