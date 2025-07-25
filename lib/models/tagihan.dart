class Tagihan {
  final int id;
  final int rentalId;
  final int nomorInvoice;
  final String keterangan;
  final String tanggalTagihan;
  final int jumlahUnit;
  final String durasiTagih;
  final int grandTotal;
  final String? createdAt;
  final String? updatedAt;

  Tagihan({
    required this.id,
    required this.rentalId,
    required this.nomorInvoice,
    required this.keterangan,
    required this.tanggalTagihan,
    required this.jumlahUnit,
    required this.durasiTagih,
    required this.grandTotal,
    this.createdAt,
    this.updatedAt,
  });

  factory Tagihan.fromJson(Map<String, dynamic> json) {
    return Tagihan(
      id: json['id'],
      rentalId: json['rental_id'],
      nomorInvoice: json['nomor_invoice'],
      keterangan: json['keterangan'],
      tanggalTagihan: json['tanggal_tagihan'],
      jumlahUnit: json['jumlah_unit'],
      durasiTagih: json['durasi_tagih'],
      grandTotal: json['grand_total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
} 