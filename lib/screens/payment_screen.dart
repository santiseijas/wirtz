import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wirtz/services/stripe.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _textFieldController = TextEditingController();

  onItemPress(
    BuildContext context,
  ) async {
    payViaNewCard(context);
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: '10', currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(appBar: AppBar(
      centerTitle: true,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Wirtz',
          style: GoogleFonts.patuaOne(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.indigo,
    ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 200, 40, 20),
        child: Column(
          children: <Widget>[
            TextFormField(decoration: InputDecoration(hintText: 'Introduce la cantidad'),
              controller: _textFieldController,
              keyboardType: TextInputType.number,
            ),
            Container(
                child: InkWell(
              onTap: () {
                onItemPress(context);
              },
              child: ListTile(
                title: Text('Pay via new card'),
                leading: Icon(Icons.add_circle, color: theme.primaryColor),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
