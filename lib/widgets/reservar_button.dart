import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReservarButton extends StatelessWidget {
  final LatLng coords;
  final VoidCallback callback;

  const ReservarButton({
    Key key,
    this.coords,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: callback,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.88,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.indigo),
            child: Text('reservar'.toUpperCase(),
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
}
