// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names, deprecated_member_use, duplicate_ignore, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'clasebook.dart';

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
                      const SizedBox(width: 10),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () async {
                                    try {
                                      await book.reserveBook(
                                          token, book.id, iduser);
                                      onReserve.call();
                                    } catch (e) {
                                      // ignore: avoid_print
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
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              // Mostrar detalles del libro al presionar el botón
                              BookDetailsDialog.show(context, book);
                            },
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Colors.blue, // Color del botón de detalles
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Detalles',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ],
                      )
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

class BookDetailsDialog {
  static void show(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Libro'),
          content: Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Codigo: ${book.code}'),
                Text('Título: ${book.title}'),
                Text('Autor: ${book.author}'),
                Text('Editorial: ${book.editorial}'),
                Text('Año de publicación: ${book.publishedYear}'),
                Text('N. Copias: ${book.numberCopies}'),
                Text('Categoria: ${book.category}'),
                Text('Descripción: ${book.description}'),
                // Agrega más detalles según sea necesario
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
