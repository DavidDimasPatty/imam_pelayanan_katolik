import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AgenPencarian {
  String Messages = "";
  var Data;

  AgenPencarian(message, data) {
    this.Messages = message;
    this.Data = data;
    if (message == "ready") {
      ReadyBehaviour();
    } else {
      ResponsBehaviour();
    }
  }

  void ResponsBehaviour() async {
    var db = await MongoDatabase.connect();

    void action() async {
      if (this.Messages == "Cari baptis") {
        var userBaptisCollection = db.collection(BAPTIS_COLLECTION);
        var conn = await userBaptisCollection
            .find({'idGereja': this.Data[0], 'status': 0}).toList();
        AgenPage("Done", conn);
      } else {
        AgenPage("Reject", null);
      }
    }

    action();
  }

  void ReadyBehaviour() {
    String action() {
      print("Agen Pencarian Ready");
      return "Ready";
    }

    action();
  }
}
