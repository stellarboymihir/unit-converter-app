import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle labelStyle = const TextStyle(fontSize: 16.0);

  final TextStyle resultStyle = const TextStyle(
    color: Colors.teal,
    fontSize: 25.0,
    fontWeight: FontWeight.w700,
  );

  final List<String> _measures = [
    'Meters',
    'Kilometers',
    'Grams',
    'Kilograms',
    'Feet',
    'Miles',
    'Pounds',
    'Ounces'
  ];

  late double _value;
  String _fromMeasures = 'Meters';
  String _toMeasures = 'Kilometers';
  String _results = "";

  final Map<String, int> _measuresMap = {
    'Meters': 0,
    'Kilometers': 1,
    'Grams': 2,
    'Kilograms': 3,
    'Feet': 4,
    'Miles': 5,
    'Pounds': 6,
    'Ounces': 7,
  };

// ignore: slash_for_doc_comments
/**
  // Measurement type | Conversion factors
0 | Meters | Kilometers | Grams | Kilograms | Feet | Miles | Pounds | Ounces
1 | Kilometers | Meters | Grams | Kilograms | Feet | Miles | Pounds | Ounces
2 | Grams | Kilograms | Meters | Kilometers | Feet | Miles | Pounds | Ounces
3 | Kilograms | Grams | Meters | Kilometers | Feet | Miles | Pounds | Ounces
4 | Feet | Meters | Kilometers | Grams | Kilograms | Miles | Pounds | Ounces
5 | Miles | Feet | Meters | Kilometers | Grams | Kilograms | Pounds | Ounces
6 | Pounds | Ounces | Grams | Kilograms | Feet | Miles | Meters | Kilometers
7 | Ounces | Pounds | Grams | Kilograms | Feet | Miles | Meters | Kilometers

**/

  final dynamic _formulas = {
    '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
    '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
    '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
    '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
    '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
    '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
    '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
    '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter the value',
              ),
              onChanged: (value) {
                setState(() {
                  _value = double.parse(value);
                });
              },
            ),
            const SizedBox(height: 25.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From',
                      style: labelStyle,
                    ),
                    DropdownButton(
                      items: _measures
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _fromMeasures = value!;
                        });
                      },
                      value: _fromMeasures,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TO', style: labelStyle),
                    DropdownButton(
                      items: _measures
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _toMeasures = value!;
                        });
                      },
                      value: _toMeasures,
                    ),
                  ],
                ),
              ],
            ),
            MaterialButton(
              minWidth: double.infinity,
              onPressed: _convert,
              color: Theme.of(context).primaryColor,
              child: const Text(
                'Convert',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 25.0),
            Text(
              _results,
              style: resultStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  void _convert() {
    if (kDebugMode) {
      print('Clicked');
      print(_value);
    }

    if (_value != 0 && _fromMeasures.isNotEmpty && _toMeasures.isNotEmpty) {
      int? from = _measuresMap[_fromMeasures];
      int? to = _measuresMap[_toMeasures];

      var multiplier = _formulas[from.toString()][to];

      setState(() {
        _results =
            "$_value $_fromMeasures = ${_value * multiplier} $_toMeasures";
      });
    } else {
      setState(() {
        _results = "Enter a non-zero value";
      });
    }
  }
}
