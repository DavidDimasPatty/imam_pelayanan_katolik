import 'Task.dart';

class Message {
  String sender;
  String receiver;
  Tasks task;
  dynamic protocol;

  Message(this.sender, this.receiver, this.protocol, this.task);
}
