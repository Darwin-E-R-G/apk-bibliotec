import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedOption = 'Opción 1';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menú Desplegable'),
        ),
        body: Center(
          child: DropdownButton<String>(
            value: selectedOption,
            onChanged: (newValue) {
              assert(newValue != null);
              setState(() {
                selectedOption = newValue!;
              });
            },
            items: <String>[
              'Opción 1',
              'Opción 2',
              'Opción 3',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
