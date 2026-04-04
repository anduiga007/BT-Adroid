import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/sinhvien.dart';
import '../provider/sinhvien_provider.dart';
import 'v_detail_sinhvien.dart';

class SinhVienListScreen extends StatefulWidget {
  const SinhVienListScreen({super.key});

  @override
  State<SinhVienListScreen> createState() => _SinhVienListScreenState();
}

class _SinhVienListScreenState extends State<SinhVienListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<SinhVienProvider>().loadSinhViens());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final provider = context.read<SinhVienProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thêm Sinh Viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration:
              const InputDecoration(labelText: 'Tên Sinh Viên'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final email = emailCtrl.text.trim();
              if (name.isNotEmpty && email.isNotEmpty) {
                provider.addSinhVien(SinhVien(name: name, email: email));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Thêm sinh viên thành công!')),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) =>
                    context.read<SinhVienProvider>().search(val),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sinh viên...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SinhVienProvider>().search('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),

            // ── List ────────────────────────────────────────────
            Expanded(
              child: Consumer<SinhVienProvider>(
                builder: (context, provider, child) {
                  final list = provider.sinhViens;
                  if (list.isEmpty) {
                    return const Center(
                      child: Text(
                        'Chưa có thông tin sinh viên',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final sv = list[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue[100],
                            child: const Icon(Icons.person,
                                color: Colors.blue),
                          ),
                          title: Text(
                            sv.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          subtitle: Text(
                            sv.email,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              provider.deleteSinhVien(sv.id!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Đã xóa sinh viên')),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailSinhVienScreen(sinhVien: sv),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── FAB ───────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}