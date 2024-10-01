// lib/screens/allergens/allergens_screen.dart

import 'package:flutter/material.dart';
import 'package:longevity_gourmet/models/allergen.dart';
import 'package:longevity_gourmet/services/database_service.dart';

class AllergensScreen extends StatefulWidget {
  const AllergensScreen({super.key});

  @override
  _AllergensScreenState createState() => _AllergensScreenState();
}

class _AllergensScreenState extends State<AllergensScreen> {
  List<Allergen> _allAllergens = [];
  List<Allergen> _userAllergens = [];

  @override
  void initState() {
    super.initState();
    _fetchAllAllergens();
    _fetchUserAllergens();
  }

  void _fetchAllAllergens() async {
    List<Allergen> allergens = await DatabaseService().getAllAllergens();
    setState(() {
      _allAllergens = allergens;
    });
  }

  void _fetchUserAllergens() async {
    List<Allergen> allergens = await DatabaseService().getUserAllergens();
    setState(() {
      _userAllergens = allergens;
    });
  }

  void _toggleAllergen(Allergen allergen) async {
    if (_userAllergens.any((a) => a.id == allergen.id)) {
      await DatabaseService().removeUserAllergen(allergen);
      _userAllergens.removeWhere((a) => a.id == allergen.id);
    } else {
      await DatabaseService().addUserAllergen(allergen);
      _userAllergens.add(allergen);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои аллергены'),
      ),
      body: _allAllergens.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _allAllergens.length,
        itemBuilder: (context, index) {
          Allergen allergen = _allAllergens[index];
          bool isSelected =
          _userAllergens.any((a) => a.id == allergen.id);
          return ListTile(
            title: Text(allergen.name),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) {
                _toggleAllergen(allergen);
              },
            ),
            onTap: () {
              _toggleAllergen(allergen);
            },
          );
        },
      ),
    );
  }
}
