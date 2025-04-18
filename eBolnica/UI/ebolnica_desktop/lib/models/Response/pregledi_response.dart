class PreglediResponse {
  final int pregledId;
  final int pacijentId;
  final String imeDoktora;
  final String prezimeDoktora;
  final String imePacijenta;
  final String prezimePacijenta;
  final String nazivOdjela;
  final DateTime datumTermina;
  final Duration vrijemeTermina;
  final String glavnaDijagnoza;
  final String anamneza;
  final String zakljucak;

  PreglediResponse({
    required this.pregledId,
    required this.pacijentId,
    required this.imeDoktora,
    required this.prezimeDoktora,
    required this.imePacijenta,
    required this.prezimePacijenta,
    required this.nazivOdjela,
    required this.datumTermina,
    required this.vrijemeTermina,
    required this.glavnaDijagnoza,
    required this.anamneza,
    required this.zakljucak,
  });

  factory PreglediResponse.fromJson(Map<String, dynamic> json) {
    return PreglediResponse(
      pregledId: json['pregledId'] ?? 0,
      pacijentId: json['pacijentId'] ?? 0,
      imeDoktora: json['imeDoktora'] ?? '',
      prezimeDoktora: json['prezimeDoktora'] ?? '',
      imePacijenta: json['imePacijenta'] ?? '',
      nazivOdjela: json['nazivOdjela'] ?? '',
      prezimePacijenta: json['prezimePacijenta'] ?? '',
      datumTermina: DateTime.parse(json['datumTermina']),
      vrijemeTermina: PreglediResponse._parseDuration(json['vrijemeTermina']),
      glavnaDijagnoza: json['glavnaDijagnoza'] ?? '',
      anamneza: json['anamneza'] ?? '',
      zakljucak: json['zakljucak'] ?? '',
    );
  }

  static Duration _parseDuration(String timeString) {
    final parts = timeString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }

  Map<String, dynamic> toJson() {
    return {
      'pregledId': pregledId,
      'pacijentId': pacijentId,
      'imeDoktora': imeDoktora,
      'prezimeDoktora': prezimeDoktora,
      'imePacijenta': imePacijenta,
      'prezimePacijenta': prezimePacijenta,
      'nazivOdjela': nazivOdjela,
      'datumTermina': datumTermina.toIso8601String(),
      'vrijemeTermina':
          '${vrijemeTermina.inHours.toString().padLeft(2, '0')}:${(vrijemeTermina.inMinutes % 60).toString().padLeft(2, '0')}',
      'glavnaDijagnoza': glavnaDijagnoza,
      'anamneza': anamneza,
      'zakljucak': zakljucak,
    };
  }
}
