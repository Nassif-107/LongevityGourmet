// lib/screens/settings/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // Placeholder for theme toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Темная тема'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
                // Implement theme switching logic here
              });
            },
          ),
          ListTile(
            title: const Text('О приложении'),
            onTap: () {
              // Show about dialog or navigate to about screen
            },
          ),
          // Add more settings options here
        ],
      ),
    );
  }
}
