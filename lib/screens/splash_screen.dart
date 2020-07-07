import 'package:flutter/material.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/register_screen.dart';
import 'package:wirtz/widgets/login_button.dart';
import 'package:wirtz/widgets/logo.dart';

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
            Logo(),
            SizedBox(
              height:30,
            ),
            MyButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(
                              userRepository: _userRepository,
                            )));
              },
              text: 'Login',
            ),SizedBox(height: 10,),
            MyButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                              userRepository: _userRepository,
                            )));
              },
              text: 'Registrate',
            )
          ],
        ),
      ),
    );
  }
}
