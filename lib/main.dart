import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/property.dart';
import 'src/thread.dart' as thread;

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

  DynamicTabContent.name(this.sub_cat_name, this.thread_list);
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
      final thread_list = await thread.getThread(sub_cat.url, sub_cat.query);
      _tempList.add(
          new DynamicTabContent.name(sub_cat.name, thread_list.response.items));
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

  Future<void> _onChangeSelectedCatID() async {
    setState(() {
      _subCatList.clear();
    });
    for (final sub_cat in _category[_selected_cat_id].sub_category) {
      final thread_list = await thread.getThread(sub_cat.url, sub_cat.query);
      _subCatList.add(
          new DynamicTabContent.name(sub_cat.name, thread_list.response.items));
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
                // return new Text(subCat.thread_list[0].title);
                return ListView.separated(
                    itemCount: subCat.thread_list.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(subCat.thread_list[index].title),
                      );
                    },
                    separatorBuilder: (context, idx) {
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
