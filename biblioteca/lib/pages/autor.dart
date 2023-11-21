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
  //final String description;
  final int numberCopies;
  final String status;
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.editorial,
    required this.publishedYear,
    required this.code,
    // required this.description,
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
        //description: json['attributes']['description'],
        numberCopies: json['attributes']['number_copies'],
        status: json['attributes']['status']);
  }
}

// ignore: must_be_immutable, camel_case_types
class autorScreen extends StatefulWidget {
  final String token;
  const autorScreen({super.key, required this.token});

  @override
  // ignore: library_private_types_in_public_api
  _autorScreenState createState() => _autorScreenState();
}

// ignore: camel_case_types
class _autorScreenState extends State<autorScreen> {
  final String apiUrl = 'http://localhost:1337/api/books';
  TextEditingController searchController = TextEditingController();
  String titleToSearch = 'Libro de ejemplo 1'; // Cambia el título a buscar

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool showBooks = false;

  @override
  void initState() {
    // ignore: avoid_print, prefer_interpolation_to_compose_strings
    print('este es el token::P:::::::  ' + widget.token);

    super.initState();
    // ignore: avoid_print
    print(apiUrl);
    http.get(
      Uri.parse(apiUrl),
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
                //description: bookData['attributes']['description'],
                numberCopies: bookData['attributes']['number_copies'],
                status: bookData['attributes']['status']))
            .toList();
        // ignore: avoid_print
        print('este es el token::P:::::::  2222');
        setState(() {
          books = retobook;
          filteredBooks = List.from(books);
        });
      } else {
        // ignore: avoid_print
        print('dio un error ');
        // ignore: avoid_print, prefer_interpolation_to_compose_strings
        print(response.statusCode + books.length);
      }
    });
  }

  void filterBooks() {
    String titleToSearch = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book.author.toLowerCase().contains(titleToSearch);
      }).toList();
      showBooks = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(65, 150, 125, 1),
        title: const Text(
          "BIBLIOTECA ISER",
          style: TextStyle(color: Colors.white),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Text(
            "Oscar Mogollón Jaimes",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        // ignore: avoid_unnecessary_containers
        child: Container(
          width: 800,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromARGB(255, 216, 216, 216),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              children: <Widget>[
                Container(
                  width: 500,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: const Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.person_2_sharp),
                        onPressed: null,
                      ),
                      Expanded(
                        child: Text(
                          'Autor',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // ignore: avoid_unnecessary_containers
                Container(
                  width: 600,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration:
                              const InputDecoration(labelText: 'Buscar'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: filterBooks,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible:
                      showBooks, // Si showBooks es true, se mostrará; de lo contrario, se ocultará
                  child: libros(filteredBooks: filteredBooks),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class libros extends StatelessWidget {
  const libros({
    super.key,
    required this.filteredBooks,
  });

  final List<Book> filteredBooks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: ListView.builder(
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            Color buttonColor = Colors.white;
            bool isButtonEnabled = false;

            if (book.status == "disponible") {
              buttonColor = Colors.green; // Botón verde cuando está disponible
              isButtonEnabled =
                  true; // El botón está habilitado cuando está disponible
            }
            return ListTile(
              selectedTileColor: Colors.amber,
              // ignore: prefer_interpolation_to_compose_strings
              title: Text('Titulo:\n${book.title}'),
              subtitle: Text('Autor:\n${book.author}'),
              trailing: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () {
                        // Manejar la acción del botón aquí
                        // ignore: avoid_print
                        print('Status: ${book.status}');
                      }
                    : null, // Deshabilitar el botón cuando no está disponible
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Color del botón
                ),
                child: Text(
                  book.status,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
