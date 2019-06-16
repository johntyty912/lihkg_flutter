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
  int _minPage;
  int _maxPage;
  bool orderByHot = false;
  Map<int, Item_data> items = new Map();
  ScrollController _scrollController;

  pageRouteState(this.thread);

  @override
  void initState() {
    _minPage = _page;
    _maxPage = _page;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _onLoadPage();
  }

  _scrollListener() {
     if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _maxPage++;
      _page = _maxPage;
      _onLoadPage();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      _minPage--;
      _page = _minPage;
      _onLoadPage();
    }
  }

  Future<void> _onLoadPage() async {
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
        controller: _scrollController,
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