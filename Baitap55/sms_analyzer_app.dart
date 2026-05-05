import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsAnalyzerApp extends StatelessWidget {
  const SmsAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS Analyzer',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const SmsAnalyzerHome(),
    );
  }
}

class SmsAnalyzerHome extends StatefulWidget {
  const SmsAnalyzerHome({super.key});

  @override
  State<SmsAnalyzerHome> createState() => _SmsAnalyzerHomeState();
}

class _SmsAnalyzerHomeState extends State<SmsAnalyzerHome>
    with SingleTickerProviderStateMixin {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _allMessages = [];
  bool _isLoading = true;
  String _error = '';
  late TabController _tabController;

  // Filter theo số điện thoại
  final TextEditingController _filterController = TextEditingController();
  List<SmsMessage> _filteredByPhone = [];
  bool _hasFiltered = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializePermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  Future<void> _initializePermissions() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      _loadMessages();
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Chưa được cấp quyền đọc SMS!';
      });
    }
  }

  Future<void> _loadMessages() async {
    setState(() { _isLoading = true; _error = ''; });
    try {
      final msgs = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        count: 200,
      );
      setState(() {
        _allMessages = msgs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _isLoading = false; _error = 'Lỗi: $e'; });
    }
  }

  // ── Phân loại ──
  List<SmsMessage> get _adMessages => _allMessages
      .where((m) => (m.body ?? '').startsWith('[QC]'))
      .toList();

  List<SmsMessage> get _otpMessages => _allMessages
      .where((m) => _extractOtp(m.body ?? '') != null)
      .toList();

  String? _extractOtp(String body) {
    final match = RegExp(r'\[OTP\][^\d]*(\d{6})').firstMatch(body);
    return match?.group(1);
  }

  // Thống kê theo ngày
  Map<String, int> get _statsByDate {
    final map = <String, int>{};
    for (final msg in _allMessages) {
      if (msg.date == null) continue;
      final key = '${msg.date!.day}/${msg.date!.month}/${msg.date!.year}';
      map[key] = (map[key] ?? 0) + 1;
    }
    final sorted = Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
    return sorted;
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _filterByPhone() {
    final phone = _filterController.text.trim();
    if (phone.isEmpty) return;
    setState(() {
      _filteredByPhone = _allMessages
          .where((m) => (m.sender ?? '').contains(phone))
          .toList();
      _hasFiltered = true;
    });
  }

  // ── Widget hiển thị OTP ──
  void _showOtpDialog(String body) {
    final otp = _extractOtp(body);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mã OTP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(otp ?? '', style: const TextStyle(
              fontSize: 36, fontWeight: FontWeight.bold,
              letterSpacing: 8, color: Colors.indigo,
            )),
            const SizedBox(height: 12),
            Text(body, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Analyzer'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMessages),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Tổng quan (${_allMessages.length})'),
            Tab(text: 'Lọc số ĐT'),
            Tab(text: 'QC (${_adMessages.length})'),
            Tab(text: 'OTP (${_otpMessages.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(_error),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _initializePermissions, child: const Text('Thử lại')),
        ],
      ))
          : TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildFilterByPhoneTab(),
          _buildAdTab(),
          _buildOtpTab(),
        ],
      ),
    );
  }


  Widget _buildOverviewTab() {
    final stats = _statsByDate;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Thẻ tổng số
        Card(
          color: Colors.indigo.shade50,
          child: ListTile(
            leading: const Icon(Icons.sms, color: Colors.indigo, size: 36),
            title: const Text('Tổng số tin nhắn nhận được',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text('${_allMessages.length}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo)),
          ),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _statCard('Quảng cáo [QC]', _adMessages.length, Colors.orange, Icons.campaign)),
          const SizedBox(width: 8),
          Expanded(child: _statCard('Mã OTP', _otpMessages.length, Colors.green, Icons.lock)),
        ]),
        const SizedBox(height: 16),
        const Text('Thống kê theo ngày',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...stats.entries.map((e) => ListTile(
          dense: true,
          leading: const Icon(Icons.calendar_today, size: 18, color: Colors.indigo),
          title: Text(e.key),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${e.value} tin', style: const TextStyle(color: Colors.indigo)),
          ),
        )),
      ],
    );
  }

  Widget _statCard(String label, int count, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterByPhoneTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(
                    labelText: 'Nhập số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onSubmitted: (_) => _filterByPhone(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _filterByPhone, child: const Text('Lọc')),
            ],
          ),
        ),
        if (_hasFiltered)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${_filteredByPhone.length} tin nhắn từ "${_filterController.text}"',
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ),
          ),
        Expanded(
          child: !_hasFiltered
              ? const Center(child: Text('Nhập số điện thoại để lọc tin nhắn'))
              : _filteredByPhone.isEmpty
              ? const Center(child: Text('Không có tin nhắn nào từ số này.'))
              : ListView.separated(
            itemCount: _filteredByPhone.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final msg = _filteredByPhone[i];
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(Icons.sms, color: Colors.blue),
                ),
                title: Text(msg.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(_formatDate(msg.date)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdTab() {
    return _adMessages.isEmpty
        ? const Center(child: Text('Không có tin nhắn quảng cáo nào.'))
        : ListView.separated(
      itemCount: _adMessages.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final msg = _adMessages[i];
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFFF3E0),
            child: Icon(Icons.campaign, color: Colors.orange),
          ),
          title: Text(msg.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text('Từ: ${msg.sender ?? ''}\n${_formatDate(msg.date)}'),
          isThreeLine: true,
        );
      },
    );
  }

  Widget _buildOtpTab() {
    return _otpMessages.isEmpty
        ? const Center(child: Text('Không có tin nhắn OTP nào.'))
        : ListView.separated(
      itemCount: _otpMessages.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final msg = _otpMessages[i];
        final otp = _extractOtp(msg.body ?? '');
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFE8F5E9),
            child: Icon(Icons.lock, color: Colors.green),
          ),
          title: Text(msg.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text('Từ: ${msg.sender ?? ''}\n${_formatDate(msg.date)}'),
          isThreeLine: true,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(otp ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 16, color: Colors.green, letterSpacing: 2)),
          ),
          onTap: () => _showOtpDialog(msg.body ?? ''),
        );
      },
    );
  }
}