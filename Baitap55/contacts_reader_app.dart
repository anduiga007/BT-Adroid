import 'package:flutter/material.dart';
import 'package:flutter_contacts_service/flutter_contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsReaderApp extends StatelessWidget {
  const ContactsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts Reader',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const ContactsReaderHome(),
    );
  }
}

class ContactsReaderHome extends StatefulWidget {
  const ContactsReaderHome({super.key});

  @override
  State<ContactsReaderHome> createState() => _ContactsReaderHomeState();
}

class _ContactsReaderHomeState extends State<ContactsReaderHome> {
  List<ContactInfo> _contacts = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.contacts].request();

    if (statuses[Permission.contacts]!.isGranted) {
      _loadContacts();
    } else {
      setState(() {
        _isLoading = false;
        _error = 'Chưa được cấp quyền truy cập danh bạ!';
      });
    }
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      List<ContactInfo> contacts =
          await FlutterContactsService.getContacts();
      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Lỗi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContacts,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(_error, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initializePermissions,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : _contacts.isEmpty
                  ? const Center(child: Text('Không có danh bạ nào.'))
                  : ListView.separated(
                      itemCount: _contacts.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        ContactInfo contact = _contacts[index];
                        final phone = (contact.phones != null &&
                                contact.phones!.isNotEmpty)
                            ? contact.phones!.first.value ?? 'Không có số'
                            : 'Không có số';
                        return ListTile(
                          leading: contact.avatar != null
                              ? CircleAvatar(
                                  backgroundImage:
                                      MemoryImage(contact.avatar!),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.teal.shade100,
                                  child: Text(
                                    (contact.displayName ?? '?')
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                          title: Text(contact.displayName ?? 'Không có tên'),
                          subtitle: Text(phone),
                        );
                      },
                    ),
    );
  }
}
