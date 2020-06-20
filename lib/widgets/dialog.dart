import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:wirtz/screens/home_screen.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    const double padding = 16.0;
    const double avatarRadius = 50.0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.indigo,
      child: Stack(
        children: <Widget>[
          Container(height: 230,
            padding: EdgeInsets.only(
              top: avatarRadius + padding,
              bottom: padding,
              left: padding,
              right: padding,
            ),
            margin: EdgeInsets.only(top: avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'Has reservado la moto, pulsa el boton para iniciar nevagación'.toUpperCase(),textAlign: TextAlign.center,
                    style: GoogleFonts.patuaOne(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: Colors.black)
                ),
                SizedBox(height: 70.0),


                Align(
                    alignment: Alignment.bottomCenter, child: showNavigationButton()),
              ],
            ),
          ),
          Positioned(
            left: padding,
            right: padding,
            child: CircleAvatar(child: Image.asset(
              "assets/images/moto.png",
              height: 200,
              width: 150,
            ),
              backgroundColor: Colors.indigo,
              radius: avatarRadius,
            ),
          ),
        ],
      ),
    );
  }

  Widget showNavigationButton() {
    return new Column(
      children: <Widget>[
        InkWell(
          onTap: () => openMapsSheet(context),
          child: Container(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.indigo),
            child: Text('llevame a la moto'.toUpperCase(),
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
