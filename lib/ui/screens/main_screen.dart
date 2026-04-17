import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../main.dart';
import 'home_screen.dart';
import 'workouts_screen.dart';
import 'progress_screen.dart';
import 'profile_screen.dart';

// Main screen - handles bottom navigation between the 4 screens
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    WorkoutsScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Use CupertinoTabScaffold on iOS, BottomNavigationBar on Android
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: AppColors.accent,
          inactiveColor: AppColors.textMuted,
          backgroundColor: AppColors.card,
          items: const [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.flame_fill), label: 'Workouts'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.chart_bar_fill), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_fill), label: 'Profile'),
          ],
        ),
        tabBuilder: (context, index) => _screens[index],
      );
    }

    // Android - Material Design bottom nav
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}


