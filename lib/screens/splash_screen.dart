import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/register_screen.dart';
import 'package:wirtz/util/util.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final UserRepository _userRepository;

  SplashScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.indigo,
                Colors.indigo[300],
              ],
              stops: [
                0.1,
                6
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 150,
            ),
            Image.asset(
              'assets/images/moto4.png',
              width: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 150,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen(userRepository: _userRepository,)));
              },
              child: Container(
                width: 200,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white),
                child: Text(
                  'Login',
                  style: GoogleFonts.crimsonText(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Util()));
              },
              child: Container(
                height: 60,
                width: 200,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Text(
                  'Registrate',
                  style: GoogleFonts.crimsonText(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
