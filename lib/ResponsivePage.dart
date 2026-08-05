import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ใช้ MediaQuery ตรวจสอบความกว้างหน้าจอเพื่อแบ่ง Layout หลัก
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Responsive UI"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: isDesktop 
          ? _buildDesktopLayout() 
          : _buildMobileLayout(),
      ),
    );
  }

  // --- เลย์เอาต์สำหรับหน้าจอใหญ่ (Desktop/Tablet) ---
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Row(
        // จัดให้ลูกๆ ใน Row อยู่ตรงกลางแนวตั้ง (Cross Axis) เสมอกัน
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: _buildProfileCard()),
          const SizedBox(width: 40),
          Expanded(flex: 3, child: _buildInfoList()),
        ],
      ),
    );
  }

  // --- เลย์เอาต์สำหรับหน้าจอมือถือ (Mobile) ---
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        // จัดให้ลูกๆ ใน Column อยู่ตรงกลางแนวตั้ง (Main Axis) ของหน้าจอ
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileCard(),
          const SizedBox(height: 30),
          _buildInfoList(),
        ],
      ),
    );
  }

  // Widget ส่วนบัตรโปรไฟล์ (ใช้ LayoutBuilder)
  Widget _buildProfileCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // เช็กพื้นที่ภายใน Card เพื่อปรับรูปแบบปุ่ม
            bool isWideCard = constraints.maxWidth > 350;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "สมชาย รักเรียน?",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text("Software Developer"),
                const SizedBox(height: 20),
                
                // การใช้ Flex สลับทิศทางปุ่มตามความกว้างของ Card
                isWideCard 
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildActionButtons(isFullWidth: false),
                    )
                  : Column(
                      children: _buildActionButtons(isFullWidth: true),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget ส่วนรายการข้อมูล (ใช้ Spacer ขยายเนื้อที่ว่าง)
  Widget _buildInfoList() {
    return Column(
      mainAxisSize: MainAxisSize.min, // ให้ Column สูงเท่ากับเนื้อหาจริง
      children: [
        _buildInfoItem(Icons.email, "Email", "somchai.dev@email.com"),
        _buildInfoItem(Icons.phone, "Phone", "081-234-5678"),
        _buildInfoItem(Icons.web, "Website", "www.somchai-dev.com"),
        _buildInfoItem(Icons.location_on, "Address", "Nakhon Pathom 73140, Thailand"),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          // ใช้ Spacer ดันข้อมูลไปทางขวาสุดโดยอัตโนมัติ
          const Spacer(),
          Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end, // ชิดขวา
            style: const TextStyle(color: Colors.blueGrey),
            overflow: TextOverflow.ellipsis, // ถ้ายังเกินพื้นที่ ให้ใส่ ...
            maxLines: 1, 
          ),
        ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons({bool isFullWidth = false}) {
    return [
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: isFullWidth ? const Size(double.infinity, 45) : null,
        ),
        child: const Text("Message"),
      ),
      const SizedBox(width: 10, height: 10),
      OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          minimumSize: isFullWidth ? const Size(double.infinity, 45) : null,
        ),
        child: const Text("Follow"),
      ),
    ];
  }
}