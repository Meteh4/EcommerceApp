// ignore_for_file: library_private_types_in_public_api

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:shoptral1/Screens/Categories_Screen.dart';
import 'package:shoptral1/Screens/Cart_Screen.dart';
import 'package:shoptral1/Screens/Order_History_Screen.dart';
import 'package:shoptral1/Screens/Settings_Screen.dart';
import '../Widgets/User_Profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Categories(),
    CartScreen(),
    OrderHistoryScreen(),
    const ProfileScreen(),

  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoptraly'),
        backgroundColor: const Color(0xffDAD3C8),
        elevation: 0,
        actions: const [
          UserProfileWidget(),
        ],
      ),
      backgroundColor: const Color(0xffDAD3C8),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 80,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Ana Sayfa'),
            activeColor: Colors.brown,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.shopping_cart),
            title: const Text('Sepet'),
            activeColor: Colors.brown,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.history),
            title: const Text('Siparişler'),
            activeColor: Colors.brown,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.settings),
            title: const Text('Ayarlar'),
            activeColor: Colors.brown,
          ),
        ],
        backgroundColor: const Color(0xffDAD3C8),
        showElevation: true,
        itemCornerRadius: 12,
      ),
    );
  }
}






