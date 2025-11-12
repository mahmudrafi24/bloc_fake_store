// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WishlistItemModelAdapter extends TypeAdapter<WishlistItemModel> {
  @override
  final int typeId = 3;

  @override
  WishlistItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemModel(
      id: fields[0] as int,
      product: fields[1] as ProductModel,
      addedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.product)
      ..writeByte(2)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
