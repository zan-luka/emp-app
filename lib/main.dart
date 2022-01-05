import 'package:emp_flutter_app/openMaps.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'pallete.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

List _items = [];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kolesarjanci',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    readJson();
  }



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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade900, Colors.green.shade400])),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: const Text("Kolesarjanci"),
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
            /*InkWell(
              onTap: (){
                MapUtils.openMap("https://www.google.com/maps/dir/?api=1&destination=45.90415729448569,13.91227001019901&waypoints=45.88841973257892, 13.904491768171905|45.89741275863526,13.905123017668604&travelmode=walking&map_action=map&basemap=terrain");
              },
              child: const Text(
                "BOGATA MAPA",
              ),
            ),*/
            _items.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_items[index]["naziv"]),
                          subtitle: Text(_items[index]["opis"]),
                          trailing: Text("Ocena: "+((_items[index]["nice"]/(_items[index]["nice"]+_items[index]["notnice"])*100).toInt()).toString()),
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
      ),
    ),// This trailing comma makes auto-formatting nicer for build methods.
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

  final LatLng _center = const LatLng(45.521563, -122.677433);

  const FirstRoute({Key? key, required this.id, required this.naziv, required this.opis, required this.tezavnost, required this.vzpon, required this.url, required this.like, required this.dislike}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade900, Colors.green.shade400])),
    child: Scaffold(
    backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(naziv),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Text(naziv, style: const TextStyle(fontSize: 50)),
              margin: const EdgeInsets.only(top: 30, bottom: 30),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Text("Ocena: " + ((like/(like+dislike)*100).toInt()).toString(), style: const TextStyle(fontSize: 20)),
              margin: const EdgeInsets.only(right: 20, bottom: 20),
            ),
            Container(
              child: Text(opis, style: const TextStyle(fontSize: 20)),
              margin: const EdgeInsets.only(bottom: 30),
            ),
            Container(
              child: Text("Težavnost: " + tezavnost, style: const TextStyle(fontSize: 20)),
              margin: const EdgeInsets.only(bottom: 30),
            ),
            Container(
              child: Text("Vzpon: " + vzpon.toString() + "m", style: const TextStyle(fontSize: 20)),
              margin: const EdgeInsets.only(bottom: 30),
            ),

            ElevatedButton(onPressed: () {MapUtils.openMap(url);}, child: const Text("Navodila za pot")),


            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                ElevatedButton(
                  onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/like/" + id.toString() + "/" + (like+1).toString()); },
                  child: const Text("Priporoči"),),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/dislike/" + id.toString() + "/" + (dislike+1).toString()); },
                  child: const Text("Ne Priporoči"),),

              ],
            ),
            ),
            Container(
              height: 300,
              child: GoogleMap(
                  initialCameraPosition: _Map()._initPos(id),
                  onMapCreated: _Map()._onMapCreated,
                  markers: _Map()._createMarker(id),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }}

  class _Map {
    CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(45.9159, 13.7376), zoom: 11.0);

    late GoogleMapController googleMapController;
    bool isReady = false;

    double start_x = 0.0;
    double start_y = 0.0;
    double cilj_x = 0.0;
    double cilj_y = 0.0;

    void _onMapCreated(GoogleMapController controller) {
      googleMapController = controller;
    }

    CameraPosition _initPos(int id) {
      start_x = double.parse(_items[id-1]["start_x"]);
      start_y = double.parse(_items[id-1]["start_y"]);
      cilj_x = double.parse(_items[id-1]["cilj_x"]);
      cilj_y = double.parse(_items[id-1]["cilj_y"]);
      return CameraPosition(target: LatLng(start_x, start_y), zoom: 12);
    }

    Set<Marker> _createMarker(int id) {
      start_x = double.parse(_items[id-1]["start_x"]);
      start_y = double.parse(_items[id-1]["start_y"]);
      cilj_x = double.parse(_items[id-1]["cilj_x"]);
      cilj_y = double.parse(_items[id-1]["cilj_y"]);

      return {
        Marker(
            markerId: MarkerId("start"),
            //position: LatLng(double.parse(_items[id]["start_x"]), double.parse(_items[id]["start_y"])),
            position: LatLng(start_x, start_y),
            infoWindow: InfoWindow(title: "Start"),
        ),
        Marker(
          markerId: MarkerId("cilj"),
          //position: LatLng(double.parse(_items[id]["cilj_x"]), double.parse(_items[id]["cilj_y"])),
          position: LatLng(cilj_x, cilj_y),
          infoWindow: InfoWindow(title: 'Cilj'),
        ),
      };
    }
  }
