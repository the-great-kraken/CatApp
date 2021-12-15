import 'dart:convert';

import 'package:auth_repository/auth_repository.dart';
import 'package:cat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';
import 'login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 80),
          Image.asset(
                'assets/images/login_cat.png',
                height: 100,
              ),
          Text(
            "Sign in",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Because everyday is a Caturday",
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 20
            ),
            child: BlocProvider(
              create: (_) =>
                  LoginCubit(context.read<AuthenticationRepository>()),
              child: const LoginForm(),
            ),
          ),
        ]),
      ),
      ),
    );
  }
}
