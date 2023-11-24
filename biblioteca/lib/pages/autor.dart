// ignore_for_file: unused_local_variable, avoid_print
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'clasebook.dart';

// ignore: camel_case_types
class autorScreen extends StatefulWidget {
  final String token;
  final int iduser;
  const autorScreen({Key? key, required this.token, required this.iduser})
      : super(key: key);

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
                    iduser: widget.iduser,
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
    required this.iduser,
  }) : super(key: key);

  final List<Book> filteredBooks;
  final String token;
  final VoidCallback onReserve;
  final int iduser;

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

            return Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                selectedTileColor: Colors.amber,
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Titulo: ${book.title}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                            Text(
                              'Autor: ${book.author}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () async {
                                try {
                                  await book.reserveBook(
                                      token, book.id, iduser);
                                  onReserve.call();
                                } catch (e) {
                                  print('Error al reservar el libro: $e');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          // ignore: deprecated_member_use
                          primary: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          book.status,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
