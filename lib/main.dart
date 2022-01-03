import 'package:emp_flutter_app/openMaps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'pallete.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kolesarjanci',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Pallete.kToDark,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List _items = [];

  Future<void> readJson() async {
    final response =  await http.get("https://guarded-dusk-58497.herokuapp.com/poti");
    //final String response = await rootBundle.loadString('assets/routes.json');
    final data = await json.decode(response.body);
    setState(() {
      _items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){
                MapUtils.openMap("https://www.google.com/maps/dir/?api=1&destination=45.90415729448569,13.91227001019901&waypoints=45.88841973257892, 13.904491768171905|45.89741275863526,13.905123017668604&travelmode=walking&map_action=map&basemap=terrain");
              },
              child: const Text(
                "BOGATA MAPA",
              ),
            ),
            ElevatedButton(
                onPressed: readJson,
                child: const Text("Poti")
            ),
            _items.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_items[index]["naziv"]),
                          subtitle: Text(_items[index]["opis"]),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FirstRoute(id: _items[index]["id"], naziv: _items[index]["naziv"], opis: _items[index]["opis"], tezavnost: _items[index]["tezavnost"], vzpon: _items[index]["vzpon"], url: _items[index]["url"], like: _items[index]["nice"], dislike: _items[index]["notnice"],)));
                            //MapUtils.openMap(_items[index]["url"]);
                            },
                        ),
                      );
                    },
                ),
            )
            :Container()
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FirstRoute extends StatelessWidget {
  final int id;
  final String naziv;
  final String opis;
  final String tezavnost;
  final int vzpon;
  final String url;
  final int like;
  final int dislike;

  const FirstRoute({Key? key, required this.id, required this.naziv, required this.opis, required this.tezavnost, required this.vzpon, required this.url, required this.like, required this.dislike}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(naziv),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Text(naziv, style: TextStyle(fontSize: 50)),
              margin: EdgeInsets.only(top: 30, bottom: 30),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text("Ratio: " + ((like/(like+dislike)*100).toInt()).toString(), style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.only(right: 20),
            ),
            Container(
              child: Text(opis, style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.only(bottom: 30),
            ),
            Container(
              child: Text("Težavnost: " + tezavnost, style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.only(bottom: 30),
            ),
            Container(
              child: Text("Vzpon: " + vzpon.toString() + "m", style: TextStyle(fontSize: 20)),
              margin: EdgeInsets.only(bottom: 30),
            ),

            ElevatedButton(onPressed: () {MapUtils.openMap(url);}, child: Text("Navodila za pot")),

            Container(
              child: ElevatedButton(
                onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/like/" + id.toString() + "/" + (like+1).toString()); },
                child: Text("Priporoči"),),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/dislike/" + id.toString() + "/" + (dislike+1).toString()); },
                child: Text("Ne Priporoči"),),
            )
          ],
        ),
      ),
    );
  }}
