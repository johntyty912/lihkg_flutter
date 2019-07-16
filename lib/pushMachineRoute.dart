import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'globals.dart' as globals;

class pushMachineRoute extends StatefulWidget {
  @override
  pushMachineRouteState createState() => pushMachineRouteState();
}

class pushMachineRouteState extends State<pushMachineRoute> {
  List<ListTile> buildListTile(
      BuildContext context, Map<String, globals.PushMachine> pushMachines) {
    List<ListTile> list = new List();
    pushMachines.forEach((title, machine) {
      list.add(new ListTile(
        title: Text(title),
        subtitle: Text("每${machine.duration.inMinutes}分鐘推一次"),
        leading: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            machine.timer.cancel();
            setState(() {
              pushMachines.remove(title);
            });
          },
        ),
        trailing: Checkbox(
          value: machine.run,
          onChanged: (value) {
            setState(() {
              machine.run = value;
            });
          },
        ),
        onLongPress: () {
          int _currentValue;
          _currentValue = machine.duration.inMinutes;
          machine.textEditingController.text = machine.content;
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("推post"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  contentPadding: EdgeInsets.only(top: 10.0),
                  content: Container(
                    width: 300.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: Colors.grey,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: TextField(
                                controller: machine.textEditingController,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                        ),
                        NumberPicker.integer(
                          initialValue: _currentValue,
                          minValue: 1,
                          maxValue: 60,
                          itemExtent: 30.0,
                          onChanged: (newValue) {
                            setState(() {
                              _currentValue = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        setState(() {
                          machine.content = machine.textEditingController.text;
                          machine.setDuration(_currentValue);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("推post機器"),
      ),
      body: ListView(
        children: buildListTile(context, globals.pushMachines),
      ),
    );
  }
}
