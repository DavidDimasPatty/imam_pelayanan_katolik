import 'package:imam_pelayanan_katolik/agen/Message.dart';
import 'package:imam_pelayanan_katolik/agen/agenAkun.dart';
import 'package:imam_pelayanan_katolik/agen/agenPage.dart';
import 'package:imam_pelayanan_katolik/agen/agenPendaftaran.dart';
import 'package:imam_pelayanan_katolik/agen/agenSetting.dart';

import 'Agent.dart';
import 'AgenPencarian.dart';

class MessagePassing {
  Map<String, Agent> agents = {
    'Agent Pencarian': AgentPencarian(),
    'Agent Pendaftaran': AgentPendaftaran(),
    'Agent Setting': AgentSetting(),
    'Agent Akun': AgentAkun(),
    'Agent Page': AgentPage()
  };

  Future<dynamic> sendMessage(Message message) async {
    if (agents.containsKey(message.receiver)) {
      Agent? agent = agents[message.receiver];
      if (agent!.canPerformTask(message)) {
        return await agent.receiveMessage(message, message.sender);
      } else {
        agent.rejectTask(message, message.sender);
      }
      return null;
    }
  }
}
