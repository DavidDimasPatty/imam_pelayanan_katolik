import 'package:imam_pelayanan_katolik/DatabaseFolder/data.dart';
import 'package:imam_pelayanan_katolik/DatabaseFolder/mongodb.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AgenPencarian {
  var Data;

  AgenPencarian(data) {
    this.Data = data;
    if (Data == "ready") {
      ReadyBehaviour();
    } else {
      ResponsBehaviour();
    }
  }

  void ResponsBehaviour() async {
    var db = await MongoDatabase.connect();

    void action() async {
      if (this.Data == "Cari baptis") {
        var userBaptisCollection = db.collection(BAPTIS_COLLECTION);
        var conn = await userBaptisCollection
            .find({'idGereja': this.Data[0], 'status': 0}).toList();
        AgenPage(conn);
      } else {
        AgenPage(null);
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
