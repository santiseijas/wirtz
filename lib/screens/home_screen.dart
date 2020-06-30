import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wirtz/models/markers_repository.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/widgets/dialog.dart';
import 'package:wirtz/widgets/drawer.dart';
import 'package:wirtz/widgets/reservar_button.dart';

class HomePage extends StatefulWidget {
  final String name;
  final UserRepository userRepository;

  const HomePage({Key key, this.name, this.userRepository}) : super(key: key);

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
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  AnimationController animationController;
  Duration _duration = Duration(milliseconds: 500);
  String documentId;
  String calle;
  LatLng coords;
  var longitud;

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
        ImageConfiguration(), 'assets/images/destination_map_marker.png')
        .then((onValue) {
      myIcon2 = onValue;
    });
  }

  populateClients() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (!docs.documents[i].data['reservado'])
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
        setState(() {
          documentId = markeridVal.toString();
          calle = request['calle'];
          coords =
              LatLng(request['coord'].latitude, request['coord'].longitude);
          if (animationController.isDismissed) animationController.forward();
        });
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
    return Material(
      child: Scaffold(
          drawer: MyDrawer(
            userRepository: widget.userRepository,
          ),
          appBar: AppBar(
            centerTitle: true,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Wirtz',
                style: GoogleFonts.patuaOne(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: Colors.indigo,
          ),
          body: Stack(
            children: <Widget>[
              _buildGoogleMap(context),
              SizedBox.expand(
                child: SlideTransition(
                  position: _tween.animate(animationController),
                  child: DraggableScrollableSheet(
                    initialChildSize: .30,
                    minChildSize: .1,
                    maxChildSize: .30,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(30.0),
                              topRight: const Radius.circular(30.0),
                            )),
                        child: _panel(scrollController, documentId),
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
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
          zoom: 15,
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

  Widget _panel(ScrollController sc, String documentId) {
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
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/moto.png",
                          height: 120,
                          width: 120,
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          calle.toUpperCase(),
                          style: GoogleFonts.patuaOne(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.indigo),
                        ),
                        Container(
                          child: Row(
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
                              Text('35 km'.toUpperCase(),
                                  style: GoogleFonts.patuaOne(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: ReservarButton(text: 'Reservar',
                              callback: () {
                                inputData();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyDialog(
                                        coords: coords,
                                      );
                                    });
                              },
                              coords: coords,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    final String email = user.email;
    print(email);
/*
    final String name = user.displayName;
*/
/*    print(user.uid.toString());
    print(user.email.toString());*/
    MarkersRepository.updateMarkers(documentId, uid, true);
/*
    UserRepository.updateUser(id, uid);
*/
    setState(() {});
    return uid;
  }
}
