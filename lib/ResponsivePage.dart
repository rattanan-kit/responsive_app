import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  const ResponsivePage({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================================
    // 1. [เช็กขนาดจอภาพรวม] ใช้ MediaQuery เพื่อดูความกว้างของหน้าจออุปกรณ์
    // =========================================================================
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700; // ถ้ากว้างกว่า 700 ถือว่าเป็นจอใหญ่

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Responsive UI"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24.0),
        // สลับ Layout อัตโนมัติ: จอใหญ่ใช้แนวนอน (Desktop) จอเล็กใช้แนวตั้ง (Mobile)
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  // =========================================================================
  // 2. [เลย์เอาต์จอใหญ่] วางซ้าย-ขวา ด้วย Row + Expanded
  // =========================================================================
  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded จะแบ่งพื้นที่หน้าจอตามค่า flex (การ์ดกินพื้นที่ 2 ส่วน, ข้อมูล 3 ส่วน)
          Expanded(flex: 2, child: _buildProfileCard()),
          const SizedBox(width: 40),
          Expanded(flex: 3, child: _buildInfoList()),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. [เลย์เอาต์มือถือ] วางบน-ล่าง ด้วย Column
  // =========================================================================
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfileCard(),
          const SizedBox(height: 30),
          _buildInfoList(),
        ],
      ),
    );
  }

  // =========================================================================
  // 4. [การ์ดโปรไฟล์] ใช้ LayoutBuilder เช็กขนาด "พื้นที่ย่อย" 
  // =========================================================================
  Widget _buildProfileCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        // LayoutBuilder จะวัดความกว้างของ "ตัว Card เอง" (ไม่ใช่หน้าจอ)
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                
                // สลับทิศทางปุ่มด้านล่างการ์ด ถ้าการ์ดกว้างให้เรียงแนวนอน ถ้าแคบให้เรียงแนวตั้ง
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

  Widget _buildInfoList() {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      children: [
        _buildInfoItem(Icons.email, "Email", "somchai.dev@email.com"),
        _buildInfoItem(Icons.phone, "Phone", "081-234-5678"),
        _buildInfoItem(Icons.web, "Website", "www.somchai-dev.com"),
        _buildInfoItem(Icons.location_on, "Address", "Nakhon Pathom 73140, Thailand"),
      ],
    );
  }

  // =========================================================================
  // 5. [แถวข้อมูล] ใช้ Spacer ดันข้อความ และ Expanded กันตัวอักษรล้นจอ
  // =========================================================================
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
          
          // Spacer ทำหน้าที่เหมือนสปริง ดันข้อความก้อนขวาให้ชิดขอบจอสุด
          const Spacer(),
          
          // Expanded บังคับให้ข้อความยาวๆ (value) อยู่ในกรอบ ถ้าล้นให้ตัดเป็นจุดไข่ปลา (...)
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.blueGrey),
              overflow: TextOverflow.ellipsis, 
              maxLines: 1, 
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 6. [ปุ่มกด] รับค่า boolean เพื่อขยายปุ่มให้เต็มหน้าจอ
  // =========================================================================
  List<Widget> _buildActionButtons({bool isFullWidth = false}) {
    return [
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          // ถ้า isFullWidth เป็น true จะสั่งให้ปุ่มกว้างสุดเท่าที่จะทำได้ (double.infinity)
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
