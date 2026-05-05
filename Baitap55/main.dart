import 'package:flutter/material.dart';
import 'sms_reader_app.dart';
import 'contacts_reader_app.dart';
import 'contacts_list_screen.dart';
import 'sms_analyzer_app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bai 08 - Contact & SMS',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainHomePage(),
    );
  }
}

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main App')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Welcome to the Main App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Bài 08 - Contact & SMS Reader',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),

            _buildCard(context,
                icon: Icons.sms, color: Colors.blue,
                title: 'Bài 1 - SMS Reader',
                subtitle: 'Đọc và hiển thị tin nhắn SMS',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SmsReaderApp()))),
            const SizedBox(height: 12),

            _buildCard(context,
                icon: Icons.contacts, color: Colors.teal,
                title: 'Bài 1 - Contacts Reader',
                subtitle: 'Hiển thị danh bạ điện thoại',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ContactsReaderApp()))),
            const SizedBox(height: 12),

            _buildCard(context,
                icon: Icons.person_add, color: Colors.purple,
                title: 'Bài 2, 3, 4 - Quản lý danh bạ',
                subtitle: 'Thêm / Sửa / Xóa / Tìm kiếm + SQLite',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ContactsListScreen()))),
            const SizedBox(height: 12),

            _buildCard(context,
                icon: Icons.analytics, color: Colors.indigo,
                title: 'Bài 5 - SMS Analyzer',
                subtitle: 'Thống kê, lọc QC, OTP từ tin nhắn',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SmsAnalyzerApp()))),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {
    required IconData icon, required Color color,
    required String title, required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}