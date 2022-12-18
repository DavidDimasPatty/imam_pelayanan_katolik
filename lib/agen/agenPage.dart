import 'package:flutter/material.dart';
import 'package:imam_pelayanan_katolik/login.dart';

import 'messages.dart';

class AgenPage {
  AgenPage() {
    //measure
    ReadyBehaviour();
    SendBehaviour();
    ResponsBehaviour();
  }

  void SendBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();

    action() {
      try {
        if (data.runtimeType == List) {
          msg.addReceiver("agenPencarian");
          msg.setContent("cariBaptis" + data[0]);
          print("masuk1");
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }

  void ResponsBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() async {
      try {
        if (data == "Done") {
          return data;
        }
      } catch (error) {
        return 0;
      }
    }

    action();
  }

  void ReadyBehaviour() {
    Messages msg = Messages();
    var data = msg.receive();
    action() {
      try {
        if (data == "Done") {
          return data;
        }

        if (data == "ready") {
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
