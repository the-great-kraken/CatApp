import 'package:cat_app/screens/favorites/favorites_page.dart';
import 'package:cat_app/screens/home/view/home_screen.dart';
import 'package:cat_app/screens/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/profile_page.dart';
import '/screens/home/blocs/tab/tab.dart';
import 'package:cat_app/theme.dart';
import '/models/models.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: Home());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: EdgeInsets.only(left: 20), 
              child: activeTab == AppTab.home
              ? const Text('Caaats')
              : (activeTab == AppTab.favorites
                  ? const Text('Favourites')
                  : const Text('Profile')),
            ),
          actions: <Widget>[
            LogoutButton(visible: activeTab == AppTab.profile ? true : false),
          ],
          backgroundColor: theme.primaryColor,
          ),
          body: activeTab == AppTab.home
              ? HomePage()
              : (activeTab == AppTab.favorites
                  ? FavoritesPage()
                  : ProfilePage()),

          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
          ),
        );
      });
  }
}
