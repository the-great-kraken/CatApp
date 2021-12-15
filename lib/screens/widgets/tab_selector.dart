import 'package:cat_app/common/app_keys.dart';
import 'package:cat_app/theme.dart';
import 'package:flutter/material.dart';
import '/models/models.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      key: AppKeys.tabs,
      currentIndex: AppTab.values.indexOf(activeTab),
      showSelectedLabels: true,
      showUnselectedLabels: false,
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.home 
              ? Icons.pets_outlined : (tab == AppTab.favorites 
              ? Icons.favorite : Icons.person),
            key: tab == AppTab.home
                ? AppKeys.homeTab : (tab == AppTab.favorites 
                ? AppKeys.favoritesTab : AppKeys.profileTab),
          ),
          label: tab == AppTab.home
              ? "Home" : (tab == AppTab.favorites
              ? "Favorites" : "Profile"),
        );
      }).toList(),
      selectedItemColor: theme.primaryColor,
    );
  }
}