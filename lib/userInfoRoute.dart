import 'package:flutter/material.dart';
import 'package:lihkg_flutter/src/login.dart';

class userInfoRoute extends StatefulWidget {
  final Login login;
  userInfoRoute({Key key, @required this.login}) : super(key: key);

  @override
  State<StatefulWidget> createState()  => userInfoRouteState(login);
}

class userInfoRouteState extends State<userInfoRoute> {
  Login login;
  userInfoRouteState(this.login);

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
              child: Text(login.response.me.nickname[0]),
            ),
            title: Text(login.response.me.nickname),
          ),
          Divider(),
          ListTile(
            title: Text('註冊日期'),
            trailing: Text(timestampToString(login.response.me.create_time)),
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
