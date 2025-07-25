import 'package:kkp_flutter/models/tagihan.dart';
import 'package:kkp_flutter/models/project.dart';
import 'package:kkp_flutter/models/rental.dart';

class TagihanDetail {
  final Tagihan tagihan;
  final Project project;
  final List<Rental> rentals;
  final int totalUnit;
  final int grandTotal;

  TagihanDetail({
    required this.tagihan,
    required this.project,
    required this.rentals,
    required this.totalUnit,
    required this.grandTotal,
  });

  factory TagihanDetail.fromJson(Map<String, dynamic> json) {
    return TagihanDetail(
      tagihan: Tagihan.fromJson(json['tagihan']),
      project: Project.fromJson(json['project']),
      rentals: (json['rentals'] as List)
          .map((e) => Rental.fromJson(e))
          .toList(),
      totalUnit: json['total_unit'],
      grandTotal: json['grand_total'],
    );
  }
}
