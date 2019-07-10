import 'package:flutter/material.dart';
import 'package:lihkg_api/lihkg_api.dart';

class replyRoute extends StatefulWidget {
  final Item thread;
  final LihkgClient client;
  replyRoute({Key key, @required this.thread, @required this.client})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => replyRouteState(thread, client);
}

class replyRouteState extends State<replyRoute> {
  final controller = TextEditingController();

  Item thread;
  LihkgClient _client;

  replyRouteState(this.thread, this._client);

  _onInsertImage() {
    print("image");
  }

  _onPressedSubmit() async {
    // print("content: ${controller.text}");
    final response = await _client.postReply(thread.threadID, controller.text);
    if (response.success == 1) {
      Navigator.pop(context);
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("回覆失敗!"),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("回覆 : ${thread.category.name} - ${thread.title}"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.image,
                ),
                onPressed: _onInsertImage,
              )
            ],
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    borderSide: BorderSide(color: Colors.black, width: 1.0)),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              OutlineButton(
                child: Text("提交"),
                onPressed: _onPressedSubmit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
