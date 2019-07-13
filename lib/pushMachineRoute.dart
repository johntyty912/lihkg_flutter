import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class pushMachineRoute extends StatefulWidget {

  @override
  pushMachineRouteState createState() => pushMachineRouteState();
}

class pushMachineRouteState extends State<pushMachineRoute> {

  List<ListTile> buildListTile(Map<String, globals.PushMachine>pushMachines) {
    List<ListTile> list = new List();
    pushMachines.forEach((title,machine) {
      list.add(
        new ListTile(
          title: Text(title),
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
        )
      );
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
        children: buildListTile(globals.pushMachines),
      ),
    );
  }
}