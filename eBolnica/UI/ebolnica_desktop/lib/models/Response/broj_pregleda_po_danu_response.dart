class BrojPregledaPoDanuResponse {
  DateTime datum;
  int brojPregleda;

  BrojPregledaPoDanuResponse({
    required this.datum,
    required this.brojPregleda,
  });

  factory BrojPregledaPoDanuResponse.fromJson(Map<String, dynamic> json) {
    return BrojPregledaPoDanuResponse(
      datum: DateTime.parse(json['datum']),
      brojPregleda: json['brojPregleda'],
    );
  }
}
