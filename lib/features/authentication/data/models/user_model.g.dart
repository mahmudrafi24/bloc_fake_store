// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      username: fields[1] as String,
      email: fields[2] as String,
      token: fields[3] as String?,
      address: fields[4] as AddressModel?,
      name: fields[5] as NameModel?,
      phone: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.token)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NameModelAdapter extends TypeAdapter<NameModel> {
  @override
  final int typeId = 2;

  @override
  NameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NameModel(
      firstname: fields[0] as String,
      lastname: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NameModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.firstname)
      ..writeByte(1)
      ..write(obj.lastname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 3;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      city: fields[0] as String,
      street: fields[1] as String,
      number: fields[2] as int,
      zipcode: fields[3] as String,
      geolocation: fields[4] as GeolocationModel?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.city)
      ..writeByte(1)
      ..write(obj.street)
      ..writeByte(2)
      ..write(obj.number)
      ..writeByte(3)
      ..write(obj.zipcode)
      ..writeByte(4)
      ..write(obj.geolocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GeolocationModelAdapter extends TypeAdapter<GeolocationModel> {
  @override
  final int typeId = 4;

  @override
  GeolocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeolocationModel(
      lat: fields[0] as String,
      long: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeolocationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
