import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../db/database_helper.dart';
import '../models/health_model.dart';

class HealthService {
  final String _clientId = '23TJJY';
  final String _clientSecret =
      'db870d61a4cea34fbb349118c44e735'; // **ควรเก็บให้ปลอดภัยกว่านี้**
  final String _redirectUri = 'myapp://callback';

  // Endpoint
  static const String _authorizationEndpoint =
      'https://www.fitbit.com/oauth2/authorize';
  static const String _tokenEndpoint = 'https://api.fitbit.com/oauth2/token';

  // ตัวแปร
  String? accessToken;
  String? refreshToken;
  String? userId;
  String? expires;
  String? codeVerifier;
  String? codeChallenge;

  // ใช้ตอน login
  Future<void> authenticate() async {
    await _loginWithFitbit();
  }

  Future<void> prepareLogin() async {
    // สุ่ม code_verifier
    String _generateCodeVerifier([int length = 64]) {
      final random = Random.secure();
      final values = List<int>.generate(length, (i) => random.nextInt(256));
      return base64UrlEncode(
        values,
      ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
    }

    // สร้าง code_challenge จาก verifier
    String _generateCodeChallenge(String verifier) {
      final bytes = utf8.encode(verifier); //ascii.encode(verifier);
      final digest = sha256.convert(bytes);
      return base64UrlEncode(
        digest.bytes,
      ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
    }

    final String Verifier = _generateCodeVerifier();
    final String Challenge = _generateCodeChallenge(Verifier);

    codeVerifier = Verifier;
    codeChallenge = Challenge;

    print('✅ Code Verifier: $codeVerifier');
    print('✅ Code Challenge: $codeChallenge');
  }

  // loginFitbit
  Future<void> _loginWithFitbit() async {
    await prepareLogin();

    if (codeVerifier == null || codeChallenge == null) {
      print('❌ Error: สร้าง PKCE Code ไม่สำเร็จ');
      return;
    }

    try {
      // สร้าง URL สำหรับ authorize

      final authUrl =
          '$_authorizationEndpoint?response_type=code&client_id=$_clientId'
          '&code_challenge=$codeChallenge'
          '&code_challenge_method=S256'
          '&redirect_uri=$_redirectUri'
          '&scope=activity%20heartrate%20oxygen_saturation%20respiratory_rate%20sleep';

      print('🔗 Fitbit Auth URL: $authUrl');

      print('กำลังเปิดหน้าเว็บเพื่ออนุญาต...');
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: 'myapp',
      );
      print('✅ ได้รับการ Redirect กลับมาแล้ว: $result');

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        print('❌ ไม่พบ code ใน redirect URI');
        return;
      }

      print('✅ Authorization Code: $code');

      final String rawAuth =
          '$_clientId:$_clientSecret'; //'${_clientId.trim()}:${_clientSecret.trim()}';
      final String basicAuth = 'Basic ' + base64Encode(utf8.encode(rawAuth));

      print('✅ rawAuth: $rawAuth');
      print('✅ basicAuth: $basicAuth');

      // แลกเปลี่ยน code เป็น access token
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {
          //'Authorization': basicAuth,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'client_id': _clientId,
          'code': code,
          'code_verifier': codeVerifier,
          'grant_type': 'authorization_code',
          'redirect_uri': _redirectUri,
        },
      );
      print('🌐 Request URL: ${response.request?.url}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        accessToken = data['access_token'];
        refreshToken = data['refresh_token'];
        userId = data['user_id'];

        final int expiresIn = data['expires_in']; // int
        expires = DateTime.now()
            .add(Duration(seconds: expiresIn))
            .toIso8601String();

        // บันทึก Token ลงใน SharedPreferences
        await _saveToken();

        print('✅ Login Success!');
        print('✅ Access Token: $accessToken');
        print('✅ Refresh Token: $refreshToken');
        print('✅ Expires In: $expires');
        print('✅ UserID: $userId');
      } else {
        print(
          '❌ Token Request Failed (Status: ${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      print('❌ Error during Fitbit authentication: $e');
    }
  }

  // saveToken
  Future<void> _saveToken() async {
    if (accessToken == null || refreshToken == null || userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fitbit_actoken', accessToken!);
    await prefs.setString('fitbit_retoken', refreshToken!);
    await prefs.setString('fitbit_user_id', userId!);
    await prefs.setString('fitbit_expires', expires!);
  }

  // loadToken
  Future<bool> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      accessToken = prefs.getString('fitbit_actoken');
      refreshToken = prefs.getString('fitbit_retoken');
      userId = prefs.getString('fitbit_user_id');
      expires = prefs.getString('fitbit_expires');

      // มีข้อมูลสำคัญครบหรือมั้ย
      if (accessToken != null && accessToken!.isNotEmpty) {
        print('✅ โหลด Token สำเร็จ: $userId');
        return true; // Token พร้อมใช้
      } else {
        print('⚠️ ไม่พบ Access Token ในเครื่อง');
        return false; // ไม่มีข้อมูล
      }
    } catch (e) {
      print('❌ เกิดข้อผิดพลาดในการโหลด Token: $e');
      return false; // คืนค่า false เมื่อเกิด Error
    }
  }

  // refreshToken
  Future<bool> refreshTokenIfExpired() async {
    if (refreshToken == null) {
      print('Refresh Token is missing.');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {
          // 'Authorization':
          //     'Basic ' + base64Encode(utf8.encode('$_clientId:$_clientSecret')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _clientId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        accessToken = data['access_token'];
        refreshToken = data['refresh_token'];
        userId = data['user_id'];

        final int expiresIn = data['expires_in']; // ⬅️ int
        expires = DateTime.now()
            .add(Duration(seconds: expiresIn))
            .toIso8601String();

        await _saveToken();
        print('✅ Token Refreshed Successfully!');
        return true;
      } else {
        print(
          '❌ Token Refresh Failed (Status: ${response.statusCode}): ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Error during token refresh: $e');
      return false;
    }
  }

  // fetchAndSave
  Future<void> fetchAndSaveHealthData() async {
    final hasToken = await loadToken();
    if (!hasToken) {
      print('No valid token found - please login.');
      return;
    }

    // Access Token ยังใช้ได้หรือไม่
    if (!await _isTokenValid()) {
      print('Access Token may be expired. Attempting refresh...');
      // 3. ถ้า Token หมดอายุ ให้ทำการ Refresh
      final refreshed = await refreshTokenIfExpired();
      if (!refreshed) {
        print('Failed to refresh token. User must re-login.');
        return;
      }
    }

    // ดึงและบันทึกข้อมูล
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final date =
        "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

    final data = await _fetchHealthData(date);
    if (data != null) {
      //ตรวจสอบว่า DatabaseHelper มีจริงก่อนเรียกใช้
      if (DatabaseHelper.instance != null) {
        await DatabaseHelper.instance.insertHealthData(data);
        print('Saved health data for $date');
      } else {
        print('DatabaseHelper instance is not available.');
      }
      print('Would insert data: $data'); // แสดงผลแทนการบันทึกจริง
    }
  }

  // ตรวจสอบความถูกต้องของ Token
  Future<bool> _isTokenValid() async {
    final url = Uri.parse('https://api.fitbit.com/1/user/$userId/profile.json');
    final r = await http.get(url, headers: _header());
    return r.statusCode == 200;
  }

  // ดึงข้อมูล
  Future<HealthData?> _fetchHealthData(String date) async {
    double heartRate = await _fetchHeartRate(date);
    double sleep = await _fetchSleep(date);
    double spO2 = await _fetchSpO2(date);
    double hrv = await _fetchHRV(date);
    double calories = await _fetchCalories(date);

    return HealthData(
      //date: date,
      heartRate: heartRate,
      sleep: sleep,
      spO2: spO2,
      hrv: hrv,
      calories: calories,
      recordTime: DateTime.now(),
    );
  }

  // saveข้อมูล
  Future<HealthData?> saveHealthData(String date) async {
    double heartRate = await _fetchHeartRate(date);
    double sleep = await _fetchSleep(date);
    double spO2 = await _fetchSpO2(date);
    double hrv = await _fetchHRV(date);
    double calories = await _fetchCalories(date);

    return HealthData(
      heartRate: heartRate,
      sleep: sleep,
      spO2: spO2,
      hrv: hrv,
      calories: calories,
      recordTime: DateTime.now(),
    );
  }

  Future<double> _fetchHeartRate(String date) async {
    final url = Uri.parse(
      'https://api.fitbit.com/1/user/$userId/activities/heart/date/$date/1d.json',
    );
    final r = await http.get(url, headers: _header());
    if (r.statusCode != 200) return 0;

    final j = json.decode(r.body);
    // ปรับการเข้าถึงข้อมูลให้ปลอดภัยขึ้น
    final restingHeartRate = j['activities-heart']?.isNotEmpty == true
        ? j['activities-heart'][0]['value']['restingHeartRate']
        : null;

    return (restingHeartRate ?? 0).toDouble();
  }

  Future<double> _fetchSleep(String date) async {
    final url = Uri.parse(
      'https://api.fitbit.com/1.2/user/$userId/sleep/date/$date.json',
    );
    final r = await http.get(url, headers: _header());
    if (r.statusCode != 200) return 0;

    final j = json.decode(r.body);
    return (j['summary']['totalMinutesAsleep'] ?? 0).toDouble();
  }

  Future<double> _fetchSpO2(String date) async {
    final url = Uri.parse(
      'https://api.fitbit.com/1/user/$userId/spo2/date/$date.json',
    );
    final r = await http.get(url, headers: _header());
    if (r.statusCode != 200) return 0;

    final j = json.decode(r.body);
    if (j is List && j.isNotEmpty) {
      return (j[0]['value']['avg'] ?? 0).toDouble();
    }
    return 0;
  }

  Future<double> _fetchHRV(String date) async {
    final url = Uri.parse(
      'https://api.fitbit.com/1/user/$userId/hrv/date/$date.json',
    );
    final r = await http.get(url, headers: _header());
    if (r.statusCode != 200) return 0;

    final j = json.decode(r.body);
    // ปรับการเข้าถึงข้อมูลให้ปลอดภัยขึ้น
    final dailyRmssd = j['hrv']?.isNotEmpty == true
        ? j['hrv'][0]['value']['dailyRmssd']
        : null;

    return (dailyRmssd ?? 0).toDouble();
  }

  Future<double> _fetchCalories(String date) async {
    final url = Uri.parse(
      'https://api.fitbit.com/1/user/$userId/activities/calories/date/$date/1d.json',
    );
    final r = await http.get(url, headers: _header());
    if (r.statusCode != 200) return 0;

    final j = json.decode(r.body);
    return double.tryParse(j['activities-calories'][0]['value'] ?? '0') ?? 0;
  }

  // Header สำหรับ API Call
  Map<String, String> _header() {
    if (accessToken == null) {
      // ควรจัดการเมื่อ accessToken เป็น null
      throw Exception('Access Token is null. Authentication required.');
    }
    return {'Authorization': 'Bearer $accessToken'};
  }
}
