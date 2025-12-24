import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_rai/forget.dart';
import 'package:kin_rai/page/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {
    // await FirebaseAuth.instance.signInWithEmailAndPassword(
    //   email: email.text,
    //   password: password.text,
    // );
    try {
      // แสดงสถานะกำลังโหลด (ถ้ามี)
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), // เพิ่ม .trim() เพื่อลบช่องว่างนำหน้า/ต่อท้าย
        password: password.text.trim(),
      );
      // หากสำเร็จ wrapper จะจัดการนำทางไปหน้าถัดไป
    } on FirebaseAuthException catch (e) {
      // ซ่อนสถานะกำลังโหลด (ถ้ามี)

      String message = "เกิดข้อผิดพลาดในการเข้าสู่ระบบ";
      if (e.code == 'user-not-found') {
        message = "ไม่พบผู้ใช้งานด้วยอีเมลนี้";
      } else if (e.code == 'wrong-password') {
        message = "รหัสผ่านไม่ถูกต้อง";
      } else if (e.code == 'invalid-email') {
        message = "รูปแบบอีเมลไม่ถูกต้อง";
      }

      // แสดงข้อความแจ้งเตือน (เช่น SnackBar หรือ Dialog)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      // ซ่อนสถานะกำลังโหลด (ถ้ามี)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาดที่ไม่คาดคิด: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 229, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 204, 160),
        elevation: 0,
        title: Text(
          'Login',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
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
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 250, 250),
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
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 250, 250),
                hintText: 'Enter password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 3),
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Forget()),
                ),
                child: Text(
                  "Forget password",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     ElevatedButton(
            //       onPressed: (() => signIn()),
            //       child: Text("Login"),
            //     ),
            //   ],

            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // ระยะห่างซ้าย-ขวา
              child: ElevatedButton(
                onPressed: () => signIn(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 223, 167, 89),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5, // แถม: เพิ่มเงาให้ปุ่มดูมีมิติ
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 180),
            // ElevatedButton(
            //   onPressed: (() => Get.to(Signup())),
            //   child: Text("Register"),
            // ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                ),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
