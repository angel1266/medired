import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';

class CountryForm extends StatefulWidget {
  const CountryForm({
    required this.onPressed,
    super.key});

  final void Function(Country country) onPressed;
  @override
  State<CountryForm> createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  List<Country> countries = Country.values;
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField(),
        _buildCountryList(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: CustomTextFormField(
        'Busca un país',
        hintText: 'República Dominicana',
        onChanged: (value) {
          setState(() {
            query = value;
          });
        },
      ),
    );
  }

  Widget _buildCountryList() {
    List<Country> filteredCountries = countries.where((country) {
      final name = countryToString[country]!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: filteredCountries.length,
        itemBuilder: (context, index) {
          final country = filteredCountries[index];
          return GestureDetector(
            child: ListTile(
              leading: Text('${countryToEmoji[country]}'),
              title: Text(countryToString[country]!),
              onTap: () {
                widget.onPressed(country);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
