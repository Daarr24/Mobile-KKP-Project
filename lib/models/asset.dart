import 'detail_asset.dart';

class Asset {
  final int id;
  final String merk;
  final String type;
  final String spesifikasi;
  final String? createdAt;
  final String? updatedAt;
  final List<DetailAsset>? detailAssets;

  Asset({
    required this.id,
    required this.merk,
    required this.type,
    required this.spesifikasi,
    this.createdAt,
    this.updatedAt,
    this.detailAssets,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      merk: json['merk'],
      type: json['type'],
      spesifikasi: json['spesifikasi'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      detailAssets: json['detailassets'] != null
          ? (json['detailassets'] as List)
              .map((e) => DetailAsset.fromJson(e))
              .toList()
          : [],
    );
  }
} 