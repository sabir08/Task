import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:hello/task1.dart';

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  List<Task> myTask = [
    Task(
      name: 'Hello World',
      color: 0xff63e028,
      size: 10,
      family: 'Schyler',
    ),
    Task(name: 'Hello World', color: 0xff0d0707, size: 16, family: 'Raleway'),
    Task(name: 'Hello World', color: 0xff1121b8, size: 20, family: 'Pacifico'),
  ];
  double custSiize = 18;

  void changeFontSize() {
    setState(() {
      custSiize += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task 1'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50, left: 15),
            child: Container(
              height: 400,
              width: 330,
              decoration: BoxDecoration(
                  border: Border.all(
                style: BorderStyle.solid,
                color: Colors.black,
                width: 1,
              )),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        RaisedButton(
                          elevation: 10.0,
                          onPressed: () {
                            myTask.forEach((task) {
                              task.family = (Random().toString());
                            });
                          },
                          shape: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                          color: Colors.amber[300],
                          child: Text('Font'),
                        ),
                        RaisedButton(
                          elevation: 10.0,
                          onPressed: () {
                            print('ok');
                            changeFontSize();

                            setState(() {});
                          },
                          shape: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                          color: Colors.amber[300],
                          child: Text('Text-Size'),
                        ),
                        RaisedButton(
                          elevation: 10.0,
                          onPressed: () {
                            print('ok');
                            myTask.forEach((task) {
                              task.color =
                                  (Random().nextDouble() * 0xffffffff).toInt();
                            });
                            setState(() {});
                          },
                          shape: Border.all(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1,
                          ),
                          color: Colors.amber,
                          child: Text('Text-Color'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  ListView.separated(
                      padding: EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: (myTask.length),
                      itemBuilder: (context, int index) {
                        return Container(
                          height: 65,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              myTask[index].name,
                              style: TextStyle(
                                  fontSize: custSiize,
                                  fontFamily: myTask[index].family,
                                  fontWeight: FontWeight.bold,
                                  color: Color(myTask[index].color)),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Container(
              height: 50,
              width: 330,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 0.6,
                    offset: Offset(2.4, 3.5),
                  )
                ],
              ),
              child: FlatButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    borderSide: BorderSide(color: Color(0xffc4cff5))),
                color: Color(0xffc4cff5),
                child: Text(
                  'Task 2',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff1a1616),
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Task {
  String name;
  int color;
  int size;
  String family;

  Task({this.color, this.name, this.size, this.family});
}
