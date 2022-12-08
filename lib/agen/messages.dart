import 'agenPage.dart';
import 'agenPencarian.dart';

class Messages {
  String Agen = "";
  static var Data;

  void addReceiver(agen) {
    this.Agen = agen;
  }

  void setContent(data) {
    Data = data;
  }

  void send() {
    if (this.Agen == "agenPencarian") {
      AgenPencarian();
    }
    if (this.Agen == "agenPage") {
      AgenPage();
    }
  }

  receive() {
    return Data;
  }
}
