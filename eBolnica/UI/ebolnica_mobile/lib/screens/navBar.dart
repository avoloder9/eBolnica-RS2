import 'package:ebolnica_mobile/screens/dnevni_raspored_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_mobile/screens/hospitalizacije_list_screen.dart';
import 'package:ebolnica_mobile/screens/odjel_termini_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_nalazi_screen.dart';
import 'package:ebolnica_mobile/screens/pacijent_screen.dart';
import 'package:ebolnica_mobile/screens/radni_zadatak_screen.dart';
import 'package:ebolnica_mobile/screens/raspored_smjena_screen.dart';
import 'package:ebolnica_mobile/screens/terapije_list_screen.dart';
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

  List<Widget> _getScreensForUser() {
    switch (widget.userType) {
      case 'doktor':
        return [
          HospitalizacijaListScreen(
              userId: widget.userId,
              userType: widget.userType,
              nazivOdjela: widget.nazivOdjela),
          DnevniRasporedScreen(
            userId: widget.userId,
            userType: widget.userType,
            nazivOdjela: widget.nazivOdjela,
          ),
          RadniZadatakScreen(
              userId: widget.userId,
              userType: widget.userType,
              nazivOdjela: widget.nazivOdjela),
          PostavkeScreen(
            userId: widget.userId,
            userType: widget.userType,
            nazivOdjela: widget.nazivOdjela,
          ),
        ];
      case 'pacijent':
        return [
          const Placeholder(),
          PacijentScreen(userId: widget.userId, userType: widget.userType),
          PacijentNalaziScreen(
              userId: widget.userId, userType: widget.userType),
          PacijentTerapijaScreen(
              userId: widget.userId, userType: widget.userType),
          PostavkeScreen(userId: widget.userId, userType: widget.userType),
        ];
      case 'medicinsko osoblje':
        return [
          OdjelTerminiScreen(userId: widget.userId, userType: widget.userType),
          RasporedSmjenaScreen(
              userId: widget.userId, userType: widget.userType),
          HospitalizacijaListScreen(
              userId: widget.userId,
              userType: widget.userType,
              nazivOdjela: widget.nazivOdjela),
          RadniZadatakScreen(
              userId: widget.userId,
              userType: widget.userType,
              nazivOdjela: widget.nazivOdjela),
          PostavkeScreen(userId: widget.userId, userType: widget.userType),
        ];
      default:
        return [const Placeholder()];
    }
  }

  List<BottomNavigationBarItem> _getNavBarItemsForUser() {
    switch (widget.userType) {
      case 'doktor':
        return const [
          BottomNavigationBarItem(icon: Icon(Icons.local_hospital), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: ''),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Postavke'),
        ];
      default:
        return const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = _getScreensForUser();

    return Scaffold(
      body: Stack(
        children: List.generate(screens.length, (index) {
          return Offstage(
            offstage: _selectedIndex != index,
            child: screens[index],
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
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
          items: _getNavBarItemsForUser(),
        ),
      ),
    );
  }
}
