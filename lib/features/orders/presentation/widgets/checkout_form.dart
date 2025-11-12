import 'package:flutter/material.dart';
import '../../../authentication/domain/entities/user.dart';

/// Widget for collecting shipping address information during checkout
class CheckoutForm extends StatefulWidget {
  final void Function(Address address) onAddressSubmitted;

  const CheckoutForm({super.key, required this.onAddressSubmitted});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipcodeController = TextEditingController();

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final address = Address(
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        zipcode: _zipcodeController.text.trim(),
        number: 0, // Default value as not collected in form
        geolocation: const Geolocation(lat: '0', long: '0'), // Default value
      );
      widget.onAddressSubmitted(address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Shipping Address',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _streetController,
            decoration: const InputDecoration(
              labelText: 'Street Address',
              hintText: 'Enter your street address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your street address';
              }
              if (value.trim().length < 5) {
                return 'Street address must be at least 5 characters';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              hintText: 'Enter your city',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_city),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your city';
              }
              if (value.trim().length < 2) {
                return 'City must be at least 2 characters';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _zipcodeController,
            decoration: const InputDecoration(
              labelText: 'Zipcode',
              hintText: 'Enter your zipcode',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.pin_drop),
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your zipcode';
              }
              if (value.trim().length < 3) {
                return 'Zipcode must be at least 3 characters';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submitForm(),
          ),
        ],
      ),
    );
  }
}
