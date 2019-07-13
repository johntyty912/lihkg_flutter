library lihkg_flutter.globals;

import 'dart:async';

import 'package:lihkg_api/lihkg_api.dart';

Map<String, PushMachine> pushMachines = {};

class PushMachine {
  final String threadID;
  final String content;
  final LihkgClient client;

  Timer timer;
  bool run = false;


  PushMachine({this.threadID, this.content, this.client}) {
    timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (run) {
        final response = await client.postReply(threadID, content);
        print("[$threadID] content: ${content}");
      };
    });
  }
}