import 'package:flutter/material.dart';
import 'package:lihkg_api/lihkg_api.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:lihkg_flutter/replyRoute.dart';
import 'msgCard.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class pageRoute extends StatefulWidget {
  final Item thread;
  final LihkgClient client;
  pageRoute({Key key, @required this.thread, @required this.client})
      : super(key: key);

  @override
  pageRouteState createState() => pageRouteState(thread, client);
}

class pageRouteState extends State<pageRoute> {
  Item thread;
  LihkgClient _client;
  int _page = 1;
  int _minPage;
  int _maxPage;
  int _totalPage;
  bool orderByScore = false;
  Map<int, List<ItemData>> items = new Map();
  ScrollController _scrollController;

  pageRouteState(this.thread, this._client);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    _minPage = _page;
    _maxPage = _page;
    _totalPage = thread.totalPage;
    _scrollController = ScrollController(keepScrollOffset: false);
    _scrollController.addListener(_scrollListener);
    _onLoadPage();
    super.initState();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _maxPage++;
      _page = _maxPage;
      if (_page <= _totalPage) {
        _onLoadPage();
      } else {
        _page = 1;
        _minPage = 1;
      }
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      _minPage--;
      _page = _minPage;
      if (_page > 0) {
        _onLoadPage();
      } else {
        _page = _totalPage;
        _minPage = _totalPage;
      }
    }
  }

  Future<void> _onLoadPage() async {
    Map<int, List<ItemData>> _tempMap = Map.from(items);

    // final page = await _client.getPage(thread.threadID,
    //     page: _page, orderByScore: orderByScore);
    String dummyString =
        await rootBundle.loadString('assets/json/page_1.json');
    Map dummyJson = json.decode(dummyString);
    final page =  BaseResponse<PageResponse>.fromJson(dummyJson);
    if (page.response == null) {
      return;
    }
    if (page.response.itemData.isNotEmpty) {
      _tempMap[_page] = page.response.itemData;
      setState(() {
        _totalPage = page.response.totalPage;
        items = _tempMap;
      });
    }
  }

  List<Widget> _buildSlivers(BuildContext context) {
    List<Widget> slivers = new List<Widget>();
    slivers.addAll(_buildLists(context, items));
    return slivers;
  }

  Widget _buildHeader(int index, {String text}) {
    return new Container(
      height: 60.0,
      color: Color.fromARGB(200, 255, 255, 255),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: new Text(
        text ?? '第${index}頁',
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  List<Widget> _buildLists(
      BuildContext context, Map<int, List<ItemData>> items) {
    int count = items.length;
    List<int> sortedKeys = items.keys.toList()..sort();
    return List.generate(count, (index) {
      int page = sortedKeys[index];
      return new SliverStickyHeader(
        overlapsContent: false,
        header: _buildHeader(page),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => MsgCard(msg: items[page][i], client: _client),
            childCount: items[page].length,
          ),
        ),
      );
    });
  }

  _onSelectPage(int page) {
    _page = page;
    _maxPage = _page;
    _minPage = _page;
    setState(() {
      items.clear();
    });
    _onLoadPage();
  }

  _onPressedReply() {
    //TODO
    // print("reply pressed ${thread.threadID}");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => replyRoute(
                  thread: thread,
                  client: _client,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.reply,
              color: Colors.white,
            ),
            onPressed: _onPressedReply,
          ),
          IconButton(
            icon: Icon(
              Icons.flash_on,
              color: orderByScore ? Colors.yellowAccent : Colors.white,
            ),
            onPressed: () {
              orderByScore = !orderByScore;
              _onSelectPage(1);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: _buildSlivers(context),
      ),
      endDrawer: Drawer(
        child: ListView.builder(
          itemCount: _totalPage,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("第${index + 1}頁"),
              onTap: () {
                _onSelectPage(index + 1);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
