class Pengiriman {
  final int id;
  final int detailAssetId;
  final String tanggalPengiriman;
  final String picPengirim;
  final String picPenerima;
  final String? createdAt;
  final String? updatedAt;

  Pengiriman({
    required this.id,
    required this.detailAssetId,
    required this.tanggalPengiriman,
    required this.picPengirim,
    required this.picPenerima,
    this.createdAt,
    this.updatedAt,
  });

  factory Pengiriman.fromJson(Map<String, dynamic> json) {
    return Pengiriman(
      id: json['id'],
      detailAssetId: json['detailasset_id'],
      tanggalPengiriman: json['tanggal_pengiriman'],
      picPengirim: json['pic_pengirim'],
      picPenerima: json['pic_penerima'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
} 