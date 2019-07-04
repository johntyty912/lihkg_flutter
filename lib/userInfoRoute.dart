import 'package:flutter/material.dart';
import 'package:lihkg_api/lihkg_api.dart';

class userInfoRoute extends StatefulWidget {
  final User me;
  userInfoRoute({Key key, @required this.me}) : super(key: key);

  @override
  State<StatefulWidget> createState()  => userInfoRouteState(me);
}

class userInfoRouteState extends State<userInfoRoute> {
  User _me;
  userInfoRouteState(this._me);

  String timestampToString(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp*1000);
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("帳號"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(_me.nickname[0]),
            ),
            title: Text(_me.nickname),
          ),
          Divider(),
          ListTile(
            title: Text('註冊日期'),
            trailing: Text(timestampToString(_me.createTime)),
          ),
          Divider(),
          ListTile(
            title: Center(child: Text("登出")),
            onTap: () {
              Navigator.pop(context, true);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
