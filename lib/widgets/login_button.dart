import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final String text;

  LoginButton({Key key, VoidCallback onPressed, this.text})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap:_onPressed,
          child: Container(
            width: 200,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.white),
            child: Text(text,
                style: GoogleFonts.patuaOne(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black)),
          ),
        )
      ],
    );
  }
}
