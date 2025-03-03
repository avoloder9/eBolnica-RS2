import 'package:ebolnica_mobile/screens/odjel_termini_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_mobile/screens/postavke_screen.dart';

class BottomNavBar extends StatefulWidget {
  final String userType;
  final int userId;
  final String? nazivOdjela;

  const BottomNavBar({
    super.key,
    required this.userType,
    required this.userId,
    this.nazivOdjela,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  List<Widget> _getScreensForUser(String userType) {
    switch (userType) {
      case 'doktor':
        return [
          const Placeholder(),
          const Placeholder(),
          const Placeholder(),
          PostavkeScreen(userId: widget.userId, userType: userType),
        ];
      case 'pacijent':
        return [
          const Placeholder(),
          PacijentScreen(userId: widget.userId, userType: userType),
          const Placeholder(),
          const Placeholder(),
          PostavkeScreen(userId: widget.userId, userType: userType),
        ];
      case 'medicinsko osoblje':
        return [
          OdjelTerminiScreen(
            userId: widget.userId,
            userType: userType,
          ),
          const Placeholder(),
          const Placeholder(),
          const Placeholder(),
          PostavkeScreen(userId: widget.userId, userType: userType),
        ];
      default:
        return [const Placeholder()];
    }
  }

  List<BottomNavigationBarItem> _getNavBarItemsForUser(String userType) {
    switch (userType) {
      case 'doktor':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.biotech), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ];
      case 'pacijent':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.medication), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_services), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ];
      case 'medicinsko osoblje':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.checklist), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ];
      default:
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = _getScreensForUser(widget.userType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 96, 148, 226),
              Colors.blue.shade500
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade300,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (mounted) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            elevation: 0,
            items: _getNavBarItemsForUser(widget.userType),
          ),
        ),
      ),
    );
  }
}
