import 'package:imam_pelayanan_katolik/agen/agenAkun.dart';
import 'package:imam_pelayanan_katolik/agen/agenPendaftaran.dart';
import 'package:imam_pelayanan_katolik/agen/agenSetting.dart';

import 'agenPage.dart';
import 'agenPencarian.dart';

class Messages {
  String Agen = "";
  static var Data;

  addReceiver(agen) async {
    this.Agen = agen;
  }

  setContent(data) async {
    Data = data;
  }

  send() async {
    if (this.Agen == "agenPencarian") {
      await AgenPencarian();
    }
    if (this.Agen == "agenPage") {
      await AgenPage();
    }
    if (this.Agen == "agenSetting") {
      await AgenSetting();
    }
    if (this.Agen == "agenAkun") {
      await AgenAkun();
    }
    if (this.Agen == "agenPendaftaran") {
      await AgenPendaftaran();
    }
  }

  receive() {
    return Data;
  }
}
