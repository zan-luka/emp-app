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
        title: const Text("Kolesarske poti v Vipavski dolini"),
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
            Container(
              alignment: Alignment.topCenter,
              child: const Text("Izberi željeno kolesarsko pot:", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10)
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
                          trailing: Text(((_items[index]["tezavnost"]))),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => FirstRoute(index: index, id: _items[index]["id"], naziv: _items[index]["naziv"], opis: _items[index]["opis"], tezavnost: _items[index]["tezavnost"], vzpon: _items[index]["vzpon"], url: _items[index]["url"], like: _items[index]["nice"], dislike: _items[index]["notnice"],)));
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
  final int index;
  final int id;
  final String naziv;
  final String opis;
  final String tezavnost;
  final int vzpon;
  final String url;
  final int like;
  final int dislike;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  const FirstRoute({Key? key, required this.index, required this.id, required this.naziv, required this.opis, required this.tezavnost, required this.vzpon, required this.url, required this.like, required this.dislike}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,

      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade900, Colors.green.shade400])),

    child: Scaffold(
    backgroundColor: Colors.transparent,
      appBar: AppBar(
        //backgroundColor: Pallete.kToDark,
        backgroundColor: Colors.transparent,
        title: Text(naziv),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: Text(naziv, style: const TextStyle(fontSize: 30, color: Colors.white)),
              margin: const EdgeInsets.only(top: 10, bottom: 25),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text(opis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              margin: const EdgeInsets.only(bottom: 20, left: 10),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text("Ocena: " + ((like/(like+dislike)*100).toInt()).toString(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              margin: const EdgeInsets.only(bottom: 20, left: 10),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text("Težavnost: " + tezavnost, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              margin: const EdgeInsets.only(bottom: 20, left: 10),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text("Vzpon: " + vzpon.toString() + "m", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white)),
              margin: const EdgeInsets.only(bottom: 20, left: 10),
            ),

            ElevatedButton(
                onPressed: () {MapUtils.openMap(url);},
                child: const Text("Navodila za pot", style: TextStyle(fontSize: 20),),
                style: ElevatedButton.styleFrom(primary: Colors.blue.shade700),
            ),


            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                ElevatedButton(
                  onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/like/" + id.toString() + "/" + (like+1).toString()); },
                  child: const Text("Priporoči"),
                  style: ElevatedButton.styleFrom(primary: Colors.blue.shade700),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () { http.put("https://guarded-dusk-58497.herokuapp.com/dislike/" + id.toString() + "/" + (dislike+1).toString()); },
                  child: const Text("Ne Priporoči"),
                  style: ElevatedButton.styleFrom(primary: Colors.blue.shade700),
                ),

              ],
            ),
            ),
            Container(
              height: 300,
              child: GoogleMap(
                  initialCameraPosition: _Map()._initPos(index),
                  onMapCreated: _Map()._onMapCreated,
                  markers: _Map()._createMarker(index),
                  mapType: MapType.hybrid,
                  
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
      /*
      controller.setMapStyle('''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#523735"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#c9b2a6"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#dcd2be"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#ae9e90"
      }
    ]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#93817c"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#a5b076"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#447530"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f1e6"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#fdfcf8"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f8c967"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#e9bc62"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e98d58"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry.stroke",
    "stylers": [
      {
        "color": "#db8555"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#806b63"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8f7d77"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#ebe3cd"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dfd2ae"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#b9d3c2"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#92998d"
      }
    ]
  }
]''');

       */
    }

    CameraPosition _initPos(int id) {
      start_x = double.parse(_items[id]["start_x"]);
      start_y = double.parse(_items[id]["start_y"]);
      cilj_x = double.parse(_items[id]["cilj_x"]);
      cilj_y = double.parse(_items[id]["cilj_y"]);
      return CameraPosition(target: LatLng(start_x, start_y), zoom: 11);
    }

    Set<Marker> _createMarker(int id) {
      start_x = double.parse(_items[id]["start_x"]);
      start_y = double.parse(_items[id]["start_y"]);
      cilj_x = double.parse(_items[id]["cilj_x"]);
      cilj_y = double.parse(_items[id]["cilj_y"]);

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
