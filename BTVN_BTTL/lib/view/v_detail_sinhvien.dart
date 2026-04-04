import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/sinhvien.dart';
import '../provider/sinhvien_provider.dart';

class DetailSinhVienScreen extends StatefulWidget {
  final SinhVien sinhVien;

  const DetailSinhVienScreen({super.key, required this.sinhVien});

  @override
  State<DetailSinhVienScreen> createState() => _DetailSinhVienScreenState();
}

class _DetailSinhVienScreenState extends State<DetailSinhVienScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.sinhVien.name);
    _emailCtrl = TextEditingController(text: widget.sinhVien.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Tìm kiếm sinh viên...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Detail card ──────────────────────────────────
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin chi tiết của sinh viên',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dữ liệu: ${widget.sinhVien.id} ${widget.sinhVien.name}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text('Tên Sinh Viên',
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Email',
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey)),
                      TextField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Hủy'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final name = _nameCtrl.text.trim();
                              final email = _emailCtrl.text.trim();
                              if (name.isNotEmpty && email.isNotEmpty) {
                                context
                                    .read<SinhVienProvider>()
                                    .updateSinhVien(
                                  SinhVien(
                                    id: widget.sinhVien.id,
                                    name: name,
                                    email: email,
                                  ),
                                );
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text('Cập nhật thành công!')),
                                );
                              }
                            },
                            child: const Text('Cập nhật'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}