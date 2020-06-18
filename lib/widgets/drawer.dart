import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/packs_screen.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  UserRepository userRepository;

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
            text: 'Ajustes',
          ),

          _createDrawerItem(
            icon: Icons.note,
            text: 'Packs',onTap: (){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PacksView()),
          );}
          ),
          _createDrawerItem(
              icon: Icons.map, text: 'Mis viajes'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItem(icon: Icons.book, text: 'guia'),
          _createDrawerItem(icon: Icons.help, text: 'ayuda'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItemLogout(
              text: 'Cerrar sesion'),
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
            Text('Santiago Seijas Marante'.toUpperCase(),
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

  Widget _createDrawerItemLogout({String text, BuildContext context}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            color: Colors.red,
            icon: Icon(Icons.exit_to_app),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text.toUpperCase(),
              style: GoogleFonts.patuaOne(
                  fontSize: 15, fontStyle: FontStyle.italic, color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
