import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/images/logo0.png',
            width: 300,
            fit: BoxFit.cover,
          ),
          RichText(
            text: TextSpan(
              text: 'WirtZ',
              style: GoogleFonts.righteous(
                fontSize: 35,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],

    );
  }
}
