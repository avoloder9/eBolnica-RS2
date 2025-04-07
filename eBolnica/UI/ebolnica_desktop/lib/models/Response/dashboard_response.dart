import 'package:ebolnica_desktop/utils/utils.dart';

class DashboardResponse {
  int brojPregleda;
  int ukupanBrojPacijenata;
  int brojHospitalizovanih;
  int brojOdjela;
  int brojSoba;
  int brojKreveta;
  int brojSlobodnihKreveta;
  int brojZauzetihKreveta;
  int brojKorisnika;
  int brojDoktora;
  int brojOsoblja;
  List<TerminiPoMjesecima> terminiPoMjesecima;

  DashboardResponse({
    required this.brojPregleda,
    required this.ukupanBrojPacijenata,
    required this.brojHospitalizovanih,
    required this.brojOdjela,
    required this.brojSoba,
    required this.brojKreveta,
    required this.brojSlobodnihKreveta,
    required this.brojZauzetihKreveta,
    required this.brojKorisnika,
    required this.brojDoktora,
    required this.brojOsoblja,
    required this.terminiPoMjesecima,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    var terminiList = (json['terminiPoMjesecima'] as List)
        .map((item) => TerminiPoMjesecima.fromJson(item))
        .toList();
    return DashboardResponse(
      brojPregleda: json['brojPregleda'],
      ukupanBrojPacijenata: json['ukupanBrojPacijenata'],
      brojHospitalizovanih: json['brojHospitalizovanih'],
      brojOdjela: json['brojOdjela'],
      brojSoba: json['brojSoba'],
      brojKreveta: json['brojKreveta'],
      brojSlobodnihKreveta: json['brojSlobodnihKreveta'],
      brojZauzetihKreveta: json['brojZauzetihKreveta'],
      brojKorisnika: json['brojKorisnika'],
      brojDoktora: json['brojDoktora'],
      brojOsoblja: json['brojOsoblja'],
      terminiPoMjesecima: terminiList,
    );
  }
}
