// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Book {
  final int id;
  final String title;
  final String author;
  final String editorial;
  final int publishedYear;
  final String code;
  final String description;
  final int numberCopies;
  final String status;
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.editorial,
    required this.publishedYear,
    required this.code,
    required this.description,
    required this.numberCopies,
    required this.status,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['id'],
        title: json['attributes']['title'],
        author: json['attributes']['author'],
        editorial: json['attributes']['editorial'],
        publishedYear: json['attributes']['published_year'],
        code: json['attributes']['code'],
        description: json['attributes']['description'],
        numberCopies: json['attributes']['number_copies'],
        status: json['attributes']['status']);
  }
}

// ignore: must_be_immutable
class MyDataScreen extends StatefulWidget {
  final String token;
  const MyDataScreen({super.key, required this.token});

  @override
  // ignore: library_private_types_in_public_api
  _MyDataScreenState createState() => _MyDataScreenState();
}

class _MyDataScreenState extends State<MyDataScreen> {
  final String apiUrl = 'http://localhost:1337/api/books';
  String titleToSearch = 'Libro de ejemplo 1'; // Cambia el título a buscar

  List<Book> books = [];

  @override
  void initState() {
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('este es el token::P:::::::  ' + widget.token);

    super.initState();
    String titulo =
        'Libro de ejemplo 1'; // Cambia esto por el título que deseas buscar

    String query =
        Uri.encodeComponent(titulo); // Codifica el título para usarlo en la URL

    String requestUrl = '$apiUrl?title=$query';
    // ignore: avoid_print
    print(requestUrl);
    http.get(
      Uri.parse(requestUrl),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print('este es el token::P:::::::  1111');
        String responseBody = response.body;
        // ignore: avoid_print
        print(responseBody);
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        // ignore: avoid_print
        print('este es el token::P:::::::  2222');
        List<Book> retobook = (jsonDecode(responseBody)['data'] as List)
            .map((bookData) => Book(
                id: bookData['id'],
                title: bookData['attributes']['title'],
                author: bookData['attributes']['author'],
                editorial: bookData['attributes']['editorial'],
                publishedYear: bookData['attributes']['published_year'],
                code: bookData['attributes']['code'],
                description: bookData['attributes']['description'],
                numberCopies: bookData['attributes']['number_copies'],
                status: bookData['attributes']['status']))
            .toList();
        // ignore: avoid_print
        print('este es el token::P:::::::  2222');
        setState(() {
          books = retobook;
        });
      } else {
        // ignore: avoid_print
        print('dio un error ');
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print(response.statusCode + books.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Libros por Título'),
        ),
        body: Center(
          child: Autocomplete<Book>(
              optionsBuilder: (TextEditingValue textEditingValue) {
            return books.where((Book elementos) {
              return elementos.title
                  .toString()
                  .contains(textEditingValue.text.toLowerCase());
            });
          }),
        ));
  }
}
