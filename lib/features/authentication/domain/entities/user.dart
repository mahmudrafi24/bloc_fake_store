import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
class User extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? token;
  final Address? address;
  final Name? name;
  final String? phone;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.token,
    this.address,
    this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [id, username, email, token, address, name, phone];
}

/// Name value object representing user's name
class Name extends Equatable {
  final String firstname;
  final String lastname;

  const Name({required this.firstname, required this.lastname});

  String get fullName => '$firstname $lastname';

  @override
  List<Object?> get props => [firstname, lastname];
}

/// Address value object representing user's address
class Address extends Equatable {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final Geolocation? geolocation;

  const Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    this.geolocation,
  });

  @override
  List<Object?> get props => [city, street, number, zipcode, geolocation];
}

/// Geolocation value object for address coordinates
class Geolocation extends Equatable {
  final String lat;
  final String long;

  const Geolocation({required this.lat, required this.long});

  @override
  List<Object?> get props => [lat, long];
}
