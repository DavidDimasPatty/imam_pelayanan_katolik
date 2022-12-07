import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/agen/agenPencarian.dart';
import 'package:imam_pelayanan_katolik/login.dart';

class Messages {
  String Agen = "";
  var Data;

  void receiver(agen) {
    this.Agen = agen;
  }

  void setContent(data) {
    this.Data = data;
  }

  void send() {
    if (this.Agen == "agenPencarian") {
      AgenPencarian(this.Data);
    }
  }
}
