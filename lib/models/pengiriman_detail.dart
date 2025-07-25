import 'package:kkp_flutter/models/project.dart';
import 'package:kkp_flutter/models/pengiriman.dart';
import 'package:kkp_flutter/models/detail_asset.dart';
import 'package:kkp_flutter/models/asset.dart';
import 'package:kkp_flutter/models/rental.dart';

class PengirimanDetail {
  final Project project;
  final List<PengirimanItem> pengiriman;
  final List<DetailAsset> availableUnits;

  PengirimanDetail({
    required this.project,
    required this.pengiriman,
    required this.availableUnits,
  });

  factory PengirimanDetail.fromJson(Map<String, dynamic> json) {
    return PengirimanDetail(
      project: Project.fromJson(json['project']),
      pengiriman: (json['pengiriman'] as List)
          .map((e) => PengirimanItem.fromJson(e))
          .toList(),
      availableUnits: (json['available_units'] as List)
          .map((e) => DetailAsset.fromJson(e))
          .toList(),
    );
  }
}

class PengirimanItem {
  final int id;
  final int detailAssetId;
  final String tanggalPengiriman;
  final String picPengirim;
  final String picPenerima;
  final String? createdAt;
  final String? updatedAt;
  final DetailAsset detailAsset;
  final Rental rental;

  PengirimanItem({
    required this.id,
    required this.detailAssetId,
    required this.tanggalPengiriman,
    required this.picPengirim,
    required this.picPenerima,
    this.createdAt,
    this.updatedAt,
    required this.detailAsset,
    required this.rental,
  });

  factory PengirimanItem.fromJson(Map<String, dynamic> json) {
    return PengirimanItem(
      id: json['id'],
      detailAssetId: json['detailasset_id'],
      tanggalPengiriman: json['tanggal_pengiriman'],
      picPengirim: json['pic_pengirim'],
      picPenerima: json['pic_penerima'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      detailAsset: DetailAsset.fromJson(json['detail_asset']),
      rental: Rental.fromJson(json['rental']),
    );
  }
}
