import 'package:flutter/material.dart';
import 'src/thread.dart';
import 'src/page.dart';
import 'src/login.dart';
import 'msgCard.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class pageRoute extends StatefulWidget {

  final Item thread;
  final Login login;
  pageRoute({Key key, @required this.thread, @required this.login}) : super(key: key);

  @override
  pageRouteState createState() => pageRouteState(thread, login);
}

class pageRouteState extends State<pageRoute> {

  Item thread;
  Login login;
  int _page = 1;
  int _minPage;
  int _maxPage;
  bool orderByHot = false;
  Map<int, Item_data> items = new Map();
  ScrollController _scrollController;

  pageRouteState(this.thread, this.login);

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

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
    Map<String, String> headers;

    final pageURL = "https://lihkg.com/api_v2/thread/${thread.thread_id}/page/${_page}";
    final Map<String,String> query = {
      "order": orderByHot ? "hot" : "reply_time",
    };
    final String uri = Uri.parse(pageURL).replace(queryParameters: query).toString();
    final String request_time = '${DateTime.now().millisecondsSinceEpoch}'.substring(0,10);
    if (login != null) {
      headers = {
        'X-LI-USER': login.response.user.user_id,
        'X-LI-REQUEST-TIME': '${request_time}',
        'X-LI-DIGEST': sha1.convert(utf8.encode('jeams\$get\$${uri}\$\$${login.response.token}\$${request_time}')).toString(),
      };
    }
    final page = await getPage(pageURL, query, headers);
    if (page.response == null) { return; }
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
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return msgCard(msg: items[index+items.keys.reduce(min)], login: login,);
        },
      ),
    );
  }
}
