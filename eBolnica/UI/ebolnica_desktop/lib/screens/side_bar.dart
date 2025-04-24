import 'package:ebolnica_desktop/main.dart';
import 'package:ebolnica_desktop/screens/doktor_termini_screen.dart';
import 'package:ebolnica_desktop/screens/hospitalizacija_screen.dart';
import 'package:ebolnica_desktop/screens/nalazi_screen.dart';
import 'package:ebolnica_desktop/screens/operacije_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_nalazi_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_pregledi_screen.dart';
import 'package:ebolnica_desktop/screens/pacijent_terapija_list_screen.dart';
import 'package:ebolnica_desktop/screens/parametri_list_screen.dart';
import 'package:ebolnica_desktop/screens/postavke_screen.dart';
import 'package:ebolnica_desktop/screens/odjel_termini_screen.dart';
import 'package:ebolnica_desktop/screens/doktor_pregledi_screen.dart';
import 'package:ebolnica_desktop/screens/pregledi_list_screen.dart';
import 'package:ebolnica_desktop/screens/raspored_smjena_screen.dart';
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
  final String? nazivOdjela;

  const SideBar({
    super.key,
    required this.userType,
    required this.userId,
    this.nazivOdjela,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 145, 231),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_hospital, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'eBolnica',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          if (userType == 'administrator') ...[
            _buildListTile(
                context,
                'Bolnica',
                DashboardAdmin(userId: userId, userType: userType),
                Icons.local_hospital),
            _buildListTile(
                context,
                'Doktori',
                DoktorListScreen(userId: userId, userType: userType),
                Icons.medical_services),
            _buildListTile(
                context,
                'Pacijenti',
                PacijentListScreen(userId: userId, userType: userType),
                Icons.people),
            _buildListTile(
                context,
                'Odjeli',
                OdjelListScreen(userId: userId, userType: userType),
                Icons.account_tree),
            _buildListTile(
                context,
                'Medicinsko osoblje',
                MedicinskoOsobljeListScreen(userId: userId, userType: userType),
                Icons.badge),
            _buildListTile(
                context,
                'Smjene',
                RasporedSmjenaScreen(userId: userId, userType: userType),
                Icons.schedule),
            _buildListTile(
                context,
                'Pregledi',
                PreglediListScreen(userId: userId, userType: userType),
                Icons.assignment),
            _buildListTile(
                context,
                'Parametri',
                ParametriListScreen(userId: userId, userType: userType),
                Icons.analytics),
            _buildListTile(
                context,
                'Postavke',
                PostavkeScreen(userId: userId, userType: userType),
                Icons.settings),
            _buildListTile(
                context, 'Odjava', const LoginScreen(), Icons.logout),
          ] else if (userType == 'doktor') ...[
            _buildListTile(
                context,
                'Zakazani termini',
                DoktorTerminiScreen(userId: userId, nazivOdjela: nazivOdjela),
                Icons.event_available),
            _buildListTile(
                context,
                'Historija pregleda',
                DoktorPreglediScreen(userId: userId, nazivOdjela: nazivOdjela),
                Icons.history),
            _buildListTile(
                context,
                'Pacijenti',
                PacijentListScreen(
                    userId: userId,
                    userType: userType,
                    nazivOdjela: nazivOdjela),
                Icons.people),
            if (nazivOdjela == "Hirurgija")
              _buildListTile(
                  context,
                  'Operacije',
                  OperacijaScreen(
                      userId: userId,
                      userType: userType,
                      nazivOdjela: nazivOdjela),
                  Icons.local_activity),
            _buildListTile(
                context,
                'Hospitalizacije',
                HospitalizacijaScreen(
                    userId: userId,
                    userType: userType,
                    nazivOdjela: nazivOdjela),
                Icons.hotel),
            _buildListTile(
                context,
                'Postavke',
                PostavkeScreen(
                    userId: userId,
                    userType: userType,
                    nazivOdjela: nazivOdjela),
                Icons.settings),
            _buildListTile(
                context, 'Odjava', const LoginScreen(), Icons.logout),
          ] else if (userType == 'pacijent') ...[
            _buildListTile(
                context,
                'Pregledi',
                PacijentPreglediScreen(userId: userId, userType: userType),
                Icons.assignment),
            _buildListTile(
                context,
                'Termini',
                TerminiScreen(userId: userId, userType: userType),
                Icons.calendar_today),
            _buildListTile(
                context,
                'Terapije',
                TerapijaScreen(userId: userId, userType: userType),
                Icons.healing),
            _buildListTile(
                context,
                'Nalazi',
                PacijentNalaziScreen(userId: userId, userType: userType),
                Icons.description),
            _buildListTile(
                context,
                'Postavke',
                PostavkeScreen(userId: userId, userType: userType),
                Icons.settings),
            _buildListTile(
                context, 'Odjava', const LoginScreen(), Icons.logout),
          ] else if (userType == 'medicinsko osoblje') ...[
            _buildListTile(
                context,
                'Odjeli',
                OdjelListScreen(userId: userId, userType: userType),
                Icons.account_tree),
            _buildListTile(
                context,
                'Termini',
                OdjelTerminiScreen(userId: userId, userType: userType),
                Icons.event_note),
            _buildListTile(
                context,
                'Pacijenti',
                PacijentListScreen(userId: userId, userType: userType),
                Icons.people),
            _buildListTile(
                context,
                'Smjene',
                RasporedSmjenaScreen(userId: userId, userType: userType),
                Icons.schedule),
            _buildListTile(
                context,
                'Nalazi',
                NalaziScreen(userId: userId, userType: userType),
                Icons.description),
            _buildListTile(
                context,
                'Postavke',
                PostavkeScreen(userId: userId, userType: userType),
                Icons.settings),
            _buildListTile(
                context, 'Odjava', const LoginScreen(), Icons.logout),
          ],
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, dynamic route, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
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
