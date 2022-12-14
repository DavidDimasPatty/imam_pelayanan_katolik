import 'messages.dart';

class AgenPencarian {
  AgenPencarian() {
    ResponsBehaviour();
    ReadyBehaviour();
  }

  void ResponsBehaviour() async {
    Messages msg = Messages();

    var data = msg.receive();

    action() async {
      try {
        if (data[0] == "Cari baptis") {
          // var userBaptisCollection = db.collection(BAPTIS_COLLECTION);
          // var conn = await userBaptisCollection
          //     .find({'idGereja': data[0], 'status': 0}).toList();
          // msg.addReceiver("agenPage");
          // msg.setContent("done" + conn);
        }
      } catch (e) {
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
        if (data == "ready") {
          print("Agen Pencarian Ready");
        }
      } catch (e) {
        return 0;
      }
    }

    action();
  }
}
