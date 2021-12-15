import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../bloc/auth/bloc.dart';

class LogoutButton extends StatelessWidget {
  final bool visible;

  LogoutButton({required this.visible, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var button = IconButton(
      key: const Key('homePage_logout_iconButton'),
      icon: const Icon(Icons.exit_to_app),
      onPressed: () => context.read<AppBloc>().add(
            AppLogoutRequested(),
        ),
    );
    return AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 150),
        child: visible ? button : IgnorePointer(child: button),
      );
  }
}
