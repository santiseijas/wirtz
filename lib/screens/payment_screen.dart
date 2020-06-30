import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/services/stripe.dart';
import 'package:wirtz/widgets/reservar_button.dart';

class PaymentScreen extends StatefulWidget {
  final UserRepository userRepository;
  PaymentScreen({Key key, this.userRepository}) : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  TextEditingController _textFieldController = TextEditingController();
  String amount;
  final globalKey = GlobalKey<ScaffoldState>();

  onItemPress(
    BuildContext context,
  ) async {
    payViaNewCard(context, amount);
  }

  payViaNewCard(BuildContext context, String amount) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Comprobando datos...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: amount, currency: 'EUR');
    await dialog.hide();
    final snackBar = SnackBar(content: Text(response.message),
      duration:
      new Duration(milliseconds: response.success == true ? 1200 : 6000),
    );
    globalKey.currentState.showSnackBar(snackBar);

    widget.userRepository.putSaldoFirebase(amount);
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
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
            TextFormField(
              decoration: InputDecoration(hintText: 'Introduce la cantidad'),
              controller: _textFieldController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 20,
            ),
            ReservarButton(
              text: 'pagar',
              callback: () {
                payViaNewCard(context, _textFieldController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
