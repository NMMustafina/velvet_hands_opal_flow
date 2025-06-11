// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'producty_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductyModelAdapter extends TypeAdapter<ProductyModel> {
  @override
  final int typeId = 0;

  @override
  ProductyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductyModel(
      id: fields[0] as String,
      category: fields[1] as String,
      nameee: fields[2] as String,
      barannd: fields[3] as String?,
      stars: fields[4] as String?,
      commeeent: fields[5] as String?,
      phottooo: fields[6] as String?,
      isInWishlist: fields[7] as bool,
      link: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductyModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.nameee)
      ..writeByte(3)
      ..write(obj.barannd)
      ..writeByte(4)
      ..write(obj.stars)
      ..writeByte(5)
      ..write(obj.commeeent)
      ..writeByte(6)
      ..write(obj.phottooo)
      ..writeByte(7)
      ..write(obj.isInWishlist)
      ..writeByte(8)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
