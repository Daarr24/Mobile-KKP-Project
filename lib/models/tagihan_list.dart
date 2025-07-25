import 'package:kkp_flutter/models/tagihan.dart';
import 'package:kkp_flutter/models/project.dart';
import 'package:kkp_flutter/models/rental.dart';

class TagihanList {
  final Project project;
  final List<Tagihan> tagihan;
  final int totalUnit;
  final int grandTotal;

  TagihanList({
    required this.project,
    required this.tagihan,
    required this.totalUnit,
    required this.grandTotal,
  });

  factory TagihanList.fromJson(Map<String, dynamic> json) {
    return TagihanList(
      project: Project.fromJson(json['project']),
      tagihan: (json['tagihan'] as List)
          .map((e) => Tagihan.fromJson(e))
          .toList(),
      totalUnit: json['total_unit'],
      grandTotal: json['grand_total'],
    );
  }
}
