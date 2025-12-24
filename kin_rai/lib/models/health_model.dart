import 'package:flutter/material.dart';

class HealthData {
  final int? id;
  //final String date;
  final double heartRate;
  final double sleep;
  final double spO2;
  final double hrv;
  final double calories;
  final DateTime recordTime;

  HealthData({
    this.id,
    //required this.date,
    required this.heartRate,
    required this.sleep,
    required this.spO2,
    required this.hrv,
    required this.calories,
    required this.recordTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //'date': date,
      'heart_rate': heartRate,
      'sleep': sleep,
      'spO2': spO2,
      'hrv': hrv,
      'calories': calories,
      'record_time': recordTime.toIso8601String(),
    };
  }

  factory HealthData.fromMap(Map<String, dynamic> map) {
    return HealthData(
      id: map['id'],
      //date: map['date'],
      heartRate: map['heart_rate'],
      sleep: map['sleep'],
      spO2: map['spO2'],
      hrv: map['hrv'],
      calories: map['calories'],
      recordTime: DateTime.parse(map['record_time']),
    );
  }

  String get sleepDuration {
    if (sleep == null) return "0";
    int h = sleep!.toInt() ~/ 60;
    int m = sleep!.toInt() % 60;
    return "${h}h ${m}m";
  }

  String get caloriesDuration {
    if (calories == null) return "0";
    int c = calories!.toInt();
    return "${c}";
  }

  String get heartRateDuration {
    if (heartRate == null) return "0";
    int h = heartRate!.toInt();
    return "${h}";
  }

  String get spO2Duration {
    if (spO2 == null) return "0";
    int s = spO2!.toInt();
    return "${s}";
  }

  String get hrvDuration {
    if (hrv == null) return "0";
    int h = hrv!.toInt();
    return "${h}";
  }
}
