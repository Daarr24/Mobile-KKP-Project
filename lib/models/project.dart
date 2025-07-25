class Project {
  final int id;
  final String nama;
  final int durasiKontrak;
  final double hargaSewa;
  final String? createdAt;
  final String? updatedAt;

  Project({
    required this.id,
    required this.nama,
    required this.durasiKontrak,
    required this.hargaSewa,
    this.createdAt,
    this.updatedAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      nama: json['nama'],
      durasiKontrak: json['durasi_kontrak'],
      hargaSewa: double.parse(json['harga_sewa'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
} 