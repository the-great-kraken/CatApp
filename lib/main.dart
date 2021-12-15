import 'package:auth_repository/auth_repository.dart';
import 'package:cat_app/screens/home/blocs/tab/tab_bloc.dart';
import 'package:cat_app/screens/home/view/home_page.dart';
import 'package:cat_app/screens/login/view/login_page.dart';
import 'package:cat_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth/bloc.dart';
import 'bloc/cat_facts/bloc.dart';
import 'bloc/cat_images/bloc.dart';
import 'bloc/cat_likes/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final authenticationRepository = AuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authenticationRepository.user.first,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: Text('Error connecting to firebase'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<CatsBloc>(
                    create: (context) => CatsBloc()..add(InitialCats())),
                BlocProvider(
                  create: (_) => AppBloc(
                    authenticationRepository: authenticationRepository,
                  ),
                ),
                BlocProvider<TabBloc>(create: (context) => TabBloc()),
                BlocProvider<LikeBloc>(create: (context) => LikeBloc()),
                BlocProvider<CatFactsBloc>(
                    create: (context) => CatFactsBloc()..add(FactsLoaded())),
              ],
              child: BlocBuilder<AppBloc, AppState>(
                  buildWhen: (previous, current) {
                return true;
              }, builder: (context, state) {
                if (authenticationRepository.currentUser.isNotEmpty) {
                  return MaterialApp(
                    theme: theme,
                    title: 'Cats App',
                    home: Home(),
                  );
                } else {
                  return RepositoryProvider.value(
                    value: authenticationRepository,
                    child: BlocProvider(
                      create: (_) => AppBloc(
                        authenticationRepository: authenticationRepository,
                      ),
                      child: const MaterialApp(
                        title: 'Cats App',
                        home: LoginPage(),
                      ),
                    ),
                  );
                }
              }),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}