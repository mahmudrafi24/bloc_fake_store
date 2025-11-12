// ignore_for_file: annotate_overrides

import 'package:hive/hive.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// UserModel extending User entity with JSON serialization and Hive persistence
@HiveType(typeId: 1)
class UserModel extends User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? token;

  @HiveField(4)
  final AddressModel? address;

  @HiveField(5)
  final NameModel? name;

  @HiveField(6)
  final String? phone;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.address,
    this.name,
    this.phone,
  }) : super(
         id: id,
         username: username,
         email: email,
         token: token,
         address: address,
         name: name,
         phone: phone,
       );

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      name: json['name'] != null
          ? NameModel.fromJson(json['name'] as Map<String, dynamic>)
          : null,
      phone: json['phone'] as String?,
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      if (token != null) 'token': token,
      if (address != null) 'address': (address as AddressModel).toJson(),
      if (name != null) 'name': (name as NameModel).toJson(),
      if (phone != null) 'phone': phone,
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? token,
    AddressModel? address,
    NameModel? name,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
      address: address ?? this.address,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}

/// NameModel extending Name entity with JSON serialization and Hive persistence
@HiveType(typeId: 2)
class NameModel extends Name {
  @HiveField(0)
  final String firstname;

  @HiveField(1)
  final String lastname;

  const NameModel({required this.firstname, required this.lastname})
    : super(firstname: firstname, lastname: lastname);

  /// Create NameModel from JSON
  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );
  }

  /// Convert NameModel to JSON
  Map<String, dynamic> toJson() {
    return {'firstname': firstname, 'lastname': lastname};
  }
}

/// AddressModel extending Address entity with JSON serialization and Hive persistence
@HiveType(typeId: 3)
class AddressModel extends Address {
  @HiveField(0)
  final String city;

  @HiveField(1)
  final String street;

  @HiveField(2)
  final int number;

  @HiveField(3)
  final String zipcode;

  @HiveField(4)
  final GeolocationModel? geolocation;

  const AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    this.geolocation,
  }) : super(
         city: city,
         street: street,
         number: number,
         zipcode: zipcode,
         geolocation: geolocation,
       );

  /// Create AddressModel from JSON
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] as String,
      street: json['street'] as String,
      number: json['number'] as int,
      zipcode: json['zipcode'] as String,
      geolocation: json['geolocation'] != null
          ? GeolocationModel.fromJson(
              json['geolocation'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Convert AddressModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      if (geolocation != null)
        'geolocation': (geolocation as GeolocationModel).toJson(),
    };
  }
}

/// GeolocationModel extending Geolocation entity with JSON serialization and Hive persistence
@HiveType(typeId: 4)
class GeolocationModel extends Geolocation {
  @HiveField(0)
  final String lat;

  @HiveField(1)
  final String long;

  const GeolocationModel({required this.lat, required this.long})
    : super(lat: lat, long: long);

  /// Create GeolocationModel from JSON
  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );
  }

  /// Convert GeolocationModel to JSON
  Map<String, dynamic> toJson() {
    return {'lat': lat, 'long': long};
  }
}
