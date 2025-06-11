import 'package:hive/hive.dart';

part 'comparison_entry.g.dart';

@HiveType(typeId: 2)
class ComparisonEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String photoPath;

  @HiveField(2)
  final String result;

  @HiveField(3)
  final DateTime createdAt;

  ComparisonEntry({
    required this.id,
    required this.photoPath,
    required this.result,
    required this.createdAt,
  });
}
