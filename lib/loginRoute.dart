import 'package:flutter/material.dart';
import 'package:lihkg_api/lihkg_api.dart';

class LoginRoute extends StatefulWidget {
  final LihkgClient client;

  LoginRoute({Key key, @required this.client})
      : super(key: key);
  @override
  LoginRouteState createState() => LoginRouteState(client);
}

class LoginRouteState extends State<LoginRoute> {
  LihkgClient _client;
  LoginRouteState(this._client);
  
  List<dynamic> _result = new List();

  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  Future<BaseResponse<LoginResponse>> onPressedLoginButton() async {
    final Map<String, String> body = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };
    return await _client.postLogin(body);
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.network(
            'https://data.apksum.com/8a/com.lihkg.app/16.1.0/icon.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: _emailController,
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      controller: _passwordController,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //TODO
          if (_emailController.text.isEmpty) {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Please input your email!"),
                  );
                });
          } else if (_passwordController.text.isEmpty) {
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Please input your password!"),
                  );
                });
          } else {
            onPressedLoginButton().then((result) {
              if (result.success == 0) {
                return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(result.errorMessage),
                      );
                    });
              } else if (result.success == 1) {
                _result.add(_client);
                _result.add(result.response.me);
                _result.add(_emailController.text);
                _result.add(_passwordController.text);
                Navigator.pop(context, _result);
              }
            });
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final cancelButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          _result.add(_client);
          Navigator.pop(context, _result);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Cancel', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        // TODO
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            cancelButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
