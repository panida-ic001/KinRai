// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:kin_rai/fitbitHeartRate.dart';
// import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
// import 'package:http/http.dart' as http;
// import 'services/background_service.dart';
// import 'view_db.dart';

// class ConnectFitbit2 extends StatefulWidget {
//   const ConnectFitbit2({super.key});

//   @override
//   State<ConnectFitbit2> createState() => _ConnectFitbitState();
// }

// class _ConnectFitbitState extends State<ConnectFitbit2> {
//   final clientId = '23TJJY';
//   final clientSecret = 'db870d61a4cea34f8bb349118c44e735';
//   final redirectUri = 'myapp://callback';
//   final authorizationEndpoint = 'https://www.fitbit.com/oauth2/authorize';
//   final tokenEndpoint = 'https://api.fitbit.com/oauth2/token';

//   String? accessToken;
//   String? refreshToken;
//   String? userId;

//   Future<void> _loginWithFitbit() async {
//     try {
//       // ✅ 1. สร้าง URL สำหรับ authorize
//       // final authUrl =
//       //     '$authorizationEndpoint?response_type=code&client_id=$clientId'
//       //     '&redirect_uri=$redirectUri'
//       //     '&scope=activity%20heartrate%20oxygen_saturation%20respiratory_rate%20sleep';
//       final authUrl = Uri.https('www.fitbit.com', '/oauth2/authorize', {
//         'response_type': 'code',
//         'client_id': clientId,
//         'redirect_uri':
//             redirectUri, // ตรวจสอบว่าใน Dashboard เป็น myapp://callback หรือไม่
//         'scope': 'activity heartrate oxygen_saturation respiratory_rate sleep',
//       });

//       print('🔗 Fitbit Auth URL: $authUrl');

//       // ✅ 2. เปิดหน้าเว็บให้ผู้ใช้อนุญาต (flutter_web_auth_2 จะรอ redirect กลับเอง)
//       final result = await FlutterWebAuth2.authenticate(
//         url: authUrl.toString(),
//         callbackUrlScheme: 'myapp',
//       );

//       final code = Uri.parse(result).queryParameters['code'];
//       if (code == null) {
//         print('❌ ไม่พบ code ใน redirect URI');
//         return;
//       }

//       print('✅ Authorization Code: $code');

//       // ✅ 4. ขอ access token จาก Fitbit
//       final response = await http.post(
//         Uri.parse(tokenEndpoint),
//         headers: {
//           'Authorization':
//               'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'client_id': clientId,
//           'grant_type': 'authorization_code',
//           'redirect_uri': redirectUri,
//           'code': code,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           accessToken = data['access_token'];
//           refreshToken = data['refresh_token'];
//           userId = data['user_id'];

//           //globalAccessToken = accessToken;
//           //globalUserId = userId;
//         });

//         print('✅ Access Token: $accessToken');
//         print('✅ Refresh Token: $refreshToken');
//         print('✅ Expires In: ${data['expires_in']}');
//         print('✅ UserID: $userId');

//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) =>
//                 FitbitHeartRatePage(accessToken: accessToken!, userId: userId!),
//           ),
//         );
//       } else {
//         print('❌ Token Request Failed: ${response.body}');
//       }
//     } on PlatformException catch (e) {
//       if (e.code == 'CANCELED') {
//         print('⚠️ User canceled login');
//       } else {
//         print('❌ PlatformException: $e');
//       }
//     } catch (e) {
//       print('❌ Error: $e');
//     }

//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (_) =>
//     //         FitbitHeartRatePage(accessToken: accessToken!, userId: userId!),
//     //   ),
//     // );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Fitbit Connect")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _loginWithFitbit,
//               child: Text("Connect to Fitbit"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const HeartRateView()),
//                 );
//               },
//               child: const Text("ดูข้อมูล Heart Rate"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
