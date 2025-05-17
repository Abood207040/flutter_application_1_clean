abstract class Booking {
  void confirm();
  String getSummary();
}

class TripBooking implements Booking {
  final String destination;

  TripBooking(this.destination);

  @override
  void confirm() => print("Trip booked to \$destination");

  @override
  String getSummary() => "Trip to \$destination";
}

class PackageBooking implements Booking {
  final String destination;
  final List<String> services;

  PackageBooking(this.destination, this.services);

  @override
  void confirm() => print("Package booked to \$destination with \$services");

  @override
  String getSummary() => "Package to \$destination with \${services.join(', ')}";
}

class BookingFactory {
  static Booking create(String type, String destination, [List<String>? services]) {
    switch (type) {
      case 'trip':
        return TripBooking(destination);
      case 'package':
        return PackageBooking(destination, services ?? []);
      default:
        throw Exception("Invalid booking type");
    }
  }
}
