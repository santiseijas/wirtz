import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wirtz/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({Key key, this.name}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  Position position;
  BitmapDescriptor myIcon;
  BitmapDescriptor myIcon2;
  final double _initFabHeight = 120.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 60.0;
  double _fabHeight;

  @override
  void initState() {
    _getLocation();
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/destination_map_marker.png')
        .then((onValue) {
      myIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/pin2.png')
        .then((onValue) {
      myIcon2 = onValue;
    });
    super.initState();
    _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .55;

    return Material(
      child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'N',
                  style: GoogleFonts.righteous(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(
                      text: 'ombr',
                      style: TextStyle(
                          color: Colors.white, fontSize: 35, wordSpacing: 1),
                    ),
                    TextSpan(
                      text: 'e',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                  ]),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Colors.white,
                  ))
            ],
            backgroundColor: Colors.indigo,
          ),
          body: Stack(
            children: <Widget>[
              _buildGoogleMap(context),
              SlidingUpPanel(
                color: Colors.white,
                maxHeight: _panelHeightOpen,
                minHeight: _panelHeightClosed,
                parallaxEnabled: false,
                parallaxOffset: .5,
                panelBuilder: (sc) => _panel(sc),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0)),
                onPanelSlide: (double pos) => setState(() {
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                      _initFabHeight;
                }),
              ),
            ],
          )

        //_buildContainer(),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        zoomControlsEnabled: false, myLocationEnabled: true,
        // myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 17,
          tilt: 30.0,
          bearing: 270.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: createMarker(),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 17,
      tilt: 30.0,
      bearing: 270.0,
    )));
  }

  void _getLocation() async {
    Position res = await Geolocator().getCurrentPosition();

    setState(() {
      position = res;
    });
  }

  Set<Marker> createMarker() {
    return <Marker>[
      Marker(
        icon: myIcon2,
        markerId: MarkerId("curr_loc"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      ),
      Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(43.375734, -8.433334),
          consumeTapEvents: true,
          icon: myIcon,
          infoWindow: InfoWindow(
            title: 'PlatformMarker',
            snippet: "Hi I'm a Platform Marker",
          ),
          onTap: () {
          }),
      Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(43.373379, -8.433498),
          consumeTapEvents: true,
          icon: myIcon,
          infoWindow: InfoWindow(
            title: 'PlatformMarker',
            snippet: "Hi I'm a Platform Marker",
          ),
          onTap: () {
          }),
      Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(43.370882, -8.422394),
          consumeTapEvents: true,
          icon: myIcon,
          infoWindow: InfoWindow(
            title: 'PlatformMarker',
            snippet: "Hi I'm a Platform Marker",
          ),
          onTap: () {
          }),
      Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(43.376847, -8.422327),
          consumeTapEvents: true,
          icon: myIcon,
          infoWindow: InfoWindow(
            title: 'PlatformMarker',
            snippet: "Hi I'm a Platform Marker",
          ),
          onTap: () {
          }),
    ].toSet();
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
        context: context,
        child: ListView(
          physics: new BouncingScrollPhysics(),
          controller: sc,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/moto.png",
                      height: 200,
                      width: 200,
                    ),
                  ],
                ),
                Text(
                  'C/Simon Bolivar 15'.toUpperCase(),
                  style: GoogleFonts.patuaOne(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: Colors.indigo),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('100%',
                              style: GoogleFonts.patuaOne(
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              )),
                          Icon(
                            Icons.battery_full,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      Text('35 KM',
                          style: GoogleFonts.patuaOne(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        showNavigationButton(),
                        SizedBox(
                          width: 10,
                        ),
                        showReservarButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget showNavigationButton() {
    return new Column(
      children: <Widget>[
        InkWell(
          onTap: () => openMapsSheet(context),
          child: Container(
            height: 60,
            width: 170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.indigo),
            child: Text('Iniciar Navegacion'.toUpperCase(),
                style: GoogleFonts.patuaOne(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget showReservarButton() {
    return new Column(
      children: <Widget>[
        InkWell(
          child: Container(
            height: 60,
            width: 170,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.indigo),
            child: Text('Reservar'.toUpperCase(),
                style: GoogleFonts.patuaOne(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.white)),
          ),
        )
      ],
    );
  }

  static openMapsSheet(context) async {
    try {
      final coords = Coords(43.375734, -8.433334);
      final availableMaps = await MapLauncher.installedMaps;

      print(availableMaps);

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (var map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                        ),
                        title: Text(map.mapName),
                        leading: Image(
                          image: map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }
}
