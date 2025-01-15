import 'package:ebolnica_desktop/screens/pacijent_list_screen.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String userType;

  const SideBar({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> menuItems = {
      'administrator': [
        {'label': 'Dashboard', 'route': '/dashboard'},
        {'label': 'Doktori', 'route': '/doktori'},
        {
          'label': 'Pacijenti',
          'route': (BuildContext context) => const PacijentListScreen()
        },
        {'label': 'Odjeli', 'route': '/odjeli'},
      ],
      'doktor': [
        {'label': 'Pregledi', 'route': '/pregledi'},
        {'label': 'Pacijenti', 'route': '/pacijenti'},
        {'label': 'Odjeli', 'route': '/odjeli'},
      ],
      'pacijent': [
        {'label': 'Pregledi', 'route': '/pregledi'},
        {'label': 'Terapije', 'route': '/terapije'},
      ],
      'medicinsko osoblje': [
        {'label': 'Odjeli', 'route': '/odjeli'},
        {'label': 'Pregledi', 'route': '/pregledi'},
        {'label': 'Pacijenti', 'route': '/pacijenti'},
      ],
    };
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 20),
              child: Center(
                child: Text(
                  'Dobrodošli, $userType',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
          ...menuItems[userType]!.map((item) {
            return Center(
              child: ListTile(
                title: Text(item['label']!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: item['route']),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
