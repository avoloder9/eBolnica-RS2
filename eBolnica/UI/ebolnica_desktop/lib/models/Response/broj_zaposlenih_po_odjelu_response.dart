class BrojZaposlenihPoOdjeluResponse {
  int odjelId;
  String nazivOdjela;
  int ukupanBrojZaposlenih;

  BrojZaposlenihPoOdjeluResponse({
    required this.odjelId,
    required this.nazivOdjela,
    required this.ukupanBrojZaposlenih,
  });

  factory BrojZaposlenihPoOdjeluResponse.fromJson(Map<String, dynamic> json) {
    return BrojZaposlenihPoOdjeluResponse(
      odjelId: json['odjelId'],
      nazivOdjela: json['nazivOdjela'],
      ukupanBrojZaposlenih: json['ukupanBrojZaposlenih'],
    );
  }
}
