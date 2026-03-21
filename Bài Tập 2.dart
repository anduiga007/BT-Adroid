import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoMo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const MoMoScreen(),
    );
  }
}

const List<Map<String, dynamic>> _services1 = [
  {'icon': Icons.monetization_on_outlined, 'label': 'Chuyển tiền',           'color': Color(0xFFE91E8C)},
  {'icon': Icons.receipt_long_outlined,    'label': 'Thanh toán\nhóa đơn',   'color': Color(0xFF1976D2)},
  {'icon': Icons.phone_android_outlined,   'label': 'Nạp tiền điện\nthoại',  'color': Color(0xFF00897B)},
  {'icon': Icons.credit_card_outlined,     'label': 'Mua mã thẻ di\nđộng',   'color': Color(0xFFE65100)},
];

const List<Map<String, dynamic>> _services2 = [
  {'icon': Icons.savings_outlined,                'label': 'Heo Đất MoMo',    'color': Color(0xFFE91E8C)},
  {'icon': Icons.directions_walk_outlined,        'label': 'Đi bộ cùng\nMoMo','color': Color(0xFF43A047)},
  {'icon': Icons.water_drop_outlined,             'label': 'Thanh toán\nnước', 'color': Color(0xFF1E88E5)},
  {'icon': Icons.account_balance_wallet_outlined, 'label': 'Quản lý chi\ntiêu','color': Color(0xFFAB47BC)},
];

const List<Map<String, dynamic>> _services3 = [
  {'icon': Icons.groups_outlined,     'label': 'Quỹ nhóm',         'color': Color(0xFFE91E8C)},
  {'icon': Icons.show_chart_outlined, 'label': 'Chứng Khoán',      'color': Color(0xFF1565C0)},
  {'icon': Icons.sms_outlined,        'label': 'Vietlott SMS',      'color': Color(0xFFE53935)},
  {'icon': Icons.apps_outlined,       'label': 'Xem thêm\ndịch vụ','color': Color(0xFF757575)},
];

const List<Map<String, dynamic>> _deXuat = [
  {'icon': Icons.flash_on_outlined,               'label': 'Vay Nhanh',    'color': Color(0xFFE91E8C)},
  {'icon': Icons.movie_outlined,                  'label': 'Mua vé xem ...','color': Color(0xFF1976D2)},
  {'icon': Icons.auto_awesome_outlined,           'label': 'Túi Thần Tài', 'color': Color(0xFFFFB300)},
  {'icon': Icons.account_balance_wallet_outlined, 'label': 'Ví Trả Sau',   'color': Color(0xFF00897B)},
];

class MoMoScreen extends StatelessWidget {
  const MoMoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceGrid(),
                    _buildSectionTitle('Sự kiện đang diễn ra'),
                    _buildEventBanner(),
                    _buildSectionTitle('MoMo đề xuất'),
                    _buildDeXuat(),
                    _buildGieoQueBanner(),
                    _buildSectionTitle('Có thể bạn quan tâm'),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          _buildServiceRow(_services1),
          const SizedBox(height: 16),
          _buildServiceRow(_services2),
          const SizedBox(height: 16),
          _buildServiceRow(_services3),
        ],
      ),
    );
  }

  Widget _buildServiceRow(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.map(_buildServiceIcon).toList(),
    );
  }

  Widget _buildServiceIcon(Map<String, dynamic> item) {
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(
            item['label'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildEventBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFF7043)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('🎊', style: TextStyle(fontSize: 38))),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tích Lộc cộng nhiều',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  const Text('Thưởng cuối cộng lớn',
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                  const Text('Đến 50 triệu',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E8C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('CHƠI NGAY',
                        style: TextStyle(color: Colors.white, fontSize: 11,
                            fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeXuat() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _deXuat.map(_buildServiceIcon).toList(),
      ),
    );
  }

  Widget _buildGieoQueBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD54F)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E8C).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Color(0xFFE91E8C), size: 20),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('2025 nhờ ai mà nở hoa?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                Text('Gieo quẻ với AI, tìm quý nhân của bạn',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E8C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Gieo ngay',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    const tabs = [
      {'icon': Icons.home_outlined,        'label': 'MoMo',       'active': true},
      {'icon': Icons.local_offer_outlined, 'label': 'Ưu đãi',     'active': false},
      {'icon': Icons.qr_code_scanner,      'label': 'Quét mã QR', 'active': false},
      {'icon': Icons.history_outlined,     'label': 'Lịch sử GD', 'active': false},
      {'icon': Icons.person_outline,       'label': 'Tài',        'active': false},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final tab = tabs[i];
          final isActive = tab['active'] as bool;
          final isQR = i == 2;

          if (isQR) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 4, top: 2),
                  width: 52, height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE91E8C),
                    boxShadow: [BoxShadow(color: Color(0x44E91E8C), blurRadius: 8, offset: Offset(0, 3))],
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 26),
                ),
                const Text('Quét mã QR', style: TextStyle(fontSize: 10, color: Color(0xFFE91E8C))),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab['icon'] as IconData,
                    color: isActive ? const Color(0xFFE91E8C) : Colors.grey, size: 24),
                const SizedBox(height: 2),
                Text(tab['label'] as String,
                    style: TextStyle(
                        fontSize: 10,
                        color: isActive ? const Color(0xFFE91E8C) : Colors.grey)),
              ],
            ),
          );
        }),
      ),
    );
  }
}