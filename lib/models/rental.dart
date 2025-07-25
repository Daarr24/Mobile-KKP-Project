class Rental {
  final int id;
  final int pengirimanId;
  final int projectId;
  final String status;
  final String periodeMulai;
  final String periodeAkhir;
  final int totalTagihan;
  final String? createdAt;
  final String? updatedAt;

  Rental({
    required this.id,
    required this.pengirimanId,
    required this.projectId,
    required this.status,
    required this.periodeMulai,
    required this.periodeAkhir,
    required this.totalTagihan,
    this.createdAt,
    this.updatedAt,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'],
      pengirimanId: json['pengiriman_id'],
      projectId: json['project_id'],
      status: json['status'],
      periodeMulai: json['periode_mulai'],
      periodeAkhir: json['periode_ahir'],
      totalTagihan: json['total_tagihan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
} 