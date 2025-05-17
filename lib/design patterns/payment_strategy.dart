// payment_strategy.dart

abstract class PaymentStrategy {
  /// Returns a map of payment details for storage or processing.
  Map<String, dynamic> getPaymentData(double amount);
}

/// Strategy for Credit Card and Visa payments.
class CreditCardPayment implements PaymentStrategy {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;

  CreditCardPayment({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
  });

  @override
  Map<String, dynamic> getPaymentData(double amount) {
    return {
      'method': 'Credit Card',
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'totalCost': amount,
      'paymentDate': DateTime.now(),
      'paymentStatus': true,
    };
  }
}

/// Strategy for PayPal payments.
class PayPalPayment implements PaymentStrategy {
  final String email;
  final String password;

  PayPalPayment({
    required this.email,
    required this.password,
  });

  @override
  Map<String, dynamic> getPaymentData(double amount) {
    return {
      'method': 'PayPal',
      'paypalEmail': email,
      'paypalPassword': password, // ⚠️ avoid saving plain text passwords
      'totalCost': amount,
      'paymentDate': DateTime.now(),
      'paymentStatus': true,
    };
  }
}
