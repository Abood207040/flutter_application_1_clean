
abstract class PaymentStrategy {
  Future<void> pay(double amount, Map<String, dynamic> bookingData, Function onSuccess, Function onError);
}

class CreditCardPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount, Map<String, dynamic> bookingData, Function onSuccess, Function onError) async {
    try {
      print("💳 Processing credit card payment: \$${amount}");
      await Future.delayed(Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }
}

class VisaPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount, Map<String, dynamic> bookingData, Function onSuccess, Function onError) async {
    try {
      print("💳 Processing VISA payment: \$${amount}");
      await Future.delayed(Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }
}

class PayPalPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount, Map<String, dynamic> bookingData, Function onSuccess, Function onError) async {
    try {
      print("💲 Processing PayPal payment: \$${amount}");
      await Future.delayed(Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      onError(e);
    }
  }
}
