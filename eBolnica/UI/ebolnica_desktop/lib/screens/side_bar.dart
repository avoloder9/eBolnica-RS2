import 'package:ebolnica_desktop/screens/dashboard_admin.dart';
import 'package:ebolnica_desktop/screens/doktor_list_screen.dart';
import 'package:ebolnica_desktop/screens/medicinsko_osoblje_list_screen.dart';
import 'package:ebolnica_desktop/screens/odjel_list_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_list_screen.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String userType;

  const SideBar({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> menuItems = {
      'administrator': [
        {
          'label': 'Bolnica',
          'route': (BuildContext context) => const DashboardAdmin()
        },
        {
          'label': 'Doktori',
          'route': (BuildContext context) => const DoktorListScreen()
        },
        {
          'label': 'Pacijenti',
          'route': (BuildContext context) => const PacijentListScreen()
        },
        {
          'label': 'Odjeli',
          'route': (BuildContext context) => const OdjelListScreen()
        },
        {
          'label': 'Medicinsko osoblje',
          'route': (BuildContext context) => const MedicinskoOsobljeListScreen()
        },
        {'label': 'Smjene', 'route': '/smjene'},
        {'label': 'Pregledi', 'route': '/pregledi'},
        {'label': 'Izvjestaji', 'route': '/izvjestaji'},
        {'label': 'Postavke', 'route': '/postavke'},
        {'label': 'Odjava', 'route': '/odjava'},
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
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 32, 145, 231)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 18),
              child: const Center(
                child: Text(
                  'Kantonalna bolnica dr. Safet Mujić',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  softWrap: true,
                ),
              ),
            ),
          ),
          ...menuItems[userType]!.map((item) {
            return Center(
              child: ListTile(
                title: Center(child: Text(item['label']!)),
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
