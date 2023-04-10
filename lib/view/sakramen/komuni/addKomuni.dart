import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/komuni/komuni.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';
import '../../profile/profile.dart';
import '../../setting/setting.dart';

class addKomuni extends StatefulWidget {
  @override
  final role;
  final iduser;
  final idGereja;
  addKomuni(this.iduser, this.idGereja, this.role);

  @override
  _addKomuni createState() => _addKomuni(this.iduser, this.idGereja, this.role);
}

class _addKomuni extends State<addKomuni> {
  final role;
  final iduser;
  final idGereja;
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String tanggalBuka = "";
  String tanggalTutup = "";
  TextEditingController kapasitas = new TextEditingController();
  _addKomuni(this.iduser, this.idGereja, this.role);

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

  void submit(idGereja, kapasitas, tanggalbuka, tanggaltutup) async {
    if (kapasitas != "" && tanggalBuka != "" && tanggalTutup != "") {
      Completer<void> completer = Completer<void>();
      Message message = Message(
          'Agent Page',
          'Agent Pendaftaran',
          "REQUEST",
          Tasks('add pelayanan', [
            "komuni",
            idGereja,
            kapasitas,
            tanggalbuka.toString(),
            tanggaltutup.toString(),
            iduser
          ]));

      MessagePassing messagePassing = MessagePassing();
      var data = await messagePassing.sendMessage(message);
      completer.complete();
      var hasil = await await AgentPage.getDataPencarian();

      await completer.future;

      if (hasil == "fail") {
        Fluttertoast.showToast(
            msg: "Gagal Mendaftarkan Komuni",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Berhasil Mendaftarkan Komuni",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pop(
          context,
          MaterialPageRoute(
              builder: (context) => Komuni(iduser, idGereja, role)),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Tambah Kegiatan Komuni"),
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
      body: ListView(children: [
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
              controller: kapasitas,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
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
                  hintText: "Kapasitas Pendaftaran",
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
              "Tanggal Buka dan Tutup Pendaftaran",
              textAlign: TextAlign.left,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            SfDateRangePicker(
              view: DateRangePickerView.month,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              monthViewSettings:
                  DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
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
                submit(idGereja, kapasitas.text, tanggalBuka, tanggalTutup);
              }),
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
