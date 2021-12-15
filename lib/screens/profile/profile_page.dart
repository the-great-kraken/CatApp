import 'package:cat_app/screens/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/bloc.dart';
import '/screens/home/blocs/tab/tab.dart';
import '/models/models.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 130),
              Avatar(photo: user.photo),
              const SizedBox(height: 24),
              Text(user.email ?? '', style: textTheme.headline6),
              const SizedBox(height: 24),
              Text(user.name ?? '', style: textTheme.headline5),
              const SizedBox(height: 50),
               ElevatedButton(
                key: const Key('logout_raisedButton'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.orangeAccent,
                ),
                onPressed: () => context.read<AppBloc>().add(
                  AppLogoutRequested(),
                ),
                child: const Text('LOG OUT'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
