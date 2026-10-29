import 'package:flutter/material.dart';
import '../config.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  static const _filters = ['All', 'Family', 'Friend', 'Work'];

  List<Contact> _contacts = [];
  bool _loading = true;
  String? _error;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final contacts = _selectedFilter == 'All'
          ? await ApiService.getContacts()
          : await ApiService.searchByCategory(_selectedFilter);
      setState(() {
        _contacts = contacts;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e is ApiException
            ? e.message
            : 'Connection failed. Is the backend running?';
        _loading = false;
      });
    }
  }

  Future<void> _openForm({Contact? contact}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ContactFormScreen(contact: contact),
      ),
    );
    if (result == true) _loadContacts();
  }

  Future<void> _confirmDelete(Contact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete contact?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final data = await ApiService.deleteContact(contact.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] as String? ?? 'Deleted'),
          backgroundColor: Colors.green,
        ),
      );
      _loadContacts();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connection failed. Is the backend running?'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('My Contacts — $kRegistrationNumber'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _selectedFilter,
            filters: _filters,
            onSelected: (f) {
              setState(() => _selectedFilter = f);
              _loadContacts();
            },
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadContacts, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (_contacts.isEmpty) {
      return const Center(child: Text('No contacts yet. Tap + to add one.'));
    }

    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final c = _contacts[index];
          return _ContactTile(
            contact: c,
            onTap: () => _openForm(contact: c),
            onDelete: () => _confirmDelete(c),
          );
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final String selected;
  final List<String> filters;
  final ValueChanged<String> onSelected;

  const _FilterBar({
    required this.selected,
    required this.filters,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: filters.map((f) {
          final isActive = f == selected;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Material(
                color: isActive
                    ? const Color(0xFF1565C0)
                    : const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => onSelected(f),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      f,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ContactTile({
    required this.contact,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final initial = contact.fullName.isNotEmpty
        ? contact.fullName[0].toUpperCase()
        : '?';
    final avatarColor =
        contact.isFavorite ? const Color(0xFFFFC107) : const Color(0xFF90CAF9);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: contact.isFavorite ? 3 : 1,
      color: contact.isFavorite ? const Color(0xFFFFF8E1) : Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: Text(
            initial,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        title: Text(
          contact.fullName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(contact.phoneNumber),
            const SizedBox(height: 2),
            Text(
              contact.displayTag,
              style: TextStyle(
                color: contact.isFavorite
                    ? const Color(0xFFEF6C00)
                    : Colors.grey.shade700,
                fontWeight:
                    contact.isFavorite ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
