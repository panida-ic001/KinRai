import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kin_rai/services/wrapper.dart';
import 'services/background_service.dart';
import 'page/homepage.dart';
import 'page/login.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //BackgroundFetch.registerHeadlessTask(backgroundTask);
  await BackgroundService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return MaterialApp(home: ConnectFitbit());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey),
      //home: const MainNavigation(),
      home: const Wrapper(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  // หน้า
  final List<Widget> _pages = [
    const Homepage(), // หน้าหลักที่เราแยกไฟล์ไว้
    const Center(child: Text('หน้าเพิ่มเมนู')),
    const Center(child: Text('หน้าสรุป')),
    const Center(child: Text('หน้าตั้งค่า')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // ใช้ IndexedStack เพื่อรักษาสถานะหน้าจอเวลาสลับไปมา
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 235, 204, 160),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'เพิ่มเมนู',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'สรุป'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ตั้งค่า'),
        ],
      ),
    );
  }
}

// class HealthPage extends StatefulWidget {
//   // ... โค้ด HealthPage และ _HealthPageState เดิม (ไม่ได้ถูกเรียกใช้เป็นหน้าแรกแล้ว)
//   @override
//   State<HealthPage> createState() => _HealthPageState();
// }

// class _HealthPageState extends State<HealthPage> {
//   final healthService = HealthService();
//   HealthData? lastData;

//   Future<void> fetchAndSave() async {
//     // ... โค้ดที่คอมเมนต์ไว้เดิม
//   }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(title: Text("Fitbit Health Data")),
//     body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: () async {
//               // 1️⃣ log ว่ากดเอง
//               await DatabaseHelper.instance.insertBgLog(
//                 message: 'Manual fetch triggered by user',
//                 runType: 'manual',
//               );

//               // 2️⃣ ดึง + save
//               await HealthService().fetchAndSaveHealthData();

//               // 3️⃣ log เสร็จ
//               await DatabaseHelper.instance.insertBgLog(
//                 message: 'Manual fetch finished',
//                 runType: 'manual',
//               );
//             },
//             child: const Text('ดึงข้อมูลสุขภาพ'),
//           ),
//         ],
//       ),
//     ),
//   );
// }
