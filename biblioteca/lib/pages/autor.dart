// ignore_for_file: unused_local_variable, avoid_print
import 'package:biblioteca/pages/bookInitializer.dart';
import 'package:biblioteca/pages/clasLibro.dart';
import 'package:flutter/material.dart';
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

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool showBooks = false;

  @override
  void initState() {
    super.initState();
    initializeBooks();
  }

  Future<void> initializeBooks() async {
    List<Book> initializedBooks =
        await BookInitializer.initializeBooks(apiUrl, widget.token);
    setState(() {
      books = initializedBooks;
      filteredBooks = List.from(books);
    });
  }

  void filterBooks() {
    String authorToSearch = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = books.where((book) {
        return book.author.toLowerCase().contains(authorToSearch);
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
            preferredSize: Size.fromHeight(10),
            child: Text(
              "Oscar Mogollón Jaimes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Container(
              width: 800,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color.fromARGB(255, 216, 216, 216),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
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
        ));
  }
}

// ignore: camel_case_types

