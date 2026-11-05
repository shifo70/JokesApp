import 'package:flutter/material.dart';
import '../config.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
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
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Contact> get _visibleContacts {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _contacts;
    return _contacts.where((c) {
      return c.fullName.toLowerCase().contains(q) ||
          c.phoneNumber.contains(q) ||
          c.displayTag.toLowerCase().contains(q);
    }).toList();
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
            : 'Connection failed. Is the backend running on port 3000?';
        _loading = false;
      });
    }
  }

  Future<void> _openForm({Contact? contact}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ContactFormScreen(contact: contact)),
    );
    if (result == true) _loadContacts();
  }

  Future<void> _confirmDelete(Contact contact) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete contact?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
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
          backgroundColor: Colors.green.shade700,
        ),
      );
      _loadContacts();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleContacts;

    return Scaffold(
      body: Column(
        children: [
          _Header(
            registrationNumber: kRegistrationNumber,
            count: _contacts.length,
            onRefresh: _loadContacts,
          ),
          Transform.translate(
            offset: const Offset(0, -18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _SearchField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                  ),
                  const SizedBox(height: 12),
                  _FilterBar(
                    selected: _selectedFilter,
                    filters: _filters,
                    onSelected: (f) {
                      setState(() => _selectedFilter = f);
                      _loadContacts();
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody(visible)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Widget _buildBody(List<Contact> visible) {
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
              const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadContacts, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (visible.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              _contacts.isEmpty
                  ? 'No contacts yet'
                  : 'No matches for “$_query”',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _contacts.isEmpty
                  ? 'Tap Add to create your first contact'
                  : 'Try another name or phone',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadContacts,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final c = visible[index];
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

class _Header extends StatelessWidget {
  final String registrationNumber;
  final int count;
  final VoidCallback onRefresh;

  const _Header({
    required this.registrationNumber,
    required this.count,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 16,
        12,
        36,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Contacts — $registrationNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  count == 1 ? '1 contact' : '$count contacts',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(16),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search name or phone',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.4),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
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
    return Row(
      children: filters.map((f) {
        final isActive = f == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Material(
              color: isActive ? AppTheme.primary : Colors.white,
              elevation: isActive ? 0 : 1,
              shadowColor: Colors.black12,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onSelected(f),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Text(
                    f,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF334155),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

    return Material(
      color: contact.isFavorite ? AppTheme.favoriteBg : AppTheme.card,
      elevation: contact.isFavorite ? 2 : 1,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: contact.isFavorite
                    ? const Color(0xFFFFD54F)
                    : const Color(0xFFBBDEFB),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      contact.phoneNumber,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: contact.isFavorite
                            ? const Color(0xFFFFE0B2)
                            : const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        contact.displayTag,
                        style: TextStyle(
                          color: contact.isFavorite
                              ? AppTheme.favoriteAccent
                              : AppTheme.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
