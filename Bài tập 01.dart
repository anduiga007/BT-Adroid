import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListViewDemo',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}


const List<String> _deTai = ['Đồ án', 'KLKS', 'Luận văn', 'Khác'];

const List<Map<String, String>> _chuyenNganh = [
  {
    'ten': 'Công nghệ phần mềm',
    'moTa': 'Phát triển các ứng dụng giải quyết các vấn đề thực tế',
  },
  {
    'ten': 'Hệ thống thông tin',
    'moTa': 'Phát triển các kỹ thuật xử lý thông tin trong tổ chức',
  },
  {
    'ten': 'Mạng máy tính',
    'moTa': 'Xử lý các vấn đề liên quan đến mạng máy tính',
  },
  {
    'ten': 'An toàn thông tin',
    'moTa': 'Thiết kế và đảm bảo an toàn cho hệ thống máy tính',
  },
];


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDeTai = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107),
        elevation: 0,
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text(
          'ListView Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Chọn loại đề tài'),

          _buildDeTaiRow(),

          _buildLabel('Chọn chuyên ngành thực hiện'),

          Expanded(child: _buildChuyenNganhList()),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF29B6F6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDeTaiRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_deTai.length, (i) {
            final selected = _selectedDeTai == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedDeTai = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? const Color(0xFF4A148C)
                      : const Color(0xFF7B1FA2),
                ),
                child: Center(
                  child: Text(
                    _deTai[i],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildChuyenNganhList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      itemCount: _chuyenNganh.length,
      itemBuilder: (context, i) {
        final item = _chuyenNganh[i];
        return _buildNganhItem(item);
      },
    );
  }

  Widget _buildNganhItem(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFBDBDBD).withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.home, color: Colors.black54, size: 26),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['ten']!,
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item['moTa']!,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward, color: Colors.black54, size: 20),
        ],
      ),
    );
  }
}
