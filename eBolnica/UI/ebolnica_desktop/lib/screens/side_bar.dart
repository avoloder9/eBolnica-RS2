import 'package:ebolnica_desktop/screens/pacijent_pregledi_screen.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/screens/dashboard_admin.dart';
import 'package:ebolnica_desktop/screens/doktor_list_screen.dart';
import 'package:ebolnica_desktop/screens/medicinsko_osoblje_list_screen.dart';
import 'package:ebolnica_desktop/screens/odjel_list_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_list_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_termin_list_screen.dart';

class SideBar extends StatelessWidget {
  final String userType;
  final int userId;
  const SideBar({super.key, required this.userType, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color.fromARGB(255, 32, 145, 231)),
            child: Center(
              child: Text(
                'Kantonalna bolnica dr. Safet Mujić',
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (userType == 'administrator') ...[
            _buildListTile(
                context,
                'Bolnica',
                DashboardAdmin(
                  userId: userId,
                )),
            _buildListTile(
                context,
                'Doktori',
                DoktorListScreen(
                  userId: userId,
                )),
            _buildListTile(
                context,
                'Pacijenti',
                PacijentListScreen(
                  userId: userId,
                )),
            _buildListTile(
                context,
                'Odjeli',
                OdjelListScreen(
                  userId: userId,
                )),
            _buildListTile(
                context,
                'Medicinsko osoblje',
                MedicinskoOsobljeListScreen(
                  userId: userId,
                )),
            _buildListTile(context, 'Smjene', '/smjene'),
            _buildListTile(context, 'Pregledi', '/pregledi'),
            _buildListTile(context, 'Izvještaji', '/izvjestaji'),
            _buildListTile(context, 'Postavke', '/postavke'),
            _buildListTile(context, 'Odjava', '/odjava'),
          ] else if (userType == 'doktor') ...[
            _buildListTile(context, 'Pregledi', '/pregledi'),
            _buildListTile(context, 'Pacijenti', '/pacijenti'),
            _buildListTile(context, 'Operacije', '/operacije'),
            _buildListTile(context, 'Hospitalizacije', '/hospitalizacije'),
            _buildListTile(context, 'Postavke', '/postavke'),
            _buildListTile(context, 'Odjava', '/odjava'),
          ] else if (userType == 'pacijent') ...[
            _buildListTile(
                context, 'Medicinska dokumentacija', '/dokumentacija'),
            _buildListTile(context, 'Pregledi', PreglediScreen(userId: userId)),
            _buildListTile(context, 'Termini', TerminiScreen(userId: userId)),
            _buildListTile(context, 'Nalazi', '/nalazi'),
            _buildListTile(context, 'Postavke', '/postavke'),
            _buildListTile(context, 'Odjava', '/odjava'),
          ] else if (userType == 'medicinsko osoblje') ...[
            _buildListTile(context, 'Odjeli', '/odjeli'),
            _buildListTile(context, 'Pregledi', '/pregledi'),
            _buildListTile(context, 'Pacijenti', '/pacijenti'),
            _buildListTile(context, 'Smjene', '/smjene'),
            _buildListTile(context, 'Nalazi', '/nalazi'),
            _buildListTile(context, 'Postavke', '/postavke'),
            _buildListTile(context, 'Odjava', '/odjava'),
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, dynamic route) {
    return ListTile(
      title: Text(title, textAlign: TextAlign.center),
      onTap: () {
        if (route is String) {
          Navigator.pushNamed(context, route);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        }
      },
    );
  }
}
