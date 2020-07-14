import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/upload_screen.dart';
import 'package:wirtz/screens/payment_screen.dart';
import 'package:wirtz/util/util.dart';

class MyDrawer extends StatefulWidget {
  final UserRepository userRepository;
  final String nombre;
  final String saldo;

  const MyDrawer({Key key, this.userRepository, this.saldo, this.nombre})
      : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    //getCurrentUser();

    return Drawer(
        child: Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.settings, text: 'Ajustes', onTap: () {}),
          _createDrawerItem(
              icon: Icons.note,
              text: 'Recargar Saldo',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                              userRepository: widget.userRepository,
                            )));
              }),
          _createDrawerItem(icon: Icons.map, text: 'Mis viajes'),
          Divider(
            color: Colors.indigo,
          ),
          _createDrawerItem(icon: Icons.book, text: 'guia', onTap: () {}),
          _createDrawerItem(icon: Icons.book, text: 'ayuda', onTap: () {}),
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
            Text(
                widget.nombre.toUpperCase() ??
                    "Nombre Desconocido".toUpperCase(),
                style: GoogleFonts.patuaOne(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.white)),
            Text('Saldo:' + widget.saldo + '€'.toUpperCase(),
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

  /* getCurrentUser() async {
    final firestoreInstance = Firestore.instance;
    var firebaseUser = await FirebaseAuth.instance.currentUser();

    firestoreInstance
        .collection("users")
        .document(firebaseUser.uid)
        .get()
        .then((value) {
      widget.nombre = value.data['nombre'];
      widget.saldo = value.data['saldo'];
    });
  }*/
}
