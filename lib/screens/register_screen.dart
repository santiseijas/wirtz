import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wirtz/bloc/authentication/bloc.dart';
import 'package:wirtz/bloc/register/bloc.dart';
import 'package:wirtz/bloc/register/register_bloc.dart';
import 'package:wirtz/widgets/login_button.dart';

import '../models/user_repository.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        elevation: 0,
      ),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: RegisterForm(),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registering...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Registration Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.indigo[300],
                    Colors.indigo,
                  ],
                  stops: [
                    0.1,
                    6
                  ]),
            ),
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
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
                        ),
                        nombreInput(),
                        emailInput(state),
                        passInput(state),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          alignment: Alignment.center,
                          child: MyButton(
                            onPressed: isRegisterButtonEnabled(state)
                                ? _onFormSubmitted
                                : null,
                            text: 'Registrate',
                          ),
                        ),
                        /*Container(
                            alignment: Alignment.center,
                            child: Text(_success == null
                                ? ''
                                : (_success
                                    ? 'Successfully registered ' + _userEmail
                                    : 'Registration failed')),
                          )*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget nombreInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
      child: Container(
        child: TextFormField(
          controller: _userNameController,
          decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
            ),
            labelText: "Nombre",
            labelStyle :GoogleFonts.crimsonText(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: Colors.white),
          ),
          autovalidate: true,
          autocorrect: false,
          /*validator: (_) {
            return !state.isEmailValid ? 'Invalid Email' : null;
          },*/
        ),
      ),
    );
  }

  Padding emailInput(RegisterState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
      child: Container(
        child: TextFormField(
          controller: _emailController,
          decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
            ),
            labelText: "Email",
            labelStyle:  GoogleFonts.crimsonText(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white),
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

  Padding passInput(RegisterState state) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
        child: Container(
          child: TextFormField(
            controller: _passwordController,
            decoration: new InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.indigo),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusColor: Colors.red,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              labelText: "Contraseña",
              labelStyle:  GoogleFonts.crimsonText(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.white),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
/*    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = _userNameController.text;*/
    _registerBloc.add(
      Submitted(
        nombre: _userNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
