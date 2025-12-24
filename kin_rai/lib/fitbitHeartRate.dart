import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:kin_rai/try.dart';

class FitbitHeartRatePage extends StatefulWidget {
  final String accessToken;
  final String userId;

  const FitbitHeartRatePage({
    super.key,
    required this.accessToken,
    required this.userId,
  });

  @override
  State<FitbitHeartRatePage> createState() => _FitbitHeartRatePageState();
}

class _FitbitHeartRatePageState extends State<FitbitHeartRatePage> {
  Map<String, dynamic>? heartData;
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchHeartRate() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final formattedDate =
          "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      final url = Uri.parse(
        'https://api.fitbit.com/1/user/${widget.userId}/activities/heart/date/$formattedDate/1d.json',
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer ${widget.accessToken}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          heartData = json.decode(response.body);
        });
        print('URI: $url');
        print('✅ Heart Rate Data: ${response.body}');
      } else {
        print('❌ Error fetching data: ${response.body}');
        setState(() {
          errorMessage =
              'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHeartRate(); // ดึงข้อมูลเมื่อเปิดหน้า
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitbit Heart Rate')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
            ? Text('❌ $errorMessage')
            : heartData != null
            ? ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Heart Rate Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    const JsonEncoder.withIndent('  ').convert(heartData),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              )
            : const Text('No heart rate data available.'),
      ),
    );
  }
}
