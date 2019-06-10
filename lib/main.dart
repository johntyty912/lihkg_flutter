import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/property.dart';

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
  String sub_cat_url;

  DynamicTabContent.name(this.sub_cat_name, this.sub_cat_url);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _selected_cat_id = "1";

  Map<String, Category> _category = new Map();
  List<DynamicTabContent> _subCatList = new List();

  TabController _tabController;
  TabPageSelector _tabPageSelector;

  @override
  void initState() {
    super.initState();
    _onCreate();
  }

  Future<void> _onCreate() async {
    final property = await getProperty();
    List<DynamicTabContent> _tempList = new List();
    for (final category in property.response.category_list) {
      _category[category.cat_id] = category;
    }

    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      String _main_url = sub_cat.url;
      if (sub_cat.query.length > 0) {
        _main_url += "?";
        sub_cat.query.forEach((k, v) => _main_url += "${k}=${v}&");
      }
      _tempList.add(new DynamicTabContent.name(sub_cat.name, _main_url));
    }
    setState(() {
      _subCatList = _tempList;
      _tabController =
          new TabController(vsync: this, length: _subCatList.length);
      _tabPageSelector = new TabPageSelector(
        controller: _tabController,
      );
    });
  }

  void _onChangeSelectedCatID() {
    setState(() {
      _subCatList.clear();
    });
    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      String _main_url = sub_cat.url;
      Map<String, String> query = sub_cat.query;
      if (sub_cat.query.length > 0) {
        _main_url += "?";
        sub_cat.query.forEach((k, v) => _main_url += "${k}=${v}&");
      }
      _subCatList.add(new DynamicTabContent.name(sub_cat.name, _main_url));
    }
    setState(() {
      _tabController =
          new TabController(vsync: this, length: _subCatList.length);
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
    if (_subCatList.length <= 0) return LoadingPage();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _subCatList.isEmpty
              ? <Widget>[]
              : [
                  TabBar(
                      tabs: _subCatList.map((subCat) {
                        return new Tab(
                          text: subCat.sub_cat_name,
                        );
                      }).toList(),
                      controller: _tabController)
                ],
        ),
      ),
      body: TabBarView(
        children: _subCatList.isEmpty
            ? <Widget>[]
            : _subCatList.map((subCat) {
                return new Text(subCat.sub_cat_url);
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
