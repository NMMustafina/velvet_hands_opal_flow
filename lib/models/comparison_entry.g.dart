// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comparison_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComparisonEntryAdapter extends TypeAdapter<ComparisonEntry> {
  @override
  final int typeId = 2;

  @override
  ComparisonEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComparisonEntry(
      id: fields[0] as String,
      photoPath: fields[1] as String,
      result: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ComparisonEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.photoPath)
      ..writeByte(2)
      ..write(obj.result)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComparisonEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
