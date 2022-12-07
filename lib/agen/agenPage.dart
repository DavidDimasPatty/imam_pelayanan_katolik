import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/login.dart';

class AgenPage {
  var Data;

  AgenPage(data) {
    this.Data = data;
    if (data == "ready") {
      ReadyBehaviour();
    }
    if (data == "Done") {
      ResponsBehaviour();
    } else {
      SendBehaviour();
    }
  }

  void SendBehaviour() {
    void action() {
      if (this.Data == "Cari Baptis") {
        AgenPencarian(this.Data);
      }
    }

    action();
  }

  void ResponsBehaviour() {
    void action() async {
      if (this.Data == "Done") {
        return this.Data;
      }
    }

    action();
  }

  void ReadyBehaviour() {
    void action() {
      print("Agen Page Ready");

      runApp(MaterialApp(
        title: 'Navigation Basics',
        home: Login(),
      ));
    }

    action();
  }
}
