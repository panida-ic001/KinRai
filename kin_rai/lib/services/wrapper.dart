import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_rai/page/connect_fitbit.dart';
import 'package:kin_rai/page/login.dart';
import 'package:kin_rai/main.dart';
import 'package:kin_rai/try.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  // State<Wrapper> createState() => _WrapperState();
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. ระหว่างรอการตรวจสอบสถานะ (เช่น ตอนเปิดแอป) ให้โชว์ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ถ้า snapshot มีข้อมูล (User ล็อกอินอยู่)
          if (snapshot.hasData) {
            // ส่งไปหน้าหลักที่มี Bottom Navigation Bar (ที่เราแยกไฟล์ไว้ในตอนแรก)
            // return const MainNavigation();
            return const ConnectFitbit();
          }
          // 3. ถ้าไม่มีข้อมูล (User ยังไม่ล็อกอิน)
          else {
            return const Login();
          }
        },
      ),
    );
  }
}

// class _WrapperState extends State<Wrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ConnectFitbit();
//           } else {
//             return Login();
//           }
//         },
//       ),
//     );
//   }
// }
