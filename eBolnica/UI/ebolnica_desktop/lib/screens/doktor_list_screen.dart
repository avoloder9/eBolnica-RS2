import 'dart:convert';
import 'dart:typed_data';

import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/novi_doktor_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';
import 'package:flutter/widgets.dart';

class DoktorListScreen extends StatefulWidget {
  final int userId;
  final String? userType;
  const DoktorListScreen({super.key, required this.userId, this.userType});

  @override
  _DoktorListScreenState createState() => _DoktorListScreenState();
}

class _DoktorListScreenState extends State<DoktorListScreen> {
  late DoktorProvider _doktorProvider;
  late OdjelProvider _odjelProvider;
  List<Doktor> doktori = [];
  List<Doktor> filteredDoctors = [];
  List<Odjel> odjeli = [];
  String searchQuery = '';
  int? selectedOdjelId;
  bool isLoading = true;
  SearchResult<Doktor>? result;

  @override
  void initState() {
    super.initState();
    _doktorProvider = DoktorProvider();
    _odjelProvider = OdjelProvider();
    fetchDoctors();
    fetchOdjeli();
  }

  Future<void> fetchDoctors() async {
    try {
      final result = await _doktorProvider.get();
      setState(() {
        doktori = result.result;
        filteredDoctors = result.result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dohvaćanju doktora: $e')),
      );
    }
  }

  Future<void> fetchOdjeli() async {
    try {
      final result = await _odjelProvider.get();
      setState(() {
        odjeli = result.result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška pri dohvaćanju odjela: $e')),
      );
    }
  }

  void filterDoctors(String query) {
    final lowerQuery = query.toLowerCase().trim();
    final results = doktori.where((doktor) {
      final ime = doktor.korisnik?.ime!.toLowerCase() ?? '';
      final prezime = doktor.korisnik?.prezime!.toLowerCase() ?? '';
      final specijalizacija = doktor.specijalizacija?.toLowerCase() ?? '';

      final matchesSearchQuery = (specijalizacija.startsWith(lowerQuery) ||
          '$ime $prezime'.startsWith(lowerQuery) ||
          '$prezime $ime'.startsWith(lowerQuery));

      final matchesOdjel =
          selectedOdjelId == null || doktor.odjelId == selectedOdjelId;
      return matchesSearchQuery && matchesOdjel;
    }).toList();

    setState(() {
      searchQuery = query;
      filteredDoctors = results;
    });
  }

  void selectOdjel(int? odjelId) {
    setState(() {
      selectedOdjelId = odjelId;
    });
    filterDoctors(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) => filterDoctors(value),
          decoration: const InputDecoration(
            hintText: 'Pretraga doktora...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return NoviDoktorScreen(
                      userId: widget.userId,
                      userType: widget.userType,
                    );
                  },
                  barrierDismissible: false);
            },
            label: const Text("Dodaj novog doktora"),
          ),
        ],
      ),
      drawer: SideBar(
        userType: widget.userType!,
        userId: widget.userId,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (odjeli.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Wrap(
                        spacing: 8.0,
                        children: odjeli.map((odjel) {
                          return ChoiceChip(
                            label: FittedBox(
                              child: Text(odjel.naziv ?? 'Nepoznati odjel'),
                            ),
                            selected: selectedOdjelId == odjel.odjelId,
                            onSelected: (isSelected) {
                              selectOdjel(isSelected ? odjel.odjelId : null);
                            },
                            backgroundColor: Colors.blue[100],
                            selectedColor: Colors.blue[300],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                const Divider(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 1400 ? 4 : 3;
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.9,
                        ),
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];

                          return DoktorCard(
                            ime: doctor.korisnik?.ime ?? 'Nepoznato',
                            prezime: doctor.korisnik?.prezime ?? 'Nepoznato',
                            specijalizacija: doctor.specijalizacija ??
                                'Nepoznata specijalizacija',
                            slika: (doctor.korisnik!.slika != null &&
                                    doctor.korisnik!.slika!.isNotEmpty)
                                ? base64Decode(doctor.korisnik!.slika!)
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class DoktorCard extends StatelessWidget {
  final String ime;
  final String prezime;
  final String specijalizacija;
  final Uint8List? slika;
  const DoktorCard(
      {required this.ime,
      required this.specijalizacija,
      required this.prezime,
      this.slika,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 5,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: slika != null && slika!.isNotEmpty
                      ? Image(
                          image: MemoryImage(slika!),
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage('assets/images/osoba.jpg'),
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '$ime $prezime',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              specijalizacija,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
