import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_rai/services/wrapper.dart';
import 'package:get/get.dart';
//import 'package:kin_rai/signup_2.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signup() async {
    // await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //   email: email.text.trim(),
    //   password: password.text.trim(),
    // );
    // Get.offAll(Wrapper());
    try {
      // 1. ตรวจสอบว่ามีข้อมูลครบไหม
      if (email.text.isEmpty || password.text.isEmpty) {
        Get.snackbar("แจ้งเตือน", "กรุณากรอกข้อมูลให้ครบถ้วน");
        return;
      }

      // 2. ส่งข้อมูลไป Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // 3. ถ้ามาถึงบรรทัดนี้แปลว่าสำเร็จ
      print("✅Signup Success!");
      Get.offAll(() => const Wrapper()); // ใช้ Arrow function ใน Get.offAll
    } on FirebaseAuthException catch (e) {
      // ดักจับ Error จาก Firebase โดยเฉพาะ
      String message = "";
      if (e.code == 'weak-password') {
        message = "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร";
      } else if (e.code == 'email-already-in-use') {
        message = "อีเมลนี้ถูกใช้งานไปแล้ว";
      } else {
        message = e.message ?? "เกิดข้อผิดพลาด";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print(e); // พิมพ์ error อื่นๆ ลง console
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Email", style: TextStyle(fontSize: 20)),
            ),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                hintText: 'Enter Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Password", style: TextStyle(fontSize: 20)),
            ), // เพิ่มระยะห่าง
            TextFormField(
              controller: password,
              decoration: InputDecoration(
                hintText: 'Enter password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: (() => signup()), child: Text("Sign up")),
            // ElevatedButton(
            //   onPressed: () {
            //     signup();
            //     Get.to(signris());
            //   },
            //   child: Text("Sign up"),
            // ),
          ],
        ),
      ),
    );
  }
}
