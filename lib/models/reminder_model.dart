import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 1)
class ReminderModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productId;

  @HiveField(2)
  final int hour;

  @HiveField(3)
  final int minute;

  @HiveField(4)
  final List<int> weekdays;

  @HiveField(5)
  final bool enabled;

  @HiveField(6)
  final DateTime createdAt;

  ReminderModel({
    required this.id,
    required this.productId,
    required this.hour,
    required this.minute,
    required this.weekdays,
    required this.enabled,
    required this.createdAt,
  });
}
