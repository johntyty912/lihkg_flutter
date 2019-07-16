library lihkg_flutter.globals;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:lihkg_api/lihkg_api.dart';

Map<String, PushMachine> pushMachines = {};

class PushMachine {
  final String threadID;
  final LihkgClient client;
  final TextEditingController textEditingController = TextEditingController();

  String content;
  Timer timer;
  bool run = false;
  Duration duration;

  PushMachine({this.threadID, this.content, this.client}) {
    setDuration(1);
  }

  setDuration(int min) {
    duration = Duration(minutes: min);
    timer = Timer.periodic(duration, (timer) async {
      if (run) {
        final response = await client.postReply(threadID, content);
        print("[$threadID] content: ${content}");
      }
    });
  }
}
