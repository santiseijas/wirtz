import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/splash_screen.dart';


class Intro extends StatefulWidget {
  final UserRepository _userRepository;
  Intro({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 1),
            () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen(userRepository: _userRepository,))));
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[300],
                  Colors.indigo,
                ],
                stops: [
                  0.1,
                  6
                ]),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/motoAzul2.png',
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
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
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                ],
              ),
            )
          ],
        )
      ],

    );
  }
}
