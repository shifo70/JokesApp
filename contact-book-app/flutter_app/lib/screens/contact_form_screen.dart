import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  const ContactFormScreen({super.key, this.contact});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late String _category;
  late bool _isFavorite;
  bool _loading = false;

  bool get _isEditing => widget.contact != null;

  static const _categories = ['Family', 'Friend', 'Work'];

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.contact?.fullName ?? '');
    _phoneController =
        TextEditingController(text: widget.contact?.phoneNumber ?? '');
    _category = widget.contact?.category ?? 'Family';
    _isFavorite = widget.contact?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final Map<String, dynamic> data;
      if (_isEditing) {
        data = await ApiService.updateContact(
          id: widget.contact!.id,
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          category: _category,
          isFavorite: _isFavorite,
        );
      } else {
        data = await ApiService.createContact(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          category: _category,
          isFavorite: _isFavorite,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] as String? ?? 'Saved'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Connection failed. Is the backend running?');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : '+ Add Contact'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '0788123456',
                    helperText: 'Phone must be 10 digits, start with 07',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) {
                    final phone = (v ?? '').trim().replaceAll(RegExp(r'\s+'), '');
                    if (!RegExp(r'^07\d{8}$').hasMatch(phone)) {
                      return 'Must be 10 digits starting with 07';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 10),
                Row(
                  children: _categories.map((cat) {
                    final selected = _category == cat;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) => setState(() => _category = cat),
                          selectedColor: const Color(0xFF1565C0),
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Mark as favorite'),
                  value: _isFavorite,
                  activeColor: const Color(0xFF1565C0),
                  onChanged: (v) => setState(() => _isFavorite = v),
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _loading ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'SAVE CONTACT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
