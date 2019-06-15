import 'package:flutter/material.dart';
import 'src/thread.dart';
import 'src/page.dart';
import 'dart:math';

class pageRoute extends StatefulWidget {

  final Item thread;
  pageRoute({Key key, @required this.thread}) : super(key: key);

  @override
  pageRouteState createState() => pageRouteState(thread);
}

class pageRouteState extends State<pageRoute> {

  Item thread;
  int _page = 1;
  bool orderByHot = false;
  Map<int, Item_data> items = new Map();

  pageRouteState(this.thread);

  @override
  void initState() {
    super.initState();
    _onCreate();
  }

  Future<void> _onCreate() async {
    Map<int, Item_data> _tempMap = items;

    final pageURL = "https://lihkg.com/api_v2/thread/${thread.thread_id}/page/${_page}";
    final Map<String,String> query = {
      "order": orderByHot ? "hot" : "reply_time",
    };

    final page = await getPage(pageURL, query);
    for (final item in page.response.item_data) {
      _tempMap[int.parse(item.msg_num)] = item;
    }
    setState(() {
      items = _tempMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
      ),
      body: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index+items.keys.reduce(min)].msg),
          );
        },
        separatorBuilder: (context, index) {
          return Text(items[index+items.keys.reduce(min)].msg_num);
        },
      ),
    );
  }
}