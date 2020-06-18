import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/bloc/login/bloc.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/home_screen.dart';

import 'package:wirtz/widgets/login_button.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(userRepository: _userRepository),
        child: LoginForm(userRepository: _userRepository),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  //UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return new Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                elevation: 0,
              ),
              body: Container(
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
                height: double.infinity,
                width: double.infinity,
                child: buildForm(state),
              ));
        },
      ),
    );
  }

  Form buildForm(LoginState state) {
    return Form(
      child: ListView(
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/moto2.png',
                  width: 300,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'WirtZ',
                    style: GoogleFonts.righteous(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
         /* showTitle(),*/
          emailInput(state),
          passInput(state),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginButton(
                  onPressed:
                      isLoginButtonEnabled(state) ? _onFormSubmitted : null,
                  text: 'Login',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showTitle() {
    return Container(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'WirtZ',
          style: GoogleFonts.patuaOne(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Padding emailInput(LoginState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
      child: Container(
        child: TextFormField(
          controller: _emailController,
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
            ),
            labelText: "Email",
            labelStyle: GoogleFonts.crimsonText(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 3.0),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          autovalidate: true,
          autocorrect: false,
          /*validator: (_) {
            return !state.isEmailValid ? 'Invalid Email' : null;
          },*/
        ),
      ),
    );
  }

  Padding passInput(LoginState state) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
        child: Container(
          child: TextFormField(
            controller: _passwordController,
            decoration: new InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              labelText: "Contraseña",
              labelStyle: GoogleFonts.crimsonText(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 3.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            obscureText: true,
            autovalidate: true,
            autocorrect: false,
            /*validator: (_) {
              return !state.isPasswordValid ? 'Invalid Password' : null;
            },*/
          ),
        ));
  }

  Widget showPrimaryButton(LoginState state) {
    return new Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            isLoginButtonEnabled(state) ? _onFormSubmitted : null;
          },
          child: Container(
            width: 200,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Colors.white),
            child: Text('Login',
                style: GoogleFonts.patuaOne(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Colors.black)),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
