import 'package:flutter/material.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/home_screen.dart';
import 'package:wirtz/services/stripe.dart';
import 'package:wirtz/widgets/appBar.dart';
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
    var response =
        await StripeService.payWithNewCard(amount: amount, currency: 'EUR');
    if (!response.success) {
      final snackBar = SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: 5000),
        backgroundColor: Colors.red,
      );
      globalKey.currentState.showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: 5000),
        backgroundColor: Colors.indigoAccent,
      );
      globalKey.currentState.showSnackBar(snackBar);
      widget.userRepository.putSaldoFirebase(amount);
    }
/*
    final snackBar = SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 6000),
      backgroundColor:
          response.success == true ? Colors.indigoAccent : Colors.red,
    );
    globalKey.currentState.showSnackBar(snackBar);
    if (response.success) {
      //TODO
      widget.userRepository.putSaldoFirebase(amount);

  }*/
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
      appBar: MyAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userRepository:widget.userRepository,)),
            );          },
        ),
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
