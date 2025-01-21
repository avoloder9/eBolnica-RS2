import 'package:ebolnica_desktop/models/odjel_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:ebolnica_desktop/providers/odjel_provider.dart';
import 'package:ebolnica_desktop/screens/novi_doktor_screen.dart';
import 'package:ebolnica_desktop/screens/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/models/doktor_model.dart';
import 'package:ebolnica_desktop/providers/doktor_provider.dart';

class DoktorListScreen extends StatefulWidget {
  const DoktorListScreen({super.key});

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
    final results = doktori.where((doctor) {
      final ime = doctor.korisnik?.ime.toLowerCase();
      final prezime = doctor.korisnik?.prezime.toLowerCase();

      final specijalizacija = doctor.specijalizacija?.toLowerCase();
      final matchesSearchQuery =
          (ime?.contains(query.toLowerCase()) ?? false) ||
              (prezime?.contains(query.toLowerCase()) ?? false) ||
              (specijalizacija?.contains(query.toLowerCase()) ?? false);

      final matchesOdjel =
          selectedOdjelId == null || doctor.odjelId == selectedOdjelId;
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
                    return const NoviDoktorScreen();
                  },
                  barrierDismissible: false);
            },
            label: const Text("Dodaj novog doktora"),
          ),
        ],
      ),
      drawer: const SideBar(userType: 'administrator'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (odjeli.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: odjeli.map((odjel) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(odjel.naziv ?? 'Nepoznati odjel'),
                              selected: selectedOdjelId == odjel.odjelId,
                              onSelected: (isSelected) {
                                selectOdjel(isSelected ? odjel.odjelId : null);
                              },
                              backgroundColor: Colors.blue[100],
                              selectedColor: Colors.blue[300],
                            ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.8,
                        ),
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          final doctor = filteredDoctors[index];
                          return DoktorCard(
                            ime: doctor.korisnik?.ime ?? 'Nepoznato',
                            prezime: doctor.korisnik?.prezime ?? 'Nepoznato',
                            specijalizacija: doctor.specijalizacija ??
                                'Nepoznata specijalizacija',
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
  const DoktorCard(
      {required this.ime,
      required this.specijalizacija,
      required this.prezime,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/osoba.jpg'),
            ),
            const SizedBox(height: 20),
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
