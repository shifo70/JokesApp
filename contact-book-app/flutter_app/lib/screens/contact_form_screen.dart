import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

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
          phoneNumber: _phoneController.text,
          category: _category,
          isFavorite: _isFavorite,
        );
      } else {
        data = await ApiService.createContact(
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text,
          category: _category,
          isFavorite: _isFavorite,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message'] as String? ?? 'Saved'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('Could not save contact: $e');
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
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : '+ Add Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '0712345678',
                          helperText: 'Exactly 10 digits starting with 07',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (v) {
                          final phone = ApiService.normalizePhone(v ?? '');
                          if (!RegExp(r'^07\d{8}$').hasMatch(phone)) {
                            return 'Must be 10 digits starting with 07';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(_categories.length, (index) {
                          final cat = _categories[index];
                          final selected = _category == cat;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == _categories.length - 1 ? 0 : 8,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => setState(() => _category = cat),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppTheme.primary
                                        : const Color(0xFFEEF2F8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    cat,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFF334155),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Mark as favorite',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        value: _isFavorite,
                        activeColor: AppTheme.primary,
                        onChanged: (v) => setState(() => _isFavorite = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
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
