import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/chitieu.dart';
import '../provider/chitieu_provider.dart';

class ChiTieuScreen extends StatefulWidget {
  const ChiTieuScreen({super.key});

  @override
  State<ChiTieuScreen> createState() => _ChiTieuScreenState();
}

class _ChiTieuScreenState extends State<ChiTieuScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ChiTieuProvider>().loadChiTieus());
  }

  String _formatMoney(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
    );
  }

  String _today() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';
  }

  void _showAddDialog(BuildContext context, {ChiTieu? existing}) {
    final noiDungCtrl =
    TextEditingController(text: existing?.noiDung ?? '');
    final soTienCtrl = TextEditingController(
        text: existing?.soTien.toString() ?? '');
    final ghiChuCtrl =
    TextEditingController(text: existing?.ghiChu ?? '');
    final provider = context.read<ChiTieuProvider>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet,
                color: Colors.green[700]),
            const SizedBox(width: 8),
            Text(existing == null ? 'Thêm Chi Tiêu' : 'Sửa Chi Tiêu'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noiDungCtrl,
                decoration: InputDecoration(
                  labelText: 'Nội dung chi tiêu',
                  prefixIcon: const Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: soTienCtrl,
                decoration: InputDecoration(
                  labelText: 'Số tiền (VNĐ)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ghiChuCtrl,
                decoration: InputDecoration(
                  labelText: 'Ghi chú',
                  prefixIcon: const Icon(Icons.note_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 2,
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final noiDung = noiDungCtrl.text.trim();
              final soTien =
                  double.tryParse(soTienCtrl.text.trim()) ?? 0;
              final ghiChu = ghiChuCtrl.text.trim();

              if (noiDung.isNotEmpty && soTien > 0) {
                if (existing == null) {
                  provider.addChiTieu(ChiTieu(
                    noiDung: noiDung,
                    soTien: soTien,
                    ghiChu: ghiChu,
                    ngay: _today(),
                  ));
                } else {
                  provider.updateChiTieu(ChiTieu(
                    id: existing.id,
                    noiDung: noiDung,
                    soTien: soTien,
                    ghiChu: ghiChu,
                    ngay: existing.ngay,
                  ));
                }
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(existing == null
                        ? 'Đã thêm chi tiêu!'
                        : 'Đã cập nhật!'),
                    backgroundColor: Colors.green[700],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Consumer<ChiTieuProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // ── Header + Tổng chi tiêu ───────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[800]!,
                        Colors.green[500]!
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Quản lý Chi Tiêu',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 4),
                      const Text('Tổng chi tiêu',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatMoney(provider.tongChiTieu)} VNĐ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.chiTieus.length} khoản chi tiêu',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // ── List ────────────────────────────────────
                Expanded(
                  child: provider.chiTieus.isEmpty
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wallet_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Chưa có khoản chi tiêu nào',
                            style:
                            TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.chiTieus.length,
                    itemBuilder: (context, index) {
                      final ct = provider.chiTieus[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(
                              Icons.payments_outlined,
                              color: Colors.green[700],
                            ),
                          ),
                          title: Text(
                            ct.noiDung,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (ct.ghiChu.isNotEmpty)
                                Text(ct.ghiChu,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 12,
                                      color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(ct.ngay,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_formatMoney(ct.soTien)} đ',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () => _showAddDialog(
                                        context,
                                        existing: ct),
                                    child: const Icon(Icons.edit,
                                        color: Colors.orange,
                                        size: 18),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => provider
                                        .deleteChiTieu(ct.id!),
                                    child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}