import 'package:lihkg_flutter/userInfoRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/property.dart';
import 'src/thread.dart' as thread;
import 'src/login.dart' as login;
import 'pageRoute.dart';
import 'loginRoute.dart';

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
  String sub_cat_name;
  List<thread.Item> thread_list;
  String sub_cat_url;
  Map<String, String> query;
  int _page = 1;

  ScrollController _scrollController = new ScrollController();

  DynamicTabContent.name(
      this.sub_cat_name, this.thread_list, this.sub_cat_url, this.query);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _selected_cat_id = "1";
  String _selectedSubCat;

  Map<String, Category> _category = new Map();
  Map<String, DynamicTabContent> _subCats = new Map();

  TabController _tabController;
  TabPageSelector _tabPageSelector;

  login.Login _login;
  SharedPreferences prefs;
  List<String> loginInfo;

  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _onLoginCache();
    _onCreate();
  }

  _onLoginCache() async {
    prefs = await SharedPreferences.getInstance();
    loginInfo = prefs.getStringList("loginInfo") ?? new List<String>();
    if (loginInfo.isNotEmpty) {
      _login = await onLogin();
    }
  }

  Future<login.Login> onLogin() async {
    final Map<String, String> body = {
      "email": loginInfo[0],
      "password": loginInfo[1],
    };
    final result = await login.postLogin(body);
    return result;
  }

  Future<void> _onCreate() async {
    final property = await getProperty();
    Map<String, DynamicTabContent> _tempMap = new Map();
    for (final category in property.response.category_list) {
      _category[category.cat_id] = category;
    }

    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      final threadList = await thread.getThread(sub_cat.url, sub_cat.query);
      _tempMap[sub_cat.name] = new DynamicTabContent.name(
          sub_cat.name, threadList.response.items, sub_cat.url, sub_cat.query);
      _tempMap[sub_cat.name]._scrollController.addListener(_scrollListener);
    }
    setState(() {
      _subCats = _tempMap;
      _selectedSubCat = _subCats.keys.toList()[0];
      _tabController = new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
      _tabPageSelector = new TabPageSelector(
        controller: _tabController,
      );
    });
  }

  _tabListener() {
    if (_tabController.indexIsChanging) {
      _selectedSubCat = _subCats.keys.toList()[_tabController.index];
      // print("$_selectedSubCat: ${_subCats[_selectedSubCat].query}");
    }
  }

  _scrollListener() {
    if (_subCats[_selectedSubCat]._scrollController.offset >=
            _subCats[_selectedSubCat]._scrollController.position.maxScrollExtent &&
        !_subCats[_selectedSubCat]._scrollController.position.outOfRange) {
      _onLoadThread();
    }
  }

  Future<void> _onLoadThread() async {
    List<thread.Item> _tempList = _subCats[_selectedSubCat].thread_list;
    Map<String, String> _query = _subCats[_selectedSubCat].query;
    _subCats[_selectedSubCat]._page++;
    _query['page'] = "${_subCats[_selectedSubCat]._page}";
    print(_query);
    final threadList =
        await thread.getThread(_subCats[_selectedSubCat].sub_cat_url, _query);
    if (threadList.success == 0) {
      return;
    }
    for (final item in threadList.response.items) {
      _tempList.add(item);
    }
    setState(() {
      _subCats[_selectedSubCat].thread_list = _tempList;
    });
  }

  Future<void> _onChangeSelectedCatID() async {
    setState(() {
      _subCats.clear();
    });
    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      final threadList = await thread.getThread(sub_cat.url, sub_cat.query);
      _subCats[sub_cat.name] = new DynamicTabContent.name(
          sub_cat.name, threadList.response.items, sub_cat.url, sub_cat.query);
      _subCats[sub_cat.name]._scrollController.addListener(_scrollListener);
    }
    _selectedSubCat = _subCats.keys.toList()[0];
    setState(() {
      _tabController = new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
      _tabPageSelector = new TabPageSelector(
        controller: _tabController,
      );
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
                          text: subCat.sub_cat_name,
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
                    itemCount: subCat.thread_list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          subCat.thread_list[index].user_nickname,
                          style: TextStyle(
                              fontSize: 14.0,
                              color:
                                  subCat.thread_list[index].user_gender == "M"
                                      ? Colors.blue
                                      : Colors.red),
                        ),
                        subtitle: Text(subCat.thread_list[index].title,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => pageRoute(
                                      thread: subCat.thread_list[index],
                                      login: _login,
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
                    title: _login == null
                        ? Text("登入")
                        : Text(_login.response.me.nickname),
                    onTap: _login == null ? onTapLogin : onTapUserName,
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: '搜尋',
                      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
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
    setState(() {
      _subCats.clear();
    });
    final String url = 'https://lihkg.com/api_v2/thread/search';
    for (final sub_cat in ['最相關','主題新至舊','回覆新至舊']) {
      Map<String, String> query = {
        'q': q,
        'page': '1',
        'count': '30',
      };
      if (sub_cat == '最相關') {query['sort']='score';}
      else if (sub_cat == '主題新至舊') {query['sort']='desc_create_time';}
      else if (sub_cat == '回覆新至舊') {query['sort']='desc_reply_time';}
      final threadList = await thread.getThread(url, query);
      _subCats[sub_cat] = new DynamicTabContent.name(
          sub_cat, threadList.response.items, url, query);
      // print("$sub_cat: ${_subCats[sub_cat].query}");
      _subCats[sub_cat]._scrollController.addListener(_scrollListener);
    }
    _selectedSubCat = _subCats.keys.toList()[0];
    setState(() {
      _tabController = new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
      _tabPageSelector = new TabPageSelector(
        controller: _tabController,
      );
    });
  }

  onTapUserName() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => userInfoRoute(login: _login))).then((result) {
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
            context, MaterialPageRoute(builder: (context) => loginRoute()))
        .then((result) {
      setState(() {
        _login = result[0];
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
        selected: (cat.cat_id == _selected_cat_id) ? true : false,
        onTap: () {
          setState(() {
            _selected_cat_id = cat.cat_id;
          });
          _onChangeSelectedCatID();
          Navigator.of(context).pop();
        },
      ));
    }
    return tempList;
  }
}
