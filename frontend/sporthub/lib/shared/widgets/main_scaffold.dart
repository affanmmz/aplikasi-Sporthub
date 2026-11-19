import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/booking/presentation/venue_list_screen.dart';
import '../../features/community/presentation/community_radar_screen.dart';
import '../../features/challenge/presentation/challenge_board_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    VenueListScreen(),
    CommunityRadarScreen(),
    ChallengeBoardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          border: Border(top: BorderSide(color: Color(0xFF521A10), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.cardSurface,
          selectedItemColor: AppColors.primaryRed,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.stadium_rounded), label: 'Lapangan'),
            BottomNavigationBarItem(icon: Icon(Icons.radar_rounded), label: 'Komunitas'),
            BottomNavigationBarItem(icon: Icon(Icons.sports_kabaddi_rounded), label: 'Lawan'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}