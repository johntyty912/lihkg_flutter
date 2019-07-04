import 'package:shared_preferences/shared_preferences.dart';
import 'package:lihkg_api/lihkg_api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pageRoute.dart';
import 'loginRoute.dart';
import 'userInfoRoute.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "lihkg_flutter",
      theme: ThemeData(
        backgroundColor: Colors.black,
      ),
      home: MyHomePage(),
    );
  }
}

class DynamicTabContent {
  String tabName;
  SubCategory subCategory;
  List<Item> threadList;
  Map<String, String> query;
  String searchKeyword;
  int page = 1;
  bool isSearch = false;

  ScrollController _scrollController = new ScrollController();

  DynamicTabContent.fromSubCat(
      this.tabName, this.subCategory, this.threadList, this.query)
      : this.isSearch = false;

  DynamicTabContent.fromSearch(
      this.tabName, this.threadList, this.searchKeyword)
      : this.isSearch = true;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  LihkgClient _client;
  User _me;
  bool _logined = false;

  String _selectedCatID = "1";
  String _selectedSubCat;

  Map<String, Category> _category = new Map();
  Map<String, DynamicTabContent> _subCats = new Map();

  TabController _tabController;

  LoginResponse _login;
  SharedPreferences prefs;
  List<String> loginInfo;

  TextEditingController _searchController = new TextEditingController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _client = new LihkgClient();
    _onLoginCache();
    _onCreate();
  }

  _onLoginCache() async {
    prefs = await SharedPreferences.getInstance();
    loginInfo = prefs.getStringList("loginInfo") ?? new List<String>();
    if (loginInfo.isNotEmpty) {
      final Map<String, String> body = {
        "email": loginInfo[0],
        "password": loginInfo[1],
      };
      BaseResponse<LoginResponse> loginResponse = await _client.postLogin(body);
      _me = loginResponse.response.me;
      _logined = true;
    }
  }

  Future<void> _onCreate() async {
    final property = await _client.getProperty();
    Map<String, DynamicTabContent> _tempMap = new Map();
    for (final category in property.response.categoryList) {
      _category[category.catId] = category;
    }

    for (final subCat in _category[_selectedCatID].subCategory) {
      final threadList = await _client.getCategory(subCat, 1);
      _tempMap[subCat.name] = new DynamicTabContent.fromSubCat(
          subCat.name, subCat, threadList.response.items, subCat.query);
      _tempMap[subCat.name]._scrollController.addListener(_scrollListener);
    }
    setState(() {
      _subCats = _tempMap;
      _selectedSubCat = _subCats.keys.toList()[0];
      _tabController = new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
    });
  }

  _tabListener() {
    if (_tabController.indexIsChanging) {
      _selectedSubCat = _subCats.keys.toList()[_tabController.index];
    }
  }

  _scrollListener() {
    if (_subCats[_selectedSubCat]._scrollController.offset >=
            _subCats[_selectedSubCat]
                ._scrollController
                .position
                .maxScrollExtent &&
        !_subCats[_selectedSubCat]._scrollController.position.outOfRange) {
      _onLoadThread();
    }
  }

  Future<void> _onLoadThread() async {
    List<Item> _tempList = _subCats[_selectedSubCat].threadList;
    _subCats[_selectedSubCat].page++;
    var threadList;
    if (_subCats[_selectedSubCat].isSearch) {
      Map<String, String> _searchtabMap = {
        '最相關': 'score',
        '主題新至舊': 'desc_create_time',
        '回覆新至舊': 'desc_reply_time'
      };
      threadList = await _client.getSearch(
          _subCats[_selectedSubCat].searchKeyword,
          sort: _searchtabMap[_selectedSubCat],
          page: _subCats[_selectedSubCat].page);
    } else {
      threadList = await _client.getCategory(
          _subCats[_selectedSubCat].subCategory,
          _subCats[_selectedSubCat].page);
    }
    if (threadList.success == 0) {
      return;
    }
    for (final item in threadList.response.items) {
      _tempList.add(item);
    }
    setState(() {
      _subCats[_selectedSubCat].threadList = _tempList;
    });
  }

  Future<void> _onChangeSelectedCatID() async {
    setState(() {
      _subCats.clear();
    });
    for (final subCat in _category[_selectedCatID].subCategory) {
      final threadList = await _client.getCategory(subCat, 1);
      _subCats[subCat.name] = new DynamicTabContent.fromSubCat(
          subCat.name, subCat, threadList.response.items, subCat.query);
      _subCats[subCat.name]._scrollController.addListener(_scrollListener);
    }
    _selectedSubCat = _subCats.keys.toList()[0];
    setState(() {
      _tabController = new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_subCats.length <= 0) return LoadingPage();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _subCats.isEmpty
              ? <Widget>[]
              : [
                  TabBar(
                      tabs: _subCats.values.map((subCat) {
                        return new Tab(
                          text: subCat.tabName,
                        );
                      }).toList(),
                      controller: _tabController)
                ],
        ),
      ),
      body: TabBarView(
        children: _subCats.isEmpty
            ? <Widget>[]
            : _subCats.values.map((subCat) {
                return ListView.separated(
                    controller: subCat._scrollController,
                    itemCount: subCat.threadList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          subCat.threadList[index].userNickname,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: subCat.threadList[index].userGender == "M"
                                  ? Colors.blue
                                  : Colors.red),
                        ),
                        subtitle: Text(subCat.threadList[index].title,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pageRoute(
                                      thread: subCat.threadList[index],
                                      client: _client,
                                    )),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    });
              }).toList(),
        controller: _tabController,
      ),
      drawer: Drawer(
        child: ListView(
          children: _category.isEmpty
              ? <Widget>[]
              : <Widget>[
                  ListTile(
                    title: _login == null ? Text("登入") : Text(_me.nickname),
                    onTap: _login == null ? onTapLogin : onTapUserName,
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: '搜尋',
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    controller: _searchController,
                    onEditingComplete: () {
                      onSearchEditingComplete(_searchController.text);
                    },
                  ),
                  ...getListTileFromCategory(_category),
                ],
        ),
      ),
    );
  }

  onSearchEditingComplete(String q) async {
    Map<String, DynamicTabContent> _tempMap = new Map();
    Map<String, String> _tabMap = {
      '最相關': 'score',
      '主題新至舊': 'desc_create_time',
      '回覆新至舊': 'desc_reply_time'
    };
    for (final _tabName in _tabMap.keys) {
      final response = await _client.getSearch(q, sort: _tabMap[_tabName]);
      _tempMap[_tabName] =
          DynamicTabContent.fromSearch(_tabName, response.response.items, q);
      _tempMap[_tabName]._scrollController.addListener(_scrollListener);
    }
    _selectedSubCat = _tempMap.keys.toList()[0];
    setState(() {
      _subCats = _tempMap;
      _tabController = new TabController(vsync: this, length: _tempMap.length);
      _tabController.addListener(_tabListener);
    });
  }

  onTapUserName() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => userInfoRoute(me: _me)))
        .then((result) {
      if (result) {
        onTapLogout();
      }
    });
  }

  onTapLogout() {
    prefs.clear();
    setState(() {
      _login = null;
    });
  }

  onTapLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginRoute(client: _client))).then((result) {
      setState(() {
        _client = result[0];
      });
      List<String> tempList = new List<String>();
      tempList.add(result[1]);
      tempList.add(result[2]);
      prefs.setStringList("loginInfo", tempList);
    });
  }

  Widget LoadingPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading"),
      ),
      body: Text("Loading"),
    );
  }

  List<ListTile> getListTileFromCategory(Map<String, Category> _category) {
    List<ListTile> tempList = new List();
    for (Category cat in _category.values) {
      tempList.add(new ListTile(
        title: Text(cat.name),
        selected: (cat.catId == _selectedCatID) ? true : false,
        onTap: () {
          setState(() {
            _selectedCatID = cat.catId;
          });
          _onChangeSelectedCatID();
          Navigator.of(context).pop();
        },
      ));
    }
    return tempList;
  }
}
