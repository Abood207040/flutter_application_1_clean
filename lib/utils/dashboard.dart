import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.grey[800]),
          bodyMedium: TextStyle(color: Colors.grey[600]),
        ),
      ),
      home: const DashboardPage(
        userId: "test-user-id", // Replace with dynamic userId in production
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final String userId;

  const DashboardPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        
        backgroundColor: Colors.brown,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Travel Overview",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatisticCard(
                  title: "Total Trips",
                  stream: FirebaseFirestore.instance
                      .collection('confirmed_trips')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  countField: "destination",
                ),
                const SizedBox(width: 10),
                StatisticCard(
                  title: "Total Countries",
                  stream: FirebaseFirestore.instance
                      .collection('confirmed_trips')
                      .where('userId', isEqualTo: userId)
                      .snapshots(),
                  countField: "destination",
                  isUnique: true,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Spending Insights",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<TripPaymentData>>(
                stream: getTripsWithCosts(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text("Error loading chart data."));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text("No data available for chart."));
                  }
                  return TravelColumnChart(tripPayments: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticCard extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot> stream;
  final String countField;
  final bool isUnique;

  const StatisticCard({
    Key? key,
    required this.title,
    required this.stream,
    required this.countField,
    this.isUnique = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading data"));
              }

              final data = snapshot.data?.docs ?? [];
              int count;
              if (isUnique) {
                count = data.map((doc) => doc[countField]).toSet().length;
              } else {
                count = data.length;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class TravelColumnChart extends StatelessWidget {
  final List<TripPaymentData> tripPayments;

  const TravelColumnChart({Key? key, required this.tripPayments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupedData = groupDataByDate(tripPayments);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "${date.day}/${date.month}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: groupedData.entries.map((entry) {
              final barRods = entry.value.map((trip) {
                return BarChartRodData(
                  toY: trip.totalCost,
                  color: trip.color,
                  width: 16,
                );
              }).toList();

              return BarChartGroupData(
                x: entry.key.millisecondsSinceEpoch,
                barRods: barRods,
                barsSpace: 4,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<TripPaymentData>> groupDataByDate(
      List<TripPaymentData> data) {
    final Map<DateTime, List<TripPaymentData>> grouped = {};

    for (final trip in data) {
      final date = DateTime(
        trip.bookingTime.year,
        trip.bookingTime.month,
        trip.bookingTime.day,
      );

      grouped.update(
        date,
        (existingTrips) => [...existingTrips, trip],
        ifAbsent: () => [trip],
      );
    }

    return grouped;
  }
}

class TripPaymentData {
  DateTime bookingTime;
  double totalCost;
  Color color;

  TripPaymentData({
    required this.bookingTime,
    required this.totalCost,
    required this.color,
  });
}

Stream<List<TripPaymentData>> getTripsWithCosts(String userId) async* {
  try {
    final tripQuery = await FirebaseFirestore.instance
        .collection('confirmed_trips')
        .where('userId', isEqualTo: userId)
        .get();

    final paymentsQuery = await FirebaseFirestore.instance
        .collection('confirmed_payments')
        .where('userId', isEqualTo: userId)
        .get();

    final random = Random();
    final colors = [Colors.blue, Colors.green, Colors.red, Colors.yellow];

    final List<TripPaymentData> data = paymentsQuery.docs.map((doc) {
      final timestamp = (doc.data()['paymentDate'] as Timestamp?)?.toDate();
      final totalCost = doc.data()['totalCost'] as double? ?? 0.0;

      return TripPaymentData(
        bookingTime: timestamp!,
        totalCost: totalCost,
        color: colors[random.nextInt(colors.length)],
      );
    }).toList();

    yield data;
  } catch (e) {
    print("Error fetching trips and payments: $e");
    yield [];
  }
}
