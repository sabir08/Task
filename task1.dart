import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  String getApiDetails;
  var getApiDetailslength;
  void getApiData() async {
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/photos");

    if (response.statusCode == 200) {
      getApiDetails = response.body;
      setState(() {
        getApiDetailslength = jsonDecode(getApiDetails);
        print(getApiDetailslength.length);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (getApiDetails == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Task 2'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: 550,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: getApiDetailslength.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 200,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Image.network(
                                    "${jsonDecode(getApiDetails)[index]['thumbnailUrl']}",
                                  ),
                                ),
                                Container(
                                    width: 150,
                                    child: Text(
                                      "${jsonDecode(getApiDetails)[index]['title']}",
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            color: Colors.deepOrange,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "${jsonDecode(getApiDetails)[index]['thumbnailUrl']}"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      child: Text(
                                        "${jsonDecode(getApiDetails)[index]['title']}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            color: Colors.green.shade700,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                        "${jsonDecode(getApiDetails)[index]['title']}")),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Image.network(
                                    "${jsonDecode(getApiDetails)[index]['thumbnailUrl']}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
