import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quà của Vinh',
      debugShowCheckedModeBanner: false,
      home: const QuaScreen(),
    );
  }
}

const List<Map<String, dynamic>> _vouchers = [
  {
    'brandLabel': 'CGV',
    'brandColor': Color(0xFFE53935),
    'brandIcon': Icons.movie_outlined,
    'tieuDe': 'CGV -',
    'moTa': 'Đồng giá 79K khi mua vé CGV 2D trên M...',
    'hsd': 'HSD: 28/02/2025',
    'hsdRed': false,
    'tag': null,
    'tagColor': null,
    'nutLabel': 'Dùng ngay',
    'isOutline': false,
    'liked': false,
  },
  {
    'brandLabel': 'Mua Sim\nchính chủ',
    'brandColor': Color(0xFF1976D2),
    'brandIcon': Icons.sim_card_outlined,
    'tieuDe': 'Giảm 100K',
    'moTa': 'Cho đơn từ 0đ',
    'hsd': 'HSD: 28/02/2025',
    'hsdRed': false,
    'tag': null,
    'tagColor': null,
    'nutLabel': 'Dùng ngay',
    'isOutline': false,
    'liked': true,
  },
  {
    'brandLabel': 'Ngân hàng\nQuốc Tế VIB',
    'brandColor': Color(0xFF1565C0),
    'brandIcon': Icons.account_balance_outlined,
    'tieuDe': 'Tặng 100k',
    'moTa': 'Khi mở thẻ VIB Online Plus 2in1 (*)',
    'hsd': 'HSD: 31/03/2025',
    'hsdRed': false,
    'tag': 'Quà hiện vật',
    'tagColor': Color(0xFF43A047),
    'nutLabel': 'Dùng ngay',
    'isOutline': false,
    'liked': false,
  },
  {
    'brandLabel': 'Thanh toán\nBảo hiểm',
    'brandColor': Color(0xFF00897B),
    'brandIcon': Icons.umbrella_outlined,
    'tieuDe': 'Hoàn 15K',
    'moTa': 'Cho hóa đơn từ 3.000.000đ',
    'hsd': 'Hết hạn sau 5 ngày',
    'hsdRed': true,
    'tag': null,
    'tagColor': null,
    'nutLabel': 'Dùng ngay',
    'isOutline': false,
    'liked': false,
  },
  {
    'brandLabel': 'Phi không\ndừng',
    'brandColor': Color(0xFFE65100),
    'brandIcon': Icons.local_gas_station_outlined,
    'tieuDe': 'Giảm 10K',
    'moTa': 'Cho đơn từ 100K',
    'hsd': null,
    'hsdRed': false,
    'tag': 'KM đa tặng',
    'tagColor': Color(0xFF795548),
    'nutLabel': 'Thu thập',
    'isOutline': true,
    'liked': false,
  },
];

class QuaScreen extends StatelessWidget {
  const QuaScreen({super.key});

  static const _pink = Color(0xFFE91E8C);
  static const _bgColor = Color(0xFFFCEEF3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildFilterRow(),
            _buildXuRow(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                itemCount: _vouchers.length,
                itemBuilder: (_, i) => _VoucherCard(data: _vouchers[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.black87),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Quà của Vinh (7)',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(Icons.notifications_none, color: Colors.black54),
          const SizedBox(width: 14),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black38),
            ),
            child: const Icon(Icons.close, size: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    const filters = [
      {'label': 'Sắp xếp', 'hasFilter': true},
      {'label': 'Dịch vụ', 'hasFilter': false},
      {'label': 'Gần tôi', 'hasFilter': false},
      {'label': 'Yêu thíc', 'hasFilter': false},
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        children: filters.map((f) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFDDDDDD)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (f['hasFilter'] == true) ...[
                    const Icon(Icons.filter_list, size: 13, color: Colors.black54),
                    const SizedBox(width: 3),
                  ],
                  Text(f['label'] as String,
                      style: const TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(width: 3),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: Colors.black54),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildXuRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        children: [
          // Đang có xu
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFB300),
                    ),
                    child: const Icon(Icons.monetization_on,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đang có',
                          style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text('1.955 Xu',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          )),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right,
                      color: Colors.grey, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E8C), Color(0xFFAD1457)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.card_giftcard,
                      color: Colors.white, size: 17),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bỏ túi ngay',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                    Text('4 thẻ quà',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        )),
                  ],
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right,
                    color: Colors.white70, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _VoucherCard({required this.data});

  static const _pink = Color(0xFFE91E8C);

  @override
  Widget build(BuildContext context) {
    final brandColor = data['brandColor'] as Color;
    final isOutline = data['isOutline'] as bool;
    final liked = data['liked'] as bool;
    final hsdRed = data['hsdRed'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 68,
              child: Column(
                children: [
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                      color: brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(data['brandIcon'] as IconData,
                        color: brandColor, size: 28),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data['brandLabel'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 10, color: Colors.black54, height: 1.3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  if (data['tag'] != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: (data['tagColor'] as Color).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['tag'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: data['tagColor'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],

                  Text(
                    data['tieuDe'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    data['moTa'] as String,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),

                  // HSD
                  if (data['hsd'] != null)
                    Text(
                      data['hsd'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: hsdRed
                            ? const Color(0xFFE53935)
                            : Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 8),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 7),
                      decoration: BoxDecoration(
                        color: isOutline ? Colors.white : _pink,
                        borderRadius: BorderRadius.circular(20),
                        border:
                        isOutline ? Border.all(color: _pink) : null,
                      ),
                      child: Text(
                        data['nutLabel'] as String,
                        style: TextStyle(
                          color: isOutline ? _pink : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                liked ? Icons.favorite : Icons.favorite_border,
                color: liked ? _pink : Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
