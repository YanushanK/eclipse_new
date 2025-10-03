import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eclipse/services/location_service.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();

  bool _isFetchingLocation = false;
  String _paymentMethod = 'credit_card';

  @override
  void initState() {
    super.initState();
    // Attempt to autofill on page load
    _fetchCurrentLocation();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  /// Fetch current GPS location and autofill address
  Future<void> _fetchCurrentLocation() async {
    setState(() => _isFetchingLocation = true);

    try {
      final locationService = ref.read(locationServiceProvider);
      final address = await locationService.getCurrentAddress();

      if (address != null) {
        setState(() {
          _streetController.text = address.street;
          _cityController.text = address.city;
          _postalCodeController.text = address.postalCode;
          _countryController.text = address.country;
        });
        _showToast('Address autofilled from GPS');
      } else {
        _showToast('Could not fetch location. Please enter manually.', isError: true);
      }
    } catch (e) {
      _showToast('Location error: $e', isError: true);
    } finally {
      setState(() => _isFetchingLocation = false);
    }
  }

  /// Show toast message
  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  /// Process checkout
  void _processCheckout() {
    if (_formKey.currentState?.validate() ?? false) {
      // In a real app, this would process payment
      _showToast('Thank you for your order!');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Delivery Address Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: theme.textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: _isFetchingLocation
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.my_location),
                    onPressed: _isFetchingLocation ? null : _fetchCurrentLocation,
                    tooltip: 'Refresh location',
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Street Address
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter street address' : null,
              ),

              const SizedBox(height: 16),

              // City
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: const Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Enter city' : null,
              ),

              const SizedBox(height: 16),

              // Postal Code and Country Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        prefixIcon: const Icon(Icons.markunread_mailbox),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter postal code' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        prefixIcon: const Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Enter country' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Payment Method Section
              Text(
                'Payment Method',
                style: theme.textTheme.titleLarge,
              ),

              const SizedBox(height: 16),

              // Payment Options
              RadioListTile<String>(
                title: const Text('Credit Card'),
                subtitle: const Text('Visa, Mastercard, Amex'),
                value: 'credit_card',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                secondary: const Icon(Icons.credit_card),
              ),

              RadioListTile<String>(
                title: const Text('Cash on Delivery'),
                subtitle: const Text('Pay when you receive'),
                value: 'cash',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                secondary: const Icon(Icons.money),
              ),

              RadioListTile<String>(
                title: const Text('Digital Wallet'),
                subtitle: const Text('PayPal, Google Pay, Apple Pay'),
                value: 'wallet',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                secondary: const Icon(Icons.account_balance_wallet),
              ),

              const SizedBox(height: 32),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processCheckout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'PLACE ORDER',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}