import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/login.dart';

import 'messages.dart';

class AgenPage {
  static var dataTampilan;
  AgenPage() {
    //measure
    ReadyBehaviour();
    //SendBehaviour();
    ResponsBehaviour();
  }

  // void SendBehaviour() {
  //   Messages msg = Messages();
  //   var data = msg.receive();
  //   print("ini22");
  //   action() async {
  //     try {
  //       if (data.runtimeType == List) {
  //         msg.addReceiver("agenPencarian");
  //         msg.setContent("cariBaptis" + data[0]);
  //       }
  //     } catch (error) {
  //       return 0;
  //     }
  //   }

  //   action();
  // }
  setDataTampilan(data) {
    dataTampilan = data;
  }

  receiverTampilan() {
    return dataTampilan;
  }

  ResponsBehaviour() async {
    Messages msg = Messages();
    var data = msg.receive();

    action() async {
      try {
        if (data.runtimeType == List<Map<String, Object?>>) {
          print("tes12345");
          setDataTampilan(data);
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }

  ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "Done") {
          return data;
        }

        if (data == "ready") {
          print("masuklo");
          print("masuksss");
          runApp(MaterialApp(
            title: 'Navigation Basics',
            home: Login(),
          ));
          print("Agen Page Ready");
          print("masuk2");
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }
}
