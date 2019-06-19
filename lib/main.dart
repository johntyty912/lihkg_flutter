import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/property.dart';
import 'src/thread.dart' as thread;
import 'pageRoute.dart';

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

  DynamicTabContent.name(this.sub_cat_name, this.thread_list, this.sub_cat_url, this.query);
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

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    _onCreate();
  }

  Future<void> _onCreate() async {
    final property = await getProperty();
    // List<DynamicTabContent> _tempList = new List();
    Map<String, DynamicTabContent> _tempMap = new Map();
    for (final category in property.response.category_list) {
      _category[category.cat_id] = category;
    }

    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      final thread_list = await thread.getThread(sub_cat.url, sub_cat.query);
    //   _tempList.add(
    //       new DynamicTabContent.name(sub_cat.name, thread_list.response.items));
    // }
    _tempMap[sub_cat.name] = new DynamicTabContent.name(sub_cat.name, thread_list.response.items, sub_cat.url, sub_cat.query);
    }
    setState(() {
      // _subCatList = _tempList;
      _subCats = _tempMap;
      _selectedSubCat = _subCats.keys.toList()[0];
      _tabController = 
          new TabController(vsync: this, length: _subCats.length);
      _tabController.addListener(_tabListener);
      _tabPageSelector = new TabPageSelector(
        controller: _tabController,
      );
    });
  }

  _tabListener() {
    if (_tabController.indexIsChanging) {
      _selectedSubCat = _subCats.keys.toList()[_tabController.index];
      print(_selectedSubCat);
    }
  }
  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
          print("hi");
          _onLoadThread();
    }
  }

  Future<void> _onLoadThread() async {
    List<thread.Item> _tempList = _subCats[_selectedSubCat].thread_list;
    Map<String, String> _query = _subCats[_selectedSubCat].query;
    _subCats[_selectedSubCat]._page++;
    _query['page'] = "${_subCats[_selectedSubCat]._page}";
    final thread_list = await thread.getThread(_subCats[_selectedSubCat].sub_cat_url, _query);
    for ( final item in thread_list.response.items) {
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
      _subCats[sub_cat.name] = new DynamicTabContent.name(sub_cat.name, threadList.response.items, sub_cat.url, sub_cat.query);
    }
    _selectedSubCat = _subCats.keys.toList()[0];
    setState(() {
      _tabController =
          new TabController(vsync: this, length: _subCats.length);
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
                    controller: _scrollController,
                    itemCount: subCat.thread_list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(subCat.thread_list[index].user_nickname, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                        subtitle: Text(subCat.thread_list[index].title, style: TextStyle(fontSize: 16.0, color: Colors.black)),
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => pageRoute(thread:subCat.thread_list[index])),
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
              : getListTileFromCategory(_category),
        ),
      ),
    );
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
