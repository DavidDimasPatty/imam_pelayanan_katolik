import 'dart:async';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/pelayanan/daftarPelayanan.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/sakramen/baptis/baptis.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/view/history.dart';

class editPelayanan extends StatefulWidget {
  @override
  final role;
  final iduser;
  final idGereja;
  final idPelayanan;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  String jenisPelayanan;
  editPelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian, this.jenisSelectedPelayanan, this.idPelayanan);

  @override
  _editPelayanan createState() => _editPelayanan(
      this.iduser,
      this.idGereja,
      this.role,
      this.jenisPelayanan,
      this.jenisPencarian,
      this.jenisSelectedPelayanan,
      this.idPelayanan);
}

class _editPelayanan extends State<editPelayanan> {
  final role;
  final iduser;
  final idGereja;
  final idPelayanan;
  var imageChange = false;
  var fileImage;
  var fileChange;
  String jenisSelectedPelayanan;
  String jenisPencarian;
  String jenisPelayanan;
  String tanggalBuka = "";
  String tanggalTutup = "";
  TextEditingController kapasitas = new TextEditingController();
  String _selectedDate = '';
  TextEditingController namaKegiatan = new TextEditingController();
  TextEditingController temaKegiatan = new TextEditingController();
  TextEditingController deskripsiKegiatan = new TextEditingController();
  TextEditingController tamuKegiatan = new TextEditingController();
  TextEditingController lokasi = new TextEditingController();
  _editPelayanan(this.iduser, this.idGereja, this.role, this.jenisPelayanan,
      this.jenisPencarian, this.jenisSelectedPelayanan, this.idPelayanan);

  List jenis = ["Dewasa", "Anak"];
  String jenisSelected = "";
  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (jenisPelayanan == "Sakramen") {
      setState(() {
        if (args.value is PickerDateRange) {
          tanggalBuka =
              '${DateFormat('yyyy-MM-dd').format(args.value.startDate)}';
          tanggalTutup =
              '${DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate)}';
        }
      });
    }
    if (jenisPelayanan == "Umum") {
      _selectedDate = args.value.toString();
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

  var hasil = [];
  Future callDb() async {
    Completer<void> completer = Completer<void>();

    Message message;
    if (jenisPelayanan == "Sakramen") {
      message = Message(
          'Agent Page',
          'Agent Pencarian',
          "REQUEST",
          Tasks('cari data edit pelayanan',
              [idPelayanan, jenisSelectedPelayanan]));
    } else {
      message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
          Tasks('cari data edit pelayanan', [idPelayanan, jenisPelayanan]));
    }
    MessagePassing messagePassing =
        MessagePassing(); //Memanggil distributor pesan
    await messagePassing
        .sendMessage(message); //Mengirim pesan ke distributor pesan
    completer.complete(); //Batas pengerjaan yang memerlukan completer
    var hasil = await await AgentPage
        .getData(); //Memanggil data yang tersedia di agen Page

    await completer
        .future; //Proses penungguan sudah selesai ketika varibel hasil
    //memiliki nilai
    return await hasil;
  }

  Future pullRefresh() async {
    //Fungsi refresh halaman akan memanggil fungsi callDb
    setState(() {
      // callDb();
    });
  }

  Future submit(tanggalbuka, tanggaltutup) async {
    if (jenisPelayanan == "Sakramen") {
      if (tanggalBuka == "") {
        tanggalBuka = tanggalbuka;
      }
      if (tanggalTutup == "") {
        tanggalTutup = tanggaltutup;
      }
      if (kapasitas != "" &&
          tanggalBuka != "" &&
          tanggalTutup != "" &&
          jenisSelected != "") {
        Completer<void> completer = Completer<void>();
        Message message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('edit pelayanan', [
              jenisSelectedPelayanan,
              idPelayanan,
              kapasitas.text,
              tanggalBuka.toString(),
              tanggalTutup.toString(),
              iduser,
              jenisSelected
            ]));

        MessagePassing messagePassing =
            MessagePassing(); //Memanggil distributor pesan
        await messagePassing
            .sendMessage(message); //Mengirim pesan ke distributor pesan
        completer.complete(); //Batas pengerjaan yang memerlukan completer
        var hasil = await await AgentPage
            .getData(); //Memanggil data yang tersedia di agen Page

        if (hasil == "oke") {
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
              msg: "Berhasil memperbarui " + jenisSelectedPelayanan,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (context) => daftarPelayanan(iduser, idGereja, role,
                    jenisPelayanan, jenisPencarian, jenisSelectedPelayanan)),
          );
        } else {
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
              msg: "Gagal Edit " + jenisSelectedPelayanan,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            /////// Widget toast untuk menampilkan pesan pada halaman
            msg: "Isi semua bidang",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (jenisPelayanan == "Umum") {
      if (_selectedDate == "") {
        _selectedDate = tanggalbuka;
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
                idPelayanan,
                namaKegiatan.text,
                temaKegiatan.text,
                jenisSelectedPelayanan,
                deskripsiKegiatan.text,
                tamuKegiatan.text,
                _selectedDate.toString(),
                kapasitas.text,
                lokasi.text,
                iduser,
                fileImage,
                imageChange
              ]));

          MessagePassing messagePassing =
              MessagePassing(); //Memanggil distributor pesan
          await messagePassing
              .sendMessage(message); //Mengirim pesan ke distributor pesan
          completer.complete(); //Batas pengerjaan yang memerlukan completer
          var hasil = await await AgentPage
              .getData(); //Memanggil data yang tersedia di agen Page

          if (hasil == "oke") {
            Fluttertoast.showToast(
                /////// Widget toast untuk menampilkan pesan pada halaman
                msg: "Berhasil memperbarui Rekoleksi",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);

            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => daftarPelayanan(iduser, idGereja, role,
                      jenisPelayanan, jenisPencarian, jenisSelectedPelayanan)),
            );
          } else {
            Fluttertoast.showToast(
                /////// Widget toast untuk menampilkan pesan pada halaman
                msg: "Gagal Edit Rekoleksi",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
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
                idPelayanan,
                namaKegiatan.text,
                temaKegiatan.text,
                jenisSelectedPelayanan,
                deskripsiKegiatan.text,
                tamuKegiatan.text,
                _selectedDate.toString(),
                kapasitas.text,
                lokasi.text,
                iduser,
                fileChange,
                imageChange
              ]));

          MessagePassing messagePassing =
              MessagePassing(); //Memanggil distributor pesan
          await messagePassing
              .sendMessage(message); //Mengirim pesan ke distributor pesan
          completer.complete(); //Batas pengerjaan yang memerlukan completer
          var hasil = await await AgentPage
              .getData(); //Memanggil data yang tersedia di agen Page

          if (hasil == "oke") {
            Fluttertoast.showToast(
                /////// Widget toast untuk menampilkan pesan pada halaman
                msg: "Berhasil memperbarui " + jenisSelectedPelayanan,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(
              context,
              MaterialPageRoute(
                  builder: (context) => daftarPelayanan(iduser, idGereja, role,
                      jenisPelayanan, jenisPencarian, jenisSelectedPelayanan)),
            );
          } else {
            Fluttertoast.showToast(
                /////// Widget toast untuk menampilkan pesan pada halaman
                msg: "Gagal Edit " + jenisSelectedPelayanan,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              /////// Widget toast untuk menampilkan pesan pada halaman
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // Widget untuk membangun struktur halaman
      //////////////////////////////////////Pembuatan Top Navigation Bar////////////////////////////////////////////////////////////////

      appBar: AppBar(
        // widget Top Navigation Bar
        automaticallyImplyLeading: true,
        title: Text("Edit Kegiatan " + jenisSelectedPelayanan),
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
      //////////////////////////////////////Pembuatan Body Halaman////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
        //Widget untuk refresh body halaman
        onRefresh: pullRefresh,
        child: ListView(
          children: [
            FutureBuilder(
                future: callDb(),
                builder: (context, AsyncSnapshot snapshot) {
                  try {
                    if (jenisPelayanan == "Sakramen") {
                      kapasitas.text = snapshot.data[0]['kapasitas'].toString();
                      jenisSelected = snapshot.data[0]['jenis'];
                    }
                    if (jenisPelayanan == "Umum") {
                      kapasitas.text = snapshot.data[0]['kapasitas'].toString();
                      namaKegiatan.text = snapshot.data[0]['namaKegiatan'];
                      temaKegiatan.text = snapshot.data[0]['temaKegiatan'];
                      deskripsiKegiatan.text =
                          snapshot.data[0]['deskripsiKegiatan'];
                      tamuKegiatan.text = snapshot.data[0]['tamu'];
                      lokasi.text = snapshot.data[0]['lokasi'];
                      fileImage = snapshot.data[0]['picture'];
                    }
                    return Column(children: [
                      if (jenisPelayanan == "Umum")
                        Column(
                          children: [
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
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  monthViewSettings:
                                      DateRangePickerMonthViewSettings(
                                          firstDayOfWeek: 1),
                                  initialSelectedDate: snapshot.data[0]
                                      ['tanggal'],
                                )
                              ],
                            ),
                            Text(
                              "Gambar " + jenisSelectedPelayanan,
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
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () async {
                                    submit(
                                        snapshot.data[0]['tanggal'].toString(),
                                        null);
                                  }),
                            ),
                          ],
                        ),
                      if (jenisPelayanan == "Sakramen")
                        Column(children: [
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
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              Text(
                                "Jenis",
                                textAlign: TextAlign.left,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                              ),
                              DropdownSearch<dynamic>(
                                // popupProps: PopupProps.menu(
                                //   showSelectedItems: true,
                                //   disabledItemFn: (String s) => s.startsWith('I'),
                                // ),
                                items: jenis,
                                selectedItem: jenisSelected,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "Pilih Jenis",
                                    hintText: "Pilih Jenis",
                                  ),
                                ),
                                onChanged: (dynamic? data) {
                                  jenisSelected = data;
                                },
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
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                monthViewSettings:
                                    DateRangePickerMonthViewSettings(
                                        firstDayOfWeek: 1),
                                initialSelectedRange: PickerDateRange(
                                    snapshot.data[0]['jadwalBuka'],
                                    snapshot.data[0]['jadwalTutup']),
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
                                  submit(
                                      snapshot.data[0]['jadwalBuka'].toString(),
                                      snapshot.data[0]['jadwalTutup']
                                          .toString());
                                }),
                          ),
                        ])
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
