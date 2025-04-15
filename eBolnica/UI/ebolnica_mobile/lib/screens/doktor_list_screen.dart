import 'dart:convert';

import 'package:ebolnica_mobile/models/doktor_model.dart';
import 'package:ebolnica_mobile/models/odjel_model.dart'; // Import za model odjela
import 'package:ebolnica_mobile/providers/doktor_provider.dart';
import 'package:ebolnica_mobile/providers/odjel_provider.dart'; // Import za provider odjela
import 'package:ebolnica_mobile/providers/pacijent_provider.dart';
import 'package:ebolnica_mobile/screens/novi_termin_screen.dart';
import 'package:ebolnica_mobile/utils/utils.dart';
import 'package:flutter/material.dart';

class DoktoriListScreen extends StatefulWidget {
  final List<Doktor> doktori;
  final int userId;
  final String? userType;
  const DoktoriListScreen(
      {super.key, required this.userId, this.userType, required this.doktori});

  @override
  _DoktorListScreenState createState() => _DoktorListScreenState();
}

class _DoktorListScreenState extends State<DoktoriListScreen> {
  int? pacijentId;
  late DoktorProvider doktorProvider;
  late OdjelProvider odjelProvider;
  List<Odjel> odjeli = [];
  Odjel? odabraniOdjel;

  @override
  void initState() {
    super.initState();
    doktorProvider = DoktorProvider();
    odjelProvider = OdjelProvider();
    fetchOdjeli();
  }

  Future<void> fetchOdjeli() async {
    final odjeliList = await odjelProvider.get();
    setState(() {
      odjeli = odjeliList.result;
      odabraniOdjel = odjeli.isNotEmpty ? odjeli[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Doktori", style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              elevation: 0.4,
              borderRadius: BorderRadius.circular(12),
              child: DropdownButton<Odjel>(
                value: odabraniOdjel,
                onChanged: (Odjel? newOdjel) {
                  setState(() {
                    odabraniOdjel = newOdjel;
                  });
                },
                hint: const Text(
                  "Odaberite odjel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                items: odjeli.map<DropdownMenuItem<Odjel>>((Odjel odjel) {
                  return DropdownMenuItem<Odjel>(
                    value: odjel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Text(
                        odjel.naziv!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                dropdownColor: Colors.grey[50],
                underline: Container(),
              ),
            ),
          ),
          Expanded(child: _buildDoktoriList()),
        ],
      ),
    );
  }

  Widget _buildDoktoriList() {
    final filteredDoktori = widget.doktori.where((doktor) {
      if (odabraniOdjel == null) return true;
      return doktor.odjel?.odjelId == odabraniOdjel?.odjelId;
    }).toList();

    if (filteredDoktori.isEmpty) {
      return const Center(child: Text("Nema doktora za odabrani odjel."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredDoktori.length,
      itemBuilder: (context, index) {
        final doktor = filteredDoktori[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: doktor.korisnik!.slika != null &&
                      doktor.korisnik!.slika!.isNotEmpty
                  ? MemoryImage(base64Decode(doktor.korisnik!.slika!))
                  : const AssetImage('assets/images/osoba.jpg')
                      as ImageProvider,
            ),
            title: Text(
              "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              doktor.specijalizacija ?? 'Specijalizacija nije dostupna',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing:
                const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return _buildDoktorInfo(doktor.doktorId!);
                  });
            },
          ),
        );
      },
    );
  }

  Widget _buildDoktorInfo(int doktorId) {
    return FutureBuilder<Doktor>(
      future: DoktorProvider().getById(doktorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Greška: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Doktor nije pronađen"));
        }

        final doktor = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: doktor.korisnik!.slika != null &&
                        doktor.korisnik!.slika!.isNotEmpty
                    ? Image.memory(
                        base64Decode(doktor.korisnik!.slika!),
                        fit: BoxFit.cover,
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/images/osoba.jpg',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                "${doktor.korisnik!.ime} ${doktor.korisnik!.prezime}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doktor.specijalizacija!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                doktor.biografija ?? 'Nema dostupne biografije',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Godina rođenja: ${formattedDate(doktor.korisnik!.datumRodjenja)}",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Zaposlen na odjelu: ${doktor.odjel!.naziv}",
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  pacijentId = await PacijentProvider()
                      .getPacijentIdByKorisnikId(widget.userId);
                  final result = await showDialog(
                    context: context,
                    builder: (BuildContext context) => NoviTerminScreen(
                      userId: widget.userId,
                      userType: widget.userType,
                      doktor: doktor,
                      odjel: doktor.odjel,
                      pacijentId: pacijentId,
                    ),
                  );

                  if (result == true && context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                ),
                child: const Text(
                  "Zakaži termin",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
