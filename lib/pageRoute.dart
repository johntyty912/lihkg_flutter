import 'package:flutter/material.dart';
import 'package:lihkg_api/lihkg_api.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'msgCard.dart';

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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
    _onLoadPage();
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _maxPage++;
      _page = _maxPage;
      _onLoadPage();
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      _minPage--;
      _page = _minPage;
      _onLoadPage();
    }
  }

  Future<void> _onLoadPage() async {
    Map<int, List<ItemData>> _tempMap = items;

    final page = await _client.getPage(thread.threadID,
        page: _page, orderByScore: orderByScore);
    if (page.response == null) {
      return;
    }
    _tempMap[_page] = page.response.itemData;
    setState(() {
      items = _tempMap;
    });
  }

  List<MsgCard> msgCardGenerator(List<ItemData> items, LihkgClient _client) {
    return List<MsgCard>.generate(
        items.length,
        (i) => MsgCard(
              msg: items[i],
              client: _client,
            ));
  }

  List<Widget> _buildSlivers(BuildContext context) {
    List<Widget> slivers = new List<Widget>();
    slivers.addAll(_buildLists(context, items));
    return slivers;
  }

  Widget _buildHeader(int index, {String text}) {
    return new Container(
      height: 60.0,
      color: Colors.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: new Text(
        text ?? '第${index}頁',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  List<Widget> _buildLists(BuildContext context, Map<int, List<ItemData>> items) {
    int count = items.length;
    return List.generate(count, (index) {
      int page = items.keys.toList()[index];
      return new SliverStickyHeader(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: _buildSlivers(context),
      ),
    );
  }
}
