import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_navigation_bar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod = 0;

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
    },
    {
      'name': 'PayPal',
      'icon': Icons.payment,
    },
    {
      'name': 'Apple Pay',
      'icon': Icons.apple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: GoogleFonts.playfairDisplay(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Payment Method',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...paymentMethods.asMap().entries.map((entry) {
              final index = entry.key;
              final method = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: _selectedPaymentMethod == index
                      ? BorderSide(color: theme.colorScheme.secondary, width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  leading: Icon(method['icon']),
                  title: Text(method['name']),
                  trailing: Radio<int>(
                    value: index,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                    activeColor: theme.colorScheme.secondary,
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = index;
                    });
                  },
                ),
              );
            }).toList(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  // In a real app, you would process payment here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment processed successfully'),
                    ),
                  );
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: Text(
                  'PAY NOW',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(currentIndex: 3),
    );
  }
}