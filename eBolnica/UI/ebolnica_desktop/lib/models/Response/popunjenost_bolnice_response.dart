class PopunjenostBolniceResponse {
  int ukupnoKreveta;
  int zauzetiKreveta;
  int slobodniKreveta;

  PopunjenostBolniceResponse({
    required this.ukupnoKreveta,
    required this.zauzetiKreveta,
    required this.slobodniKreveta,
  });

  factory PopunjenostBolniceResponse.fromJson(Map<String, dynamic> json) {
    return PopunjenostBolniceResponse(
      ukupnoKreveta: json['ukupnoKreveta'],
      zauzetiKreveta: json['zauzetiKreveta'],
      slobodniKreveta: json['slobodniKreveta'],
    );
  }
}
