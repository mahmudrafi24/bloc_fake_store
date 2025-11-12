// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 5;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      id: fields[0] as int,
      userId: fields[1] as int,
      items: (fields[2] as List).cast<OrderItemModel>(),
      totalAmount: fields[3] as double,
      orderDate: fields[4] as DateTime,
      statusModel: fields[5] as OrderStatusModel,
      shippingAddress: fields[6] as AddressModel,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.orderDate)
      ..writeByte(5)
      ..write(obj.statusModel)
      ..writeByte(6)
      ..write(obj.shippingAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderItemModelAdapter extends TypeAdapter<OrderItemModel> {
  @override
  final int typeId = 6;

  @override
  OrderItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItemModel(
      product: fields[0] as ProductModel,
      quantity: fields[1] as int,
      price: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.product)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderStatusModelAdapter extends TypeAdapter<OrderStatusModel> {
  @override
  final int typeId = 7;

  @override
  OrderStatusModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatusModel.pending;
      case 1:
        return OrderStatusModel.processing;
      case 2:
        return OrderStatusModel.shipped;
      case 3:
        return OrderStatusModel.delivered;
      case 4:
        return OrderStatusModel.cancelled;
      default:
        return OrderStatusModel.pending;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatusModel obj) {
    switch (obj) {
      case OrderStatusModel.pending:
        writer.writeByte(0);
        break;
      case OrderStatusModel.processing:
        writer.writeByte(1);
        break;
      case OrderStatusModel.shipped:
        writer.writeByte(2);
        break;
      case OrderStatusModel.delivered:
        writer.writeByte(3);
        break;
      case OrderStatusModel.cancelled:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
