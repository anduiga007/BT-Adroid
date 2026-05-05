import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'db_helper.dart';
import 'add_contact_screen.dart';
import 'edit_contact_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  List<ContactInfo> _phoneContacts = [];
  List<Map<String, dynamic>> _localContacts = [];
  List<Map<String, dynamic>> _filteredLocalContacts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        _phoneContacts = await FlutterContactsService.getContacts();
      } catch (_) {
        _phoneContacts = [];
      }
    }
    _localContacts = await DBHelper().getContacts();
    _filteredLocalContacts = _localContacts;
    setState(() => _isLoading = false);
  }

  Future<void> _searchContacts(String keyword) async {
    if (keyword.trim().isEmpty) {
      setState(() => _filteredLocalContacts = _localContacts);
    } else {
      final results = await DBHelper().searchContacts(keyword.trim());
      setState(() => _filteredLocalContacts = results);
    }
  }

  Future<void> _deleteContact(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DBHelper().deleteContact(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xóa "$name"')),
      );
      _loadAll();
    }
  }

  Widget _buildAvatar(String? name, {Color color = Colors.blue}) {
    final letter = (name != null && name.isNotEmpty) ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Text(letter, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: color.withOpacity(0.1),
      child: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _phoneContacts.length + _localContacts.length;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tìm theo tên hoặc số điện thoại...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _searchContacts,
        )
            : Text('Danh bạ ($totalCount)'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _filteredLocalContacts = _localContacts;
                }
              });
            },
          ),
          if (!_isSearching)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAll),
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const AddContactScreen()),
                );
                if (added == true) _loadAll();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : totalCount == 0
          ? const Center(child: Text('Không có danh bạ nào.'))
          : ListView(
        children: [
          if (!_isSearching && _phoneContacts.isNotEmpty) ...[
            _buildSectionHeader(
                'Danh bạ điện thoại (${_phoneContacts.length})', Colors.teal),
            ..._phoneContacts.map((contact) {
              final phone = (contact.phones != null && contact.phones!.isNotEmpty)
                  ? contact.phones!.first.value ?? ''
                  : '';
              return ListTile(
                leading: contact.avatar != null
                    ? CircleAvatar(backgroundImage: MemoryImage(contact.avatar!))
                    : _buildAvatar(contact.displayName, color: Colors.teal),
                title: Text(contact.displayName ?? 'Không có tên'),
                subtitle: Text(phone),
              );
            }),
          ],

          // Danh bạ SQLite
          if (_filteredLocalContacts.isNotEmpty) ...[
            _buildSectionHeader(
                _isSearching
                    ? 'Kết quả tìm kiếm (${_filteredLocalContacts.length})'
                    : 'Danh bạ đã thêm (${_filteredLocalContacts.length})',
                Colors.purple),
            ..._filteredLocalContacts.map((contact) {
              return ListTile(
                leading: contact['avatar'] != null
                    ? CircleAvatar(backgroundImage: MemoryImage(contact['avatar']))
                    : _buildAvatar(contact['name'], color: Colors.purple),
                title: Text(contact['name'] ?? 'Không có tên'),
                subtitle: Text(
                  '${contact['phone'] ?? ''}'
                      '${contact['email'] != null && contact['email'].toString().isNotEmpty ? '\n${contact['email']}' : ''}',
                ),
                isThreeLine: contact['email'] != null &&
                    contact['email'].toString().isNotEmpty,
                trailing: PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Row(
                      children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Sửa')],
                    )),
                    const PopupMenuItem(value: 'delete', child: Row(
                      children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Xóa', style: TextStyle(color: Colors.red))],
                    )),
                  ],
                  onSelected: (value) async {
                    if (value == 'edit') {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditContactScreen(contact: contact),
                        ),
                      );
                      if (updated == true) _loadAll();
                    } else if (value == 'delete') {
                      _deleteContact(contact['id'], contact['name'] ?? '');
                    }
                  },
                ),
              );
            }),
          ],

          if (_isSearching && _filteredLocalContacts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Không tìm thấy danh bạ nào.')),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
          if (added == true) _loadAll();
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}