// trip_builder.dart

class Trip {
  final String name;
  final String email;
  final String id;
  final String destination;
  final int guests;
  final DateTime startDate;
  final int duration;

  Trip({
    required this.name,
    required this.email,
    required this.id,
    required this.destination,
    required this.guests,
    required this.startDate,
    required this.duration,
  });

  String summary() {
    return "Trip to $destination for $guests guest(s) starting on $startDate for $duration days";
  }
}

class TripBuilder {
  String name = '';
  String email = '';
  String id = '';
  String destination = '';
  int guests = 0;
  DateTime startDate = DateTime.now();
  int duration = 1;

  TripBuilder setName(String val) {
    name = val;
    return this;
  }

  TripBuilder setEmail(String val) {
    email = val;
    return this;
  }

  TripBuilder setId(String val) {
    id = val;
    return this;
  }

  TripBuilder setDestination(String val) {
    destination = val;
    return this;
  }

  TripBuilder setGuests(int val) {
    guests = val;
    return this;
  }

  TripBuilder setStartDate(DateTime val) {
    startDate = val;
    return this;
  }

  TripBuilder setDuration(int val) {
    duration = val;
    return this;
  }

  Trip build() {
    return Trip(
      name: name,
      email: email,
      id: id,
      destination: destination,
      guests: guests,
      startDate: startDate,
      duration: duration,
    );
  }
}
