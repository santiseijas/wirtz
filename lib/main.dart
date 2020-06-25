import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wirtz/bloc/authentication/authentication_bloc.dart';
import 'package:wirtz/bloc/simple_bloc_delegate.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/screens/home_screen.dart';
import 'package:wirtz/screens/intro.dart';

import 'bloc/authentication/bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        // ignore: missing_return
        builder: (context, state) {

          if (state is Unauthenticated) {
            return Intro(userRepository: _userRepository,);
          }
          if (state is Authenticated) {
            return HomePage(userRepository: _userRepository,);
          }

        },
      ),
    );
  }
}
