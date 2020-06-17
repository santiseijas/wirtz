import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/models/user_repository.dart';

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
            icon: Icons.contacts,
            text: 'Ajustes',
          ),
          _createDrawerItem(
            icon: Icons.event,
            text: 'Recargar saldo',
          ),
          _createDrawerItem(
            icon: Icons.note,
            text: 'Packs',
          ),
          _createDrawerItem(
              icon: Icons.collections_bookmark, text: 'Mis viajes'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItem(icon: Icons.account_box, text: 'guia'),
          _createDrawerItem(icon: Icons.stars, text: 'ayuda'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItemLogout(
              icon: Icons.bug_report, text: 'Cerrar sesion'),
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

  Widget _createDrawerItemLogout(
      {IconData icon, String text, BuildContext context}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.red,
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
