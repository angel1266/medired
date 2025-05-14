import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/ui/constants/ui_helper.dart';
class SheetsNacionalidad extends StatefulWidget {
  const SheetsNacionalidad({
    super.key,
    this.onSelect
  });

  final Function(String? country)? onSelect;

  @override
  State<SheetsNacionalidad> createState() => _SheetsNacionalidadState();
}

class _SheetsNacionalidadState extends State<SheetsNacionalidad> {
  List<Country> countries = Country.values;
  String query = '';

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    List<Country> filteredCountries = countries.where((country) {
      final name = countryToString[country]!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
    return Padding(
      padding: EdgeInsets.only(top: device ? 70 : 46),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search for a country',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                return GestureDetector(
                  child: ListTile(
                    title: Text(countryToString[country]!),
                    subtitle: Text(countryToString[country]!),
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSelect!(countryToString[country]);
                      // Handle country selection here
                      // You can use the selected country (country) in your logic
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}