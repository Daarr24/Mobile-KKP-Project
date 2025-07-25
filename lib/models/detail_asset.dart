import 'asset.dart';

class DetailAsset {
  final int id;
  final int assetId;
  final String serialNumber;
  final String kondisi;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final Asset? asset;

  DetailAsset({
    required this.id,
    required this.assetId,
    required this.serialNumber,
    required this.kondisi,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.asset,
  });

  factory DetailAsset.fromJson(Map<String, dynamic> json) {
    return DetailAsset(
      id: json['id'],
      assetId: json['asset_id'],
      serialNumber: json['serialnumber'],
      kondisi: json['kondisi'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      asset: json['asset'] != null ? Asset.fromJson(json['asset']) : null,
    );
  }
} 