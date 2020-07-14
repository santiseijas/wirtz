import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wirtz/models/markers_repository.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/upload_screen.dart';
import 'package:wirtz/widgets/appBar.dart';
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
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  AnimationController animationController;
  Duration _duration = Duration(milliseconds: 500);
  String documentId;
  String calle;
  LatLng coords;
  var longitud;
  int bateria;
  int autonomia;
  String matricula;
  String nombre = '';
  String saldo = '';
  bool verificado = false;

  @override
  void initState() {
    _getLocation();
    cargarMarkers();
    cargarDatosUsuario();
    animationController = AnimationController(vsync: this, duration: _duration);

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), 'assets/images/destination_map_marker.png')
        .then((onValue) {
      myIcon = onValue;
    });
  }

  cargarMarkers() {
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; ++i) {
          if (!docs.documents[i].data['reservado'])
            initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    });
  }

  cargarDatosUsuario() async {
    final firestoreInstance = Firestore.instance;
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    firestoreInstance
        .collection("users")
        .document(firebaseUser.uid)
        .get()
        .then((value) {
      nombre = value.data['nombre'];
      saldo = value.data['saldo'];
      verificado = value.data['verificado'];
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
          bateria = request['bateria'];
          autonomia = request['autonomia'];
          matricula = request['matricula'];
          coords =
              LatLng(request['coord'].latitude, request['coord'].longitude);
          if (animationController.isDismissed) animationController.forward();
        });
      },
      consumeTapEvents: true,
      icon: myIcon,
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
            nombre: nombre,
            saldo: saldo,
            userRepository: widget.userRepository,
          ),
          appBar: MyAppBar(),
          body: verificado
              ? Stack(
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
                )
              : SubirImagen(
                  userRepository: widget.userRepository,
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
                    Image.asset(
                      "assets/images/moto.png",
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          calle.toUpperCase(),
                          style: GoogleFonts.patuaOne(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.indigo),
                        ),
                        Text(
                          matricula,
                          style: GoogleFonts.patuaOne(
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                        Row(
                          children: <Widget>[
                            Text(bateria.toString() + '%',
                                style: GoogleFonts.patuaOne(
                                  fontSize: 19,
                                  fontStyle: FontStyle.italic,
                                )),
                            bateria > 50
                                ? IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.batteryFull,
                                      color: Colors.green,
                                    ),
                                  )
                                : IconButton(
                                    icon: FaIcon(
                                      FontAwesomeIcons.batteryHalf,
                                      color: Colors.red,
                                    ),
                                  ),
                            Text(autonomia.toString() + 'km'.toUpperCase(),
                                style: GoogleFonts.patuaOne(
                                  fontSize: 19,
                                  fontStyle: FontStyle.italic,
                                )),
                          ],
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
                          child: ReservarButton(
                                  text: 'Reservar',
                                  callback: () {
                                    reservar();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return MyDialog(
                                            coords: coords,
                                          );
                                        });
                                  },
                                  coords: coords,
                                )

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget widgetBat(BuildContext context) {
    IconButton icono;
    if (bateria >= 90) {
      icono = IconButton(
        icon: FaIcon(
          FontAwesomeIcons.batteryHalf,
          color: Colors.red,
        ),
      );
    } else if (bateria < 89 && bateria > 50) {
      icono = IconButton(
        icon: FaIcon(
          FontAwesomeIcons.batteryThreeQuarters,
          color: Colors.red,
        ),
      );
    } else if (bateria < 49 && bateria > 20) {
      icono = IconButton(
        icon: FaIcon(
          FontAwesomeIcons.batteryQuarter,
          color: Colors.red,
        ),
      );
    } else if (bateria < 0 && bateria > 20) {
      icono = IconButton(
        icon: FaIcon(
          FontAwesomeIcons.batteryEmpty,
          color: Colors.red,
        ),
      );
    }
  }

  Future<String> reservar() async {
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
    return uid;
  }
}
