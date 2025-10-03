import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  final Random _random = Random();

  /// Process payment with 2-second delay and 10% failure rate
  Future<PaymentResult> processPayment({
    required double amount,
    required String orderId,
    String? cardNumber,
    String? cvv,
    String? expiryDate,
    String? cardHolder,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final shouldFail = _random.nextInt(10) == 0; // 10% failure

    if (shouldFail) {
      return PaymentResult(
        success: false,
        message: 'Payment failed — try again',
        orderId: orderId,
      );
    }

    return PaymentResult(
      success: true,
      message: 'Payment success',
      orderId: orderId,
      transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  bool validateCardNumber(String cardNumber) {
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.length < 13 || cleaned.length > 19) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool validateCVV(String cvv) => cvv.length == 3 || cvv.length == 4;

  bool validateExpiryDate(String expiry) {
    if (!expiry.contains('/')) return false;
    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final cardYear = 2000 + year;

    if (cardYear < now.year) return false;
    if (cardYear == now.year && month < now.month) return false;

    return true;
  }
}

class PaymentResult {
  final bool success;
  final String message;
  final String orderId;
  final String? transactionId;

  PaymentResult({
    required this.success,
    required this.message,
    required this.orderId,
    this.transactionId,
  });
}