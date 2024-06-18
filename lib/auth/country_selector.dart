
import 'package:flutter/material.dart';
import 'package:sgela_services/data/country.dart';

class CountrySelector extends StatefulWidget {
  const CountrySelector({super.key, required this.onCountrySelected});

  final Function(Country) onCountrySelected;

  @override
  State<CountrySelector> createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  List<Country> countries = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: countries.length,
        itemBuilder: (_, index) {
          var country = countries.elementAt(index);
          return Card(
            elevation: 8,
            child: Column(
              children: [
                Text('${country.name}'),
                Text('${country.iso2}'),
              ],
            ),
          );
        });
  }
}
