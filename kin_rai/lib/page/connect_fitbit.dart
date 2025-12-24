import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_rai/services/health_service.dart';
import 'package:get/get.dart';
import 'package:kin_rai/db/database_helper.dart';
import 'package:kin_rai/main.dart';

class ConnectFitbit extends StatefulWidget {
  const ConnectFitbit({super.key});

  @override
  State<ConnectFitbit> createState() => _ConnectFitbitState();
}

late final String codeVerifier;
late final String codeChallenge;

class _ConnectFitbitState extends State<ConnectFitbit> {
  final HealthService _healthService = HealthService();
  bool _isLoading = false;

  Future<void> _handleFitbitLogin() async {
    // ตรวจสอบสถานะการโหลด
    if (_isLoading) return;

    if (mounted) {
      setState(() {
        _isLoading = true; // เริ่มโหลด
      });
    }

    try {
      // เรียกใช้ฟังก์ชัน Authen
      await _healthService.authenticate();

      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final date =
          "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      await _healthService.saveHealthData(date);

      _showSuccessSnackbar(
        '✅ เชื่อมต่อ Fitbit สำเร็จ!',
        'คุณสามารถเริ่มใช้งานแอปพลิเคชันได้',
      );

      Get.offAll(() => const MainNavigation());

      // log
      await DatabaseHelper.instance.insertBgLog(
        message: 'Manual fetch triggered',
        runType: 'foreground',
      );

      await DatabaseHelper.instance.insertBgLog(
        message: 'Health fetch started',
        runType: 'foreground',
      );

      await _healthService.fetchAndSaveHealthData();

      await DatabaseHelper.instance.insertBgLog(
        message: 'Health fetch finished',
        runType: 'foreground',
      );

      await DatabaseHelper.instance.insertBgLog(
        message: 'Manual fetch finished',
        runType: 'foreground',
      );
    } catch (e) {
      String errorMessage = 'โปรดลองใหม่อีกครั้ง';

      // ตรวจสอบว่าเป็น PlatformException(CANCELED) ไหม
      if (e is PlatformException && e.code == 'CANCELED') {
        errorMessage = 'ผู้ใช้ยกเลิกการเชื่อมต่อ';
      } else {
        // ข้อผิดพลาดอื่น ๆ
        errorMessage = e.toString();
      }

      // แสดงข้อผิดพลาด
      _showErrorSnackbar('❌ การเชื่อมต่อล้มเหลว', errorMessage);

      // Access Token ยังเป็น null ไหม (ยกเลิกแล้วเป็น null)
      if (_healthService.accessToken != null) {
        // หาก Access Token ไม่เป็น null อาจเกิดปัญหาอื่นตามมา
        print("Warning: Login failed but Access Token is NOT null.");
      }
    } finally {
      // หยุดโหลดเสมอ ไม่ว่าจะสำเร็จหรือล้มเหลว
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void _showErrorSnackbar(String title, String message) {
    if (Get.context != null) {
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 229, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 204, 160),
        title: const Text('เชื่อมต่ออุปกรณ์สุขภาพ'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // หัวข้อหลัก
              const Text(
                'เชื่อมต่อ Fitbit',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // คำอธิบาย
              const Text(
                'เพื่อดึงข้อมูลสุขภาพอัตโนมัติ (อัตราการเต้นของหัวใจ, การนอน, SpO2) โปรดเชื่อมต่อกับบัญชี Fitbit ของคุณ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // ปุ่มเชื่อมต่อ
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : _handleFitbitLogin, // ปิดการใช้งานปุ่มขณะโหลด
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.fitness_center),
                label: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Text(
                    _isLoading ? 'กำลังเชื่อมต่อ...' : 'เชื่อมต่อกับ Fitbit',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 223, 167, 89),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
