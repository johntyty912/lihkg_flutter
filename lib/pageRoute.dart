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
    if (page.response.itemData.isNotEmpty) {
      _tempMap[_page] = page.response.itemData;
      setState(() {
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
      color: Color.fromARGB(200, 150, 225, 255),
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.center,
      child: new Text(
        text ?? '第${index}頁',
        style: const TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(thread.title),
        actions: <Widget>[
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
          itemCount: thread.totalPage,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("第${index+1}頁"),
              onTap: () {
                _onSelectPage(index+1);
              },
            );
          },
        ),
      ),
    );
  }
}
