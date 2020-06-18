import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/main.dart';
import 'package:wirtz/screens/payment_screen.dart';
import 'package:wirtz/util/theme.dart';
import 'package:wirtz/widgets/login_button.dart';

class PacksView extends StatelessWidget {
  const PacksView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: <Widget>[
            Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text('Saldo: 0.00€'.toUpperCase(),
                      style: GoogleFonts.patuaOne(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          color: Colors.black)),
                )),
            Container(
              child: buildGridView(context),
            )
          ],
        ));
  }

  Column buildGridView(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            buildCards(context, Colors.green, Colors.green[300], 'basic', 10),
            buildCards(context, Colors.deepPurple, Colors.deepPurpleAccent,
                'cool', 20),
          ],
        ),
        Row(
          children: <Widget>[
            buildCards(context, Colors.red, Colors.red[200], 'crazy', 30),
            buildCards(
                context, Colors.amber[600], Colors.amber[300], 'gold', 40)
          ],
        )
      ],
    );
  }

  InkWell buildCards(
      BuildContext context, Color color, Color color2, String title, int cost) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentScreen()),
        );
      },
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 2.2,
              height: 200,
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color, color2],
                    stops: [0.1, 6]),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(54.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 16, right: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.patuaOne(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Divider(
                      thickness: 4,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '$cost minutos',
                        style: GoogleFonts.patuaOne(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '$cost€',
                      style: GoogleFonts.patuaOne(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
