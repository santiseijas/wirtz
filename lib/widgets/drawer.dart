import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/packs_screen.dart';

class MyDrawer extends StatefulWidget {
  final UserRepository userRepository;

  const MyDrawer({Key key, this.userRepository}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Ajustes',onTap: (){getUserName();}
          ),
          _createDrawerItem(
              icon: Icons.note,
              text: 'Packs',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PacksView()));
              }),
          _createDrawerItem(icon: Icons.map, text: 'Mis viajes'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItem(
              icon: Icons.book,
              text: 'guia',
              onTap: () {
//                widget.userRepository.getUserId();
              }),
          _createDrawerItem(icon: Icons.help, text: 'ayuda'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItemLogout(onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          }),
        ],
      ),
    ));
  }

  Widget _createHeader() {
    return DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.indigo,
        ),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/avatar.png',
              fit: BoxFit.fill,
              height: 80,
            ),
            Text('',
                style: GoogleFonts.patuaOne(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.white)),
            Text('Saldo: 0.00€'.toUpperCase(),
                style: GoogleFonts.patuaOne(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.white))
          ],
        ));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.indigo,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text.toUpperCase(),
              style: GoogleFonts.patuaOne(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.indigo),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createDrawerItemLogout({GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Cerrar sesion'.toUpperCase(),
              style: GoogleFonts.patuaOne(
                  fontSize: 15, fontStyle: FontStyle.italic, color: Colors.red),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}

Future<String> getUserName() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseUser user = await _auth.currentUser() ;
  final nombre = user.displayName;
  return nombre;
}
