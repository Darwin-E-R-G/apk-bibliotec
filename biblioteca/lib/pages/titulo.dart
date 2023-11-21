// ignore_for_file: unused_local_variable, avoid_print
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
  final int numberCopies;
  String status;
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.editorial,
    required this.publishedYear,
    required this.code,
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
        numberCopies: json['attributes']['number_copies'],
        status: json['attributes']['status']);
  }

  Future<void> reserveBook(String token) async {
    if (status == "disponible") {
      status = "reservado";

      // Actualizar el estado en el servidor Strapi
      final String apiUrl = 'http://localhost:1337/api/books/$id';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'attributes': {'status': 'reservado'},
        }),
      );

      if (response.statusCode != 200) {
        // Manejar el error al actualizar el estado en el servidor
        throw Exception('Failed to reserve book');
      }
    }
  }
}

// ignore: camel_case_types
class tituloScreen extends StatefulWidget {
  final String token;
  const tituloScreen({Key? key, required this.token}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _tituloScreenState createState() => _tituloScreenState();
}

// ignore: camel_case_types
class _tituloScreenState extends State<tituloScreen> {
  final String apiUrl = 'http://localhost:1337/api/books';
  TextEditingController searchController = TextEditingController();
  String titleToSearch = 'Libro de ejemplo 1'; // Cambia el título a buscar

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool showBooks = false;

  @override
  void initState() {
    // ignore: prefer_interpolation_to_compose_strings
    print('este es el token::P:::::::  ' + widget.token);

    super.initState();
    print(apiUrl);
    http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        print('este es el token::P:::::::  1111');
        String responseBody = response.body;
        print(responseBody);
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        print('este es el token::P:::::::  2222');
        List<Book> retobook = (jsonDecode(responseBody)['data'] as List)
            .map((bookData) => Book(
                id: bookData['id'],
                title: bookData['attributes']['title'],
                author: bookData['attributes']['author'],
                editorial: bookData['attributes']['editorial'],
                publishedYear: bookData['attributes']['published_year'],
                code: bookData['attributes']['code'],
                numberCopies: bookData['attributes']['number_copies'],
                status: bookData['attributes']['status']))
            .toList();
        print('este es el token::P:::::::  2222');
        setState(() {
          books = retobook;
          filteredBooks = List.from(books);
        });
      } else {
        print('dio un error ');
        print(response.statusCode);
      }
    });
  }

  void filterBooks() {
    String titleToSearch = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book.title.toLowerCase().contains(titleToSearch);
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
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Text(
            "Oscar Mogollón Jaimes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
                        icon: Icon(Icons.library_books),
                        onPressed: null,
                      ),
                      Expanded(
                        child: Text(
                          'Título del libro',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                  visible: showBooks,
                  child: libros(
                    filteredBooks: filteredBooks,
                    token: widget.token,
                    onReserve: () {
                      setState(() {
                        // Actualizar la interfaz de usuario
                      });
                    },
                  ),
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
    Key? key,
    required this.filteredBooks,
    required this.token,
    required this.onReserve,
  }) : super(key: key);

  final List<Book> filteredBooks;
  final String token;
  final VoidCallback onReserve;

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
              buttonColor = Colors.green;
              isButtonEnabled = true;
            }
            return ListTile(
              selectedTileColor: Colors.amber,
              title: Text('Titulo:\n${book.title}'),
              subtitle: Text('Autor:\n${book.author}'),
              trailing: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                        try {
                          await book.reserveBook(token);
                          onReserve.call();
                        } catch (e) {
                          print('Error al reservar el libro: $e');
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
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
