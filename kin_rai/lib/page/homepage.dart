import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_rai/db/database_helper.dart';
import 'package:kin_rai/models/health_model.dart';
import 'package:kin_rai/models/menu_model.dart';
import 'package:kin_rai/services/menu_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  late Future<HealthData?> _healthDataFuture;
  late Future<List<MenuModel>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _refreshData(); // โหลดข้อมูลครั้งแรก
    _menuFuture = MenuService.fetchMenus();
  }

  // ฟังก์ชันสำหรับสั่งโหลดข้อมูลใหม่ (เรียกใช้ตอนกดปุ่มเพิ่มข้อมูลเสร็จก็ได้)
  void _refreshData() {
    setState(() {
      _healthDataFuture = DatabaseHelper.instance.getLatestHealthData();
    });
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 229, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 235, 204, 160),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Icon(Icons.person, color: Colors.white),
          ),
        ),
        title: const Text(
          'ยัมมี่',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 228, 192, 141),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // ส่วนที่ดึงข้อมูล SQLite มาแสดง
                  FutureBuilder<HealthData?>(
                    future: _healthDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // ถ้ามีข้อมูลให้ใช้ข้อมูลจาก DB ถ้าไม่มีให้เป็น 0
                      final data = snapshot.data;
                      final calories =
                          data?.calories?.toStringAsFixed(0) ?? '0';
                      final heartRate =
                          data?.heartRate?.toStringAsFixed(0) ?? '0';
                      // หมายเหตุ: ใน table health_data ของคุณไม่มี blood pressure (bp)
                      // ผมเลยใส่เป็นค่าคงที่ไว้ก่อน หรือคุณจะเก็บใน hrv แทนก็ได้ครับ

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 192, 156, 107),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     _buildVitalItem('Heart Rate', heartRate, 'bpm'),
                        //     _buildVitalItem('Sleep', calories, 'min'),
                        //     _buildVitalItem('SpO2', '${data?.spO2 ?? 0}', '%'),
                        //     _buildVitalItem('HRV', '${data?.hrv ?? 0}', 'bpm'),
                        //     _buildVitalItem('Calories', calories, 'kcal'),
                        //   ],
                        // ),
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // กำหนดให้เลื่อนแนวนอน
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              _buildVitalItem(
                                'Calories',
                                data?.caloriesDuration ?? '0',
                                'kcal',
                              ),
                              const SizedBox(
                                width: 10,
                              ), // เพิ่มระยะห่างระหว่างรายการ
                              _buildVitalItem(
                                'Heart Rate',
                                data?.heartRateDuration ?? '0',
                                'bpm',
                              ),
                              const SizedBox(width: 10),
                              _buildVitalItem(
                                'SpO2',
                                '${data?.spO2Duration ?? 0}',
                                '%',
                              ),
                              const SizedBox(width: 10),
                              _buildVitalItem(
                                'Sleep',
                                '${data?.sleepDuration ?? 0}',
                                '',
                              ),
                              const SizedBox(width: 10),
                              _buildVitalItem(
                                'HRV',
                                '${data?.hrvDuration ?? 0}',
                                'ms',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // ข้อมูลสุขภาพ
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 192, 156, 107),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ข้อมูลสุขภาพ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'วันนี้ยังไม่มีเพิ่มข้อมูล',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              223,
                              167,
                              89,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'เพิ่มข้อมูล',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    'เมนูอาหารที่แนะนำ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // รายการอาหาร
                  // _buildFoodItem('แกงจืดหมูสับ', '450 kcal'),
                  // _buildFoodItem('แกงจืดหมูสับ', '450 kcal'),
                  FutureBuilder<List<MenuModel>>(
                    future: _menuFuture,
                    builder: (context, snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const CircularProgressIndicator();
                      // }

                      // if (snapshot.hasError) {
                      //   return Text('Error: ${snapshot.error}');
                      // }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                        );
                      }

                      // ตรวจสอบว่ามีข้อมูลหรือไม่
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('ไม่มีเมนูอาหารแนะนำ'));
                      }

                      final menus = snapshot.data!;
                      return Column(
                        children: menus.map((menu) {
                          return _buildFoodItem(
                            menu.name,
                            '${menu.calories} kcal',
                            menu.imageUrl,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  ElevatedButton(
                    onPressed: (() => signout()),
                    child: Text("ออกจากระบบ"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildVitalItem(String label, String value, String unit) {
  return Container(
    width: 95,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(unit, style: const TextStyle(fontSize: 10)),
      ],
    ),
  );
}

// Widget ย่อยสำหรับบัตรรายการอาหาร
Widget _buildFoodItem(String title, String kcal, String imageUrl) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('ไม่มีรูปภาพ'));
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(kcal),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 223, 167, 89),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: const Size(0, 30),
                  ),
                  child: const Text(
                    'รายละเอียด',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.add_circle_outline, size: 28),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
