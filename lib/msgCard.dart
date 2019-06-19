import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'src/page.dart';

class msgCard extends StatefulWidget {

  final Item_data msg;
  msgCard({Key key, @required this.msg}) : super(key: key);

  @override
  msgCardState createState() => msgCardState(msg);
}

class msgCardState extends State<msgCard> {

  Item_data msg;
  msgCardState(this.msg);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text("#${msg.msg_num} "),
                Text("${msg.user_nickname}", style: TextStyle(color: msg.user_gender=="M"? Colors.blue : Colors.red, fontSize: 20.0)),
              ],
            ),
          ),
          Html(
            data: msg.msg,
            onLinkTap: (url) {
              print("opening $url");
            },
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Text(node.localName);
                  case "img":
                    if (node.attributes['src'] != null) {
                      if (node.attributes['src'].startsWith("/assets/")) {
                        return Image.network("https://lihkg.com/${node.attributes['src']}");
                      } else {
                      return Image.network(node.attributes['src']);
                      }
                    } else if (node.attributes['alt'] != null) {
                      //Temp fix for https://github.com/flutter/flutter/issues/736
                      if (node.attributes['alt'].endsWith(" ")) {
                        return Container(
                            padding: EdgeInsets.only(right: 2.0),
                            child: Text(node.attributes['alt']));
                      } else {
                        return Text(node.attributes['alt']);
                      }
                    }
                    return Container();
                }
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.thumb_up),
                Text("100"),
                Icon(Icons.thumb_down),
                Text("200"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
