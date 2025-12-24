// import 'package:url_launcher/url_launcher.dart';

// final clientId = 'db870d61a4cea34f8bb349118c44e735';
// final redirectUri = 'http://localhost';
// final fitbitAuthUrl = Uri.https('www.fitbit.com', '/oauth2/authorize', {
//   'response_type': 'token',
//   'client_id': clientId,
//   'redirect_uri': redirectUri,
//   'scope': 'activity sleep heartrate profile',
//   'expires_in': '604800',
// });

// void loginWithFitbit() async {
//   // เปิด browser ให้ผู้ใช้ล็อกอิน
//   if (await canLaunchUrl(fitbitAuthUrl)) {
//     await launchUrl(fitbitAuthUrl, mode: LaunchMode.externalApplication);
//   } else {
//     print('ไม่สามารถเปิด url ได้');
//   }
// }
