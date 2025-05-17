import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatefulWidget {
  final String userId;

  AdminDashboard({required this.userId});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int totalUsers = 0;
  int totalTrips = 0;
  Map<String, int> destinationVisits = {};
  Map<String, double> tripDurations = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch total users
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        totalUsers = userSnapshot.docs.length;
      });

      // Fetch total trips
      QuerySnapshot tripsSnapshot =
          await FirebaseFirestore.instance.collection('confirmed_trips').get();
      setState(() {
        totalTrips = tripsSnapshot.docs.length;
      });

      // Process trips data for charts
      Map<String, int> tempDestinationVisits = {};
      Map<String, double> tempTripDurations = {};

      for (var doc in tripsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String destination = data['destination'] ?? 'Unknown';
        double tripDuration = data['duration']?.toDouble() ?? 0.0;

        // Update destination visits
        tempDestinationVisits[destination] =
            (tempDestinationVisits[destination] ?? 0) + 1;

        // Update total duration by destination
        tempTripDurations[destination] =
            (tempTripDurations[destination] ?? 0.0) + tripDuration;
      }

      setState(() {
        destinationVisits = tempDestinationVisits;

        // Calculate average trip duration for each destination
        tripDurations = tempTripDurations.map((destination, totalDuration) {
          int visitCount = tempDestinationVisits[destination] ?? 1;
          double avgDuration = totalDuration / visitCount;
          return MapEntry(destination, avgDuration);
        });
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show loading until data is fetched
            if (totalUsers == 0 ||
                totalTrips == 0 ||
                destinationVisits.isEmpty ||
                tripDurations.isEmpty)
              Center(child: CircularProgressIndicator()),

            // If data is available, show dashboard content
            if (totalUsers > 0 &&
                totalTrips > 0 &&
                destinationVisits.isNotEmpty &&
                tripDurations.isNotEmpty) ...[
              // Total Users and Trips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricCard('Total Users', totalUsers.toString()),
                  _buildMetricCard('Total Trips', totalTrips.toString()),
                ],
              ),
              SizedBox(height: 16.0),

              // Pie Chart for Most Visited Destinations
              Text(
                'Most Visited Destinations',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 400.0,
                child: destinationVisits.isNotEmpty
                    ? Column(
                        children: [
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 50,
                                sections: destinationVisits.entries
                                    .map((entry) => PieChartSectionData(
                                          value: entry.value.toDouble(),
                                          color: Colors.primaries[
                                              entry.key.hashCode %
                                                  Colors.primaries.length],
                                          radius: 100,
                                          title: '',
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: destinationVisits.entries
                                .map((entry) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          color: Colors.primaries[
                                              entry.key.hashCode %
                                                  Colors.primaries.length],
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          '${entry.key} (${entry.value})',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ],
                      )
                    : Center(child: Text('Loading...')),
              ),
              SizedBox(height: 16.0),

              // Bar Chart for Trip Duration by Destination
              Text(
                'Trip Duration by Destination',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300.0,
                child: tripDurations.isNotEmpty
                    ? BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: tripDurations.entries
                              .map((entry) => BarChartGroupData(
                                    x: tripDurations.keys
                                        .toList()
                                        .indexOf(entry.key),
                                    barRods: [
                                      BarChartRodData(
                                        toY: entry.value,
                                        color: Colors.blue,
                                        width: 15,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  ))
                              .toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()} days',
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index < 0 ||
                                      index >= tripDurations.keys.length) {
                                    return Text('');
                                  }
                                  String destination =
                                      tripDurations.keys.elementAt(index);
                                  return Text(
                                    destination.length > 5
                                        ? '${destination.substring(0, 5)}...'
                                        : destination,
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: true),
                        ),
                      )
                    : Center(child: Text('Loading...')),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}