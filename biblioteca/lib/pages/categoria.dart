// ignore_for_file: unused_local_variable
import 'package:biblioteca/pages/bookInitializer.dart';
import 'package:biblioteca/pages/clasLibro.dart';
import 'package:flutter/material.dart';
import 'clasebook.dart';

// ignore: must_be_immutable, camel_case_types
class categoriaScreenScreen extends StatefulWidget {
  final String token;
  final int iduser;
  const categoriaScreenScreen(
      {super.key, required this.token, required this.iduser});

  @override
  // ignore: library_private_types_in_public_api
  _categoriaScreen createState() => _categoriaScreen();
}

// ignore: camel_case_types
class _categoriaScreen extends State<categoriaScreenScreen> {
  final String apiUrl = 'http://localhost:1337/api/books?_expand=subcategories';

  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool showBooks = false;
  String? selectedcategory;

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

  void filterBycategory(String? category) {
    setState(() {
      selectedcategory = category;
      filterBooksBycategory(); // Llamamos a la función de filtrado cuando cambia la subcategoría
    });
  }

  void filterBooksBycategory() {
    // Filtramos los libros por la subcategoría seleccionada
    setState(() {
      if (selectedcategory!.isNotEmpty) {
        filteredBooks =
            books.where((book) => book.category == selectedcategory).toList();
      } else {
        // Si no hay subcategoría seleccionada, mostramos todos los libros
        filteredBooks = List.from(books);
      }
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            // ignore: avoid_unnecessary_containers
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
                            icon: Icon(Icons.category_outlined),
                            onPressed: null,
                          ),
                          Expanded(
                            child: Text(
                              'Categoria',
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
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedcategory,
                                onChanged: filterBycategory,
                                items: <String>[
                                  'Gestión Empresarial.',
                                  'Redes y sistemas.',
                                  'Investigación.',
                                  'Obras civiles.',
                                  'Salud y seguridad.',
                                  'Industrial.',
                                  'Gestión comunitaria.',
                                  'Agroindustria.',
                                  'Matemáticas y afines.',
                                  'Química.',
                                  'Biología.',
                                  'Filosofía y legislación.',
                                  'Agrícola.',
                                  'Agropecuaria.',
                                  'Hemeroteca.',
                                  'Educación.',
                                  'Diccionarios y enciclopedias.',
                                  'Obras literarias.',
                                  'Trabajos de grado.',

                                  // ... (agrega más subcategorías según sea necesario)
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible:
                          showBooks, // Si showBooks es true, se mostrará; de lo contrario, se ocultará
                      child: libros(
                        filteredBooks: filteredBooks,
                        iduser: widget.iduser,
                        token: widget.token,
                        onReserve: () {
                          setState(() {
                            // Actualizar la interfaz de usuario
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
