import 'dart:async';
import 'dart:io';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/MessagePassing.dart';
import 'package:imam_pelayanan_katolik/agen/Task.dart';
import 'package:imam_pelayanan_katolik/view/history/history.dart';
import 'package:imam_pelayanan_katolik/view/homePage.dart';
import 'package:imam_pelayanan_katolik/view/pengumuman/pengumumanGereja.dart';
import 'package:imam_pelayanan_katolik/view/profile/profile.dart';
import 'package:imam_pelayanan_katolik/view/setting/setting.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class editPengumuman extends StatefulWidget {
  @override
  final names;
  final idUser;
  final idGereja;
  final idPengumuman;

  editPengumuman(this.names, this.idUser, this.idGereja, this.idPengumuman);

  @override
  _editPengumuman createState() => _editPengumuman(
      this.names, this.idUser, this.idGereja, this.idPengumuman);
}

class _editPengumuman extends State<editPengumuman> {
  final names;
  final idUser;
  final idGereja;
  var imageChange = false;
  final idPengumuman;

  _editPengumuman(this.names, this.idUser, this.idGereja, this.idPengumuman);
  TextEditingController caption = new TextEditingController();
  TextEditingController title = new TextEditingController();

  var fileImage;
  var fileChange;

  Future callDb() async {
    // Messages msg = new Messages();
    // msg.addReceiver("agenPencarian");
    // msg.setContent([
    //   ["cari Pengumuman Edit"],
    //   [idPengumuman],
    // ]);
    // await msg.send().then((res) async {
    //   print("masuk");
    //   print(await AgenPage().receiverTampilan());
    // });
    // await Future.delayed(Duration(seconds: 1));
    // var hasil = AgenPage().receiverTampilan();

    Completer<void> completer = Completer<void>();
    Message message = Message('Agent Page', 'Agent Pencarian', "REQUEST",
        Tasks('cari pengumuman edit', [idPengumuman]));

    MessagePassing messagePassing = MessagePassing();
    var data = await messagePassing.sendMessage(message);
    completer.complete();
    var result = await await AgentPage.getDataPencarian();

    await completer.future;

    return result;
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

  Future pullRefresh() async {
    setState(() {
      callDb();
    });
  }

  void submit() async {
    if (imageChange == false) {
      if (fileImage != null && caption.text != "" && title.text != "") {
        //   Messages msg = new Messages();
        //   msg.addReceiver("agenPendaftaran");
        //   msg.setContent([
        //     ["edit Pengumuman"],
        //     [idPengumuman],
        //     [title.text],
        //     [caption.text],
        //     [fileImage],
        //     [imageChange]
        //   ]);
        //   var hasil;
        //   await msg.send().then((res) async {
        //     print("masuk");
        //     print(await AgenPage().receiverTampilan());
        //   });
        //   await Future.delayed(Duration(seconds: 1));
        //   hasil = await AgenPage().receiverTampilan();
        Completer<void> completer = Completer<void>();
        Message message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('edit pengumuman', [
              idPengumuman,
              title.text,
              caption.text,
              fileImage,
              imageChange
            ]));

        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        completer.complete();
        var hasil = await await AgentPage.getDataPencarian();

        await completer.future;

        if (hasil == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal Memperbarui Pengumuman",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil Memperbarui Pengumuman",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PengumumanGereja(names, idUser, idGereja)),
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
      if (fileImage != null && caption.text != "" && title.text != "") {
        // Messages msg = new Messages();
        // msg.addReceiver("agenPendaftaran");
        // msg.setContent([
        //   ["edit Pengumuman"],
        //   [idPengumuman],
        //   [title.text],
        //   [caption.text],
        //   [fileChange],
        //   [imageChange]
        // ]);
        // var hasil;
        // await msg.send().then((res) async {
        //   print("masuk");
        //   print(await AgenPage().receiverTampilan());
        // });
        // await Future.delayed(Duration(seconds: 1));
        // hasil = await AgenPage().receiverTampilan();
        print(fileImage.runtimeType);
        Completer<void> completer = Completer<void>();
        Message message = Message(
            'Agent Page',
            'Agent Pendaftaran',
            "REQUEST",
            Tasks('edit pengumuman', [
              idPengumuman,
              title.text,
              caption.text,
              fileChange,
              imageChange
            ]));

        MessagePassing messagePassing = MessagePassing();
        var data = await messagePassing.sendMessage(message);
        completer.complete();
        var hasil = await await AgentPage.getDataPencarian();

        await completer.future;

        if (hasil == "failed") {
          Fluttertoast.showToast(
              msg: "Gagal Memperbarui Pengumuman",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Berhasil Memperbarui Pengumuman",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PengumumanGereja(names, idUser, idGereja)),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Edit Pengumuman Gereja"),
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
        child: ListView(children: [
          FutureBuilder(
              future: callDb(),
              builder: (context, AsyncSnapshot snapshot) {
                //exception

                try {
                  title.text = snapshot.data[0]['title'];
                  caption.text = snapshot.data[0]['caption'];
                  fileImage = snapshot.data[0]['gambar'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Text(
                        "Title",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      TextField(
                        controller: title,
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
                            hintText: "Judul Pengumuman",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Text(
                        "Caption",
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                      ),
                      TextField(
                        controller: caption,
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
                            hintText: "Caption Pengumuman",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      Text(
                        "Gambar Pengumuman",
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
                        )
                    ],
                  );
                } catch (e) {
                  print(e);
                  return Center(child: CircularProgressIndicator());
                }
              }),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
                textColor: Colors.white,
                color: Colors.lightBlue,
                child: Text("Edit Pengumuman"),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () async {
                  submit();
                }),
          ),
        ]),
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
