import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
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
import 'package:imam_pelayanan_katolik/view/umum/retret/retret.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import 'package:imam_pelayanan_katolik/view/history.dart';
import '../../profile/profile.dart';
import '../../setting/setting.dart';

class editRetret extends StatefulWidget {
  @override
  final role;
  final iduser;
  final idGereja;
  final idRetret;
  editRetret(this.iduser, this.idGereja, this.role, this.idRetret);

  @override
  _editRetret createState() =>
      _editRetret(this.iduser, this.idGereja, this.role, this.idRetret);
}

class _editRetret extends State<editRetret> {
  final role;
  final iduser;
  final idGereja;
  final idRetret;
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
  _editRetret(this.iduser, this.idGereja, this.role, this.idRetret);
  var imageChange = false;
  var fileImage;
  var fileChange;
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

  void submit(tanggal) async {
    if (_selectedDate == "") {
      _selectedDate = tanggal;
    }
    if (imageChange == false) {
      if (namaKegiatan.text != "" &&
          temaKegiatan.text != "" &&
          deskripsiKegiatan.text != "" &&
          tamuKegiatan.text != "" &&
          _selectedDate != "" &&
          kapasitas.text != "" &&
          lokasi.text != "" &&
          fileImage != null) {
        Completer<void> completer = Completer<void>();
        Message message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('edit pelayanan', [
              "umum",
              idRetret,
              namaKegiatan.text,
              temaKegiatan.text,
              "Retret",
              deskripsiKegiatan.text,
              tamuKegiatan.text,
              _selectedDate.toString(),
              kapasitas.text,
              lokasi.text,
              iduser,
              fileImage,
              imageChange
            ]));

        MessagePassing messagePassing = MessagePassing();
        await messagePassing.sendMessage(message);
        completer.complete();
        var hasil = await await AgentPage.getDataPencarian();

        if (hasil == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal Edit Retret",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil Edit Retret",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => Retret(iduser, idGereja, role)),
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
    } else {
      if (namaKegiatan.text != "" &&
          temaKegiatan.text != "" &&
          deskripsiKegiatan.text != "" &&
          tamuKegiatan.text != "" &&
          _selectedDate != "" &&
          kapasitas.text != "" &&
          lokasi.text != "" &&
          fileImage != null) {
        Completer<void> completer = Completer<void>();
        Message message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('edit pelayanan', [
              "umum",
              idRetret,
              namaKegiatan.text,
              temaKegiatan.text,
              "Retret",
              deskripsiKegiatan.text,
              tamuKegiatan.text,
              _selectedDate.toString(),
              kapasitas.text,
              lokasi.text,
              iduser,
              fileChange,
              imageChange
            ]));

        MessagePassing messagePassing = MessagePassing();
        await messagePassing.sendMessage(message);
        completer.complete();
        var hasil = await await AgentPage.getDataPencarian();

        if (hasil == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal Edit Retret",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil Edit Retret",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => Retret(iduser, idGereja, role)),
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
  }

  var hasil = [];
  Future callDb() async {
    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari data edit pelayanan', [idRetret, "umum"]));

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
        title: Text("Edit Kegiatan Retret"),
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
                    fileImage = snapshot.data[0]['picture'];

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
                      Text(
                        "Gambar Retret",
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
