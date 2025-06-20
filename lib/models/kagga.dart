class Kagga {
  final int id;
  final String kaggaKn;
  final String? kaggaLatn;
  final String? kaggaEn;

  Kagga({
    required this.id,
    required this.kaggaKn,
    this.kaggaLatn,
    this.kaggaEn,
  });

  factory Kagga.fromMap(Map<String, dynamic> map) {
    return Kagga(
      id: map['kagga_id'] as int,
      kaggaKn: map['kagga_kn'] as String,
      kaggaLatn: map['kagga_latn'] as String?,
      kaggaEn: map['kagga_en'] as String?,
    );
  }
}
