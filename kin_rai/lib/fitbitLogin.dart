// import 'dart:convert';
// import 'dart:math';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_appauth/flutter_appauth.dart';
// import 'dart:async';
// //import 'package:http/http.dart' as http;

// class ConnectSmart3 extends StatefulWidget {
//   const ConnectSmart3({super.key});

//   @override
//   State<ConnectSmart3> createState() => _ConnectSmartState();
// }

// class _ConnectSmartState extends State<ConnectSmart3> {
//   final clientId = '23TJJY';
//   final redirectUri = 'http://localhost';
//   final FitBitAuthUrl = 'https://www.fitbit.com/oauth2/authorize';
//   final FitBitTokenUrl = 'https://api.fitbit.com/oauth2/token';

//   late final String codeVerifier;
//   late final String codeChallenge;
//   //late final Uri fitbitAuthUrl;

//   final FlutterAppAuth appAuth = FlutterAppAuth();

//   // ✅ ฟังก์ชันสุ่ม code_verifier
//   String _generateCodeVerifier([int length = 64]) {
//     final random = Random.secure();
//     final values = List<int>.generate(length, (i) => random.nextInt(256));
//     return base64UrlEncode(
//       values,
//     ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
//   }

//   // ✅ ฟังก์ชันสร้าง code_challenge จาก verifier
//   String _generateCodeChallenge(String verifier) {
//     final bytes = ascii.encode(verifier);
//     final digest = sha256.convert(bytes);
//     return base64UrlEncode(
//       digest.bytes,
//     ).replaceAll('=', '').replaceAll('+', '-').replaceAll('/', '_');
//   }

//   @override
//   void initState() {
//     super.initState();

//     // ✅ สุ่มค่าตอนเริ่มต้น
//     codeVerifier = _generateCodeVerifier();
//     codeChallenge = _generateCodeChallenge(codeVerifier);

//     // ✅ กำหนด fitbitAuthUrl ที่นี่ เพราะตอนนี้สามารถใช้ clientId / redirectUri ได้แล้ว
//     fitbitAuthUrl = Uri.https('www.fitbit.com', '/oauth2/authorize', {
//       'client_id': clientId,
//       'response_type': 'code',
//       'code_challenge': codeChallenge,
//       'code_challenge_method': 'S256',
//       //'redirect_uri': redirectUri,
//       'scope':
//           'activity heartrate oxygen_saturation respiratory_rate settings sleep weight',
//     });

//     print('✅ code_verifier: $codeVerifier');
//     print('✅ code_challenge: $codeChallenge');
//   }

//   Future<void> loginWithFitbit() async {
//     try {
//       final launched = await launchUrl(
//         fitbitAuthUrl,
//         mode: LaunchMode.externalApplication,
//       );
//       if (!launched) {
//         print('เปิด URL ไม่ได้');
//       }
//     } catch (e) {
//       print('เกิดข้อผิดพลาด: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Fitbit Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: loginWithFitbit,
//           child: Text('Login with Fitbit'),
//         ),
//       ),
//     );
//   }
// }


// // //--------------------------------------------------------------------------------------------
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_appauth/flutter_appauth.dart';

// // // class ConnectSmart extends StatefulWidget {
// // //   const ConnectSmart({super.key});

// // //   @override
// // //   State<ConnectSmart> createState() => _ConnectSmartState();
// // // }

// // // class _ConnectSmartState extends State<ConnectSmart> {
// // //   final clientId = '23TJJY';
// // //   final redirectUri = 'myapp://auth'; // ต้องแก้ใน Fitbit dashboard ด้วย!
// // //   final authorizationEndpoint = 'https://www.fitbit.com/oauth2/authorize';
// // //   final tokenEndpoint = 'https://api.fitbit.com/oauth2/token';

// // //   final FlutterAppAuth appAuth = FlutterAppAuth();

// // //   Future<void> loginWithFitbit() async {
// // //     try {
// // //       final result = await appAuth.authorizeAndExchangeCode(
// // //         AuthorizationTokenRequest(
// // //           clientId,
// // //           redirectUri,
// // //           serviceConfiguration: AuthorizationServiceConfiguration(
// // //             authorizationEndpoint: authorizationEndpoint,
// // //             tokenEndpoint: tokenEndpoint,
// // //           ),
// // //           scopes: [
// // //             'activity',
// // //             'heartrate',
// // //             'oxygen_saturation',
// // //             'respiratory_rate',
// // //             'settings',
// // //             'sleep',
// // //             'weight',
// // //           ],
// // //         ),
// // //       );

// // //       if (result != null && result.accessToken != null) {
// // //         print("✔️ access token: ${result.accessToken}");
// // //       } else {
// // //         print("ไม่สามารถเข้าระบบหรือไม่ได้รับ token");
// // //       }
// // //     } catch (e) {
// // //       print('เกิดข้อผิดพลาด: $e');
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Fitbit Login')),
// // //       body: Center(
// // //         child: ElevatedButton(
// // //           onPressed: loginWithFitbit,
// // //           child: const Text('Login with Fitbit'),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

