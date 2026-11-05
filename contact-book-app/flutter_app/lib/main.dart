import 'package:flutter/material.dart';
import 'screens/contact_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ContactBookApp());
}

class ContactBookApp extends StatelessWidget {
  const ContactBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contacts',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ContactListScreen(),
    );
  }
}
