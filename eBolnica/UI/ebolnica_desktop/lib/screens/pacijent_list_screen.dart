import 'package:ebolnica_desktop/models/pacijent_model.dart';
import 'package:ebolnica_desktop/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:ebolnica_desktop/providers/pacijent_provider.dart';
import 'package:intl/intl.dart';

class PacijentListScreen extends StatefulWidget {
  const PacijentListScreen({super.key});

  @override
  State<PacijentListScreen> createState() => _PacijentListScreenState();
}

class _PacijentListScreenState extends State<PacijentListScreen> {
  late PacijentProvider provider;

  final TextEditingController _imeEditingController = TextEditingController();
  final TextEditingController _prezimeEditingController =
      TextEditingController();
  final TextEditingController _brojKarticeController = TextEditingController();

  SearchResult<Pacijent>? result;

  @override
  void initState() {
    super.initState();
    provider = PacijentProvider();
  }

  String formattedDate(date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista pacijenata"),
      ),
      body: Column(
        children: [
          _buildSearch(),
          _buildResultView(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _imeEditingController,
              decoration: const InputDecoration(labelText: "Ime"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _prezimeEditingController,
              decoration: const InputDecoration(labelText: "Prezime"),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: _brojKarticeController,
              decoration:
                  const InputDecoration(labelText: "Broj zdravstvene kartice"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var filter = {
                'imeGTE': _imeEditingController.text.isNotEmpty
                    ? _imeEditingController.text
                    : null,
                'prezimeGTE': _prezimeEditingController.text.isNotEmpty
                    ? _prezimeEditingController.text
                    : null,
                'brojZdravstveneKartice': _brojKarticeController.text.isNotEmpty
                    ? int.tryParse(_brojKarticeController.text)
                    : null,
              };

              result = await provider.get(filter: filter);
              setState(() {});
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _showAddPatientDialog(context);
            },
            child: const Text("Dodaj"),
          ),
        ],
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Prezime")),
            DataColumn(label: Text("E-mail")),
            DataColumn(label: Text("Broj zdravstvene kartice")),
            DataColumn(label: Text("Telefon")),
            DataColumn(label: Text("Adresa")),
            DataColumn(label: Text("Datum rodjenja")),
            DataColumn(label: Text("Slika")),
          ],
          rows: result?.result
                  .map<DataRow>(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.korisnik!.ime)),
                        DataCell(Text(e.korisnik!.prezime)),
                        DataCell(Text(e.korisnik!.email)),
                        DataCell(Text(e.brojZdravstveneKartice.toString())),
                        DataCell(Text(e.korisnik!.telefon ?? "-")),
                        DataCell(Text(e.adresa ?? "-")),
                        DataCell(
                            Text(formattedDate(e.korisnik!.datumRodjenja))),
                        DataCell(
                          e.slika != null
                              ? SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: Image.memory(
                                    e.slika!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/osoba.jpg',
                                  height: 120,
                                  width: 50,
                                ),
                        )
                      ],
                    ),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }

  Future<void> _showAddPatientDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final imeController = TextEditingController();
    final prezimeController = TextEditingController();
    final emailController = TextEditingController();
    final telefonController = TextEditingController();
    final adresaController = TextEditingController();
    String spol = '';
    DateTime? datumRodjenja;
    String lozinkaPotvrda = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: const Text('Dodaj Novog Pacijenta'),
          content: Container(
            width: 800,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: imeController,
                    decoration: const InputDecoration(labelText: 'Ime'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite ime';
                      }
                      if (value[0] != value[0].toUpperCase()) {
                        return 'Ime mora početi sa velikim slovom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: prezimeController,
                    decoration: const InputDecoration(labelText: 'Prezime'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite prezime';
                      }
                      if (value[0] != value[0].toUpperCase()) {
                        return 'Prezime mora početi sa velikim slovom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Molimo unesite validan email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: telefonController,
                    decoration: const InputDecoration(labelText: 'Telefon'),
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite broj telefona';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: spol.isEmpty ? null : spol,
                    decoration: const InputDecoration(labelText: 'Spol'),
                    items: const [
                      DropdownMenuItem(value: 'Muški', child: Text('Muški')),
                      DropdownMenuItem(value: 'Ženski', child: Text('Ženski')),
                    ],
                    onChanged: (value) {
                      spol = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo odaberite spol';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: adresaController,
                    decoration: const InputDecoration(labelText: 'Adresa'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Molimo unesite adresu';
                      }
                      return null;
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: datumRodjenja ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null && pickedDate != datumRodjenja) {
                        datumRodjenja = pickedDate;
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Datum Rođenja',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: datumRodjenja != null
                              ? '${datumRodjenja!.day}/${datumRodjenja!.month}/${datumRodjenja!.year}'
                              : '',
                        ),
                        validator: (value) {
                          if (datumRodjenja == null) {
                            return 'Molimo unesite datum rođenja';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        String korisnickoIme =
                            imeController.text.trim().toLowerCase();
                        String lozinka = '${imeController.text.trim()}123!';
                        lozinkaPotvrda = lozinka;

                        var noviPacijent = {
                          "ime": imeController.text.trim(),
                          "prezime": prezimeController.text.trim(),
                          "email": emailController.text.trim(),
                          "telefon": telefonController.text.trim(),
                          "adresa": adresaController.text.trim(),
                          "spol": spol,
                          "datumRodjenja": datumRodjenja?.toIso8601String(),
                          "korisnickoIme": korisnickoIme,
                          "lozinka": lozinka,
                          "lozinkaPotvrda": lozinkaPotvrda
                        };
                        try {
                          provider.insert(noviPacijent);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pacijent je uspješno dodan'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Greška pri dodavanju pacijenta'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Dodaj Pacijenta'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
