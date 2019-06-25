import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:html/dom.dart' as dom;
import 'package:dotted_border/dotted_border.dart';
import 'src/page.dart';

class msgCard extends StatefulWidget {
  final Item_data msg;
  msgCard({Key key, @required this.msg}) : super(key: key);

  @override
  msgCardState createState() => msgCardState(msg);
}

class msgCardState extends State<msgCard> {
  Item_data msg;
  bool showImages = true;
  ImageErrorListener onImageError;
  msgCardState(this.msg);

  Widget _customRender(dom.Node node, List<Widget> children) {
    if (node is dom.Element) {
      switch (node.localName) {
        case "custom_tag":
          return Text(node.localName);
        case "img":
          return Builder(
            builder: (BuildContext context) {
              if (showImages) {
                if (node.attributes['src'] != null) {
                  if (node.attributes['src'].startsWith("data:image") &&
                      node.attributes['src'].contains("base64,")) {
                    precacheImage(
                      MemoryImage(base64.decode(
                          node.attributes['src'].split("base64,")[1].trim())),
                      context,
                      onError: onImageError,
                    );
                    return Image.memory(base64.decode(
                        node.attributes['src'].split("base64,")[1].trim()));
                  }
                  String img_src;
                  if (node.attributes['src'].startsWith('/assets/')) {
                    img_src = 'https://lihkg.com${node.attributes['src']}';
                  } else {
                    img_src = node.attributes['src'];
                  }
                  precacheImage(
                    NetworkImage(img_src),
                    context,
                    onError: onImageError,
                  );
                  return Image.network(img_src);
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
              }
              return Container();
            },
          );
        case "sub":
          return DottedBorder(
            gap: 3.0,
            strokeWidth: 3.0,
            child: Html(
              data: node.innerHtml,
              useRichText: false,
              onLinkTap: _onLinkTap,
              customRender: _customRender,
            ),
          );
      }
    } else if (node is dom.Text) {
      //We don't need to worry about rendering extra whitespace
      if (node.text.trim() == "" && node.text.indexOf(" ") == -1) {
        return Wrap();
      }
      if (node.text.trim() == "" && node.text.indexOf(" ") != -1) {
        node.text = " ";
      }

      String finalText = trimStringHtml(node.text);
      //Temp fix for https://github.com/flutter/flutter/issues/736
      if (finalText.endsWith(" ")) {
        return Container(
            padding: EdgeInsets.only(right: 2.0),
            child: Linkify(
              onOpen: (link) => _onLinkTap(link.url),
              text: finalText,
            ));
      } else {
        return Linkify(
          onOpen: (link) => _onLinkTap(link.url),
          text: finalText,
        );
      }
    }
  }

  String trimStringHtml(String stringToTrim) {
    stringToTrim = stringToTrim.replaceAll("\n", "");
    while (stringToTrim.indexOf("  ") != -1) {
      stringToTrim = stringToTrim.replaceAll("  ", " ");
    }
    return stringToTrim;
  }

  void _onLinkTap(String url) {
    print("opening ${url}");
  }

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
                Text("${msg.user_nickname}",
                    style: TextStyle(
                        color:
                            msg.user_gender == "M" ? Colors.blue : Colors.red,
                        fontSize: 20.0)),
              ],
            ),
          ),
          Html(
            data: msg.msg,
            useRichText: false,
            onLinkTap: _onLinkTap,
            customRender: _customRender,
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
