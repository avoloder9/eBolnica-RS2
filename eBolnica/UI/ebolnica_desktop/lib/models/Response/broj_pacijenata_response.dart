class BrojPacijenataResponse {
  int ukupanBrojPacijenata;
  int brojHospitalizovanih;

  BrojPacijenataResponse({
    required this.ukupanBrojPacijenata,
    required this.brojHospitalizovanih,
  });
  factory BrojPacijenataResponse.fromJson(Map<String, dynamic> json) {
    return BrojPacijenataResponse(
      ukupanBrojPacijenata: json['ukupanBrojPacijenata'],
      brojHospitalizovanih: json['brojHospitalizovanih'],
    );
  }
}
