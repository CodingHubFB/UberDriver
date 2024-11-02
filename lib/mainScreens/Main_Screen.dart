import 'package:flutter/material.dart';
import 'package:uber_driver/tabPages/Earnings_Tab.dart';
import 'package:uber_driver/tabPages/Home_Tab.dart';
import 'package:uber_driver/tabPages/Profile_Tab.dart';
import 'package:uber_driver/tabPages/Ratings_Tab.dart';
import 'package:uicons/uicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    int currentIndex = 0;
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeTab(),
          EarningsTab(),
          RatingsTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          setState(() {currentIndex = val;});
          pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey.shade200,
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey.shade400,
      items: [
        BottomNavigationBarItem(icon: Icon(UIcons.regularRounded.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(UIcons.regularRounded.earnings), label: "Earnings"),
        BottomNavigationBarItem(icon: Icon(UIcons.regularRounded.star), label: "Ratings"),
        BottomNavigationBarItem(icon: Icon(UIcons.regularRounded.user), label: "Account"),
      ]),
    );
  }
}