import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/sanpham.dart';
import '../provider/sanpham_provider.dart';

class SanPhamScreen extends StatefulWidget {
  const SanPhamScreen({super.key});

  @override
  State<SanPhamScreen> createState() => _SanPhamScreenState();
}

class _SanPhamScreenState extends State<SanPhamScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<SanPhamProvider>().loadSanPhams());
  }

  void _showAddDialog(BuildContext context, {SanPham? existing}) {
    final maCtrl = TextEditingController(text: existing?.maSP ?? '');
    final tenCtrl = TextEditingController(text: existing?.tenSP ?? '');
    final giaCtrl = TextEditingController(
        text: existing?.donGia.toString() ?? '');
    final giamCtrl = TextEditingController(
        text: existing?.giamGia.toString() ?? '0');
    final provider = context.read<SanPhamProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing == null ? 'Thêm Sản Phẩm' : 'Cập nhật Sản Phẩm'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: maCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mã sản phẩm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tenCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên sản phẩm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: giaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Đơn giá (VNĐ)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: giamCtrl,
                decoration: const InputDecoration(
                  labelText: 'Giảm giá (VNĐ)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final ma = maCtrl.text.trim();
              final ten = tenCtrl.text.trim();
              final gia = double.tryParse(giaCtrl.text.trim()) ?? 0;
              final giam = double.tryParse(giamCtrl.text.trim()) ?? 0;

              if (ma.isNotEmpty && ten.isNotEmpty && gia > 0) {
                if (existing == null) {
                  provider.addSanPham(SanPham(
                    maSP: ma,
                    tenSP: ten,
                    donGia: gia,
                    giamGia: giam,
                  ));
                } else {
                  provider.updateSanPham(SanPham(
                    id: existing.id,
                    maSP: ma,
                    tenSP: ten,
                    donGia: gia,
                    giamGia: giam,
                  ));
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null
                        ? 'Thêm sản phẩm thành công!'
                        : 'Cập nhật thành công!'),
                  ),
                );
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Sản Phẩm'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Consumer<SanPhamProvider>(
        builder: (context, provider, child) {
          final list = provider.sanPhams;
          if (list.isEmpty) {
            return const Center(
              child: Text('Chưa có sản phẩm nào',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final sp = list[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                  BorderRadius.circular(6),
                                ),
                                child: Text(
                                  sp.maSP,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                sp.tenSP,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange, size: 20),
                                onPressed: () => _showAddDialog(
                                    context,
                                    existing: sp),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                onPressed: () =>
                                    provider.deleteSanPham(sp.id!),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),

                      _InfoRow(
                          label: 'Đơn giá',
                          value:
                          '${_formatMoney(sp.donGia)} VNĐ',
                          color: Colors.black87),
                      _InfoRow(
                          label: 'Giảm giá',
                          value:
                          '${_formatMoney(sp.giamGia)} VNĐ',
                          color: Colors.green),
                      _InfoRow(
                          label: 'Thuế NK (10%)',
                          value:
                          '${_formatMoney(sp.tinhThueNhapKhau())} VNĐ',
                          color: Colors.orange),
                      _InfoRow(
                          label: 'Giá sau giảm',
                          value:
                          '${_formatMoney(sp.giaSauGiam())} VNĐ',
                          color: Colors.blue,
                          bold: true),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}


class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool bold;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.color,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight:
              bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}