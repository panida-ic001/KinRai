// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:kin_rai/wrapper.dart';
// import 'package:get/get.dart';

// class Signup2 extends StatefulWidget {
//   const Signup2({super.key});

//   @override
//   State<Signup2> createState() => _Signup2State();
// }

// class _Signup2State extends State<Signup2> {
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();

//   signris() async {
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email.text,
//       password: password.text,
//     );
//     Get.offAll(Wrapper());

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Sign up")),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Email", style: TextStyle(fontSize: 20)),
//               ),
//               TextFormField(
//                 controller: email,
//                 decoration: InputDecoration(
//                   hintText: 'Enter Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Password", style: TextStyle(fontSize: 20)),
//               ), // เพิ่มระยะห่าง
//               TextFormField(
//                 controller: password,
//                 decoration: InputDecoration(
//                   hintText: 'Enter password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 30),
//               //ElevatedButton(onPressed: (() => signup()), child: Text("Sign up")),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }
