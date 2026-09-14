import 'package:flutter/material.dart';

class NavItemData {
  const NavItemData({
    required this.icon,
    required this.selectedIcon,
    required this.title,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String title;
}

const List<NavItemData> navBarItems = [
  NavItemData(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    title: 'Home',
  ),
  NavItemData(
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view,
    title: 'Categories',
  ),
  NavItemData(
    icon: Icons.shopping_bag_outlined,
    selectedIcon: Icons.shopping_bag,
    title: 'Cart',
  ),
  NavItemData(
    icon: Icons.favorite_border,
    selectedIcon: Icons.favorite,
    title: 'Favorites',
  ),
];
