import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/widgets/dialog.dart';

class ReservarButton extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MyDialog();
                });
          },
          child: Container(padding: EdgeInsets.all(10),
            height: 50,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.88,
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
}