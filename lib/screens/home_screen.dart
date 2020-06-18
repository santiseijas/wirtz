import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  final String name;

  const HomePage({Key key, this.name}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Position position;
  BitmapDescriptor myIcon;
  BitmapDescriptor myIcon2;
  final double _initFabHeight = 120.0;
  double _panelHeightOpen;
  double _panelHeightClosed = 60.0;
  double _fabHeight;
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  AnimationController animationController;
  Duration _duration = Duration(milliseconds: 500);

  @override
  void initState() {
    _getLocation();
    populateClients();
    animationController = AnimationController(vsync: this, duration: _duration);

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
    this._fabHeight = _initFabHeight;
  }

  populateClients() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  initMarker(request, requestId) {
    var markeridVal = requestId;
    final MarkerId markerId = MarkerId(markeridVal);
    final Marker marker = Marker(
      onTap: () async {
        if (animationController.isDismissed) animationController.forward();
      },
      consumeTapEvents: true,
      icon: myIcon,
      infoWindow: InfoWindow(
        title: 'PlatformMarker',
        snippet: "Hi I'm a Platform Marker",
      ),
      markerId: markerId,
      position: LatLng(request['coord'].latitude, request['coord'].longitude),
    );
    setState(() {
      markers[markerId] = marker;
    });
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
                text: 'WirtZ',
                style: GoogleFonts.patuaOne(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context)
                        .add(LoggedOut());
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ))
            ],
            backgroundColor: Colors.indigo,
          ),
          body: Stack(
            children: <Widget>[
              _buildGoogleMap(context),
              SizedBox.expand(
                child: SlideTransition(
                  position: _tween.animate(animationController),
                  child: DraggableScrollableSheet(
                    minChildSize: .1,
                    maxChildSize: .6,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(100.0),
                              topRight: const Radius.circular(100.0),
                            )),
                        child: _panel(scrollController),
                      );
                    },
                  ),
                ),
              ),

            ],
          )

          ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return position == null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ))
        : Container(
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
              markers: Set<Marker>.of(markers.values),
            ),
          );
  }



  void _getLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    res == null
        ? CircularProgressIndicator()
        : setState(() {
            position = res;
          });
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
                GestureDetector(
                  onTap: () {
                    if (animationController.isCompleted)
                      animationController.reverse();
                  },
                  child: AnimatedIcon(
                      size: 40,
                      icon: AnimatedIcons.menu_close,
                      progress: animationController),
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
