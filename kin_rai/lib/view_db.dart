import 'package:flutter/material.dart';
import 'db.dart';

class HeartRateView extends StatefulWidget {
  const HeartRateView({super.key});

  @override
  State<HeartRateView> createState() => _HeartRateViewState();
}

class _HeartRateViewState extends State<HeartRateView> {
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DBHelper.getAllHeartRates();
    setState(() {
      records = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fitbit Heart Rate Logs"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadData),
        ],
      ),
      body: records.isEmpty
          ? const Center(child: Text("No Data"))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final item = records[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    title: Text(
                      "Resting Heart Rate: ${item['restingHeartRate']} bpm",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${item['date']}"),
                        Text("Fetched: ${item['fetchedAt']}"),
                      ],
                    ),
                    leading: CircleAvatar(
                      child: Text(item['restingHeartRate'].toString()),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
