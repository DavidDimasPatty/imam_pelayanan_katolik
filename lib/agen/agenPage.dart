import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/login.dart';

class AgenPage {
  String Messages = "";
  var Data;

  AgenPage(message, data) {
    this.Messages = message;
    this.Data = data;
    if (message == "ready") {
      ReadyBehaviour();
    }
    if (message == "Done") {
      ResponsBehaviour();
    } else {
      SendBehaviour();
    }
  }

  void SendBehaviour() {
    void action() {
      if (this.Messages == "Cari Baptis") {
        AgenPencarian(this.Messages, this.Data);
      }
    }

    action();
  }

  void ResponsBehaviour() {
    void action() async {
      if (this.Messages == "Done") {
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
