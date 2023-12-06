// ignore_for_file: file_names, avoid_print, duplicate_ignore
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'clasebook.dart';

class BookInitializer {
  static Future<List<Book>> initializeBooks(String apiUrl, String token) async {
    List<Book> books = [];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        String responseBody = response.body;
        print(responseBody);
        List<Book> retobook = (jsonDecode(responseBody)['data'] as List)
            .map((bookData) => Book(
                  id: bookData['id'],
                  title: bookData['attributes']['title'],
                  author: bookData['attributes']['author'],
                  editorial: bookData['attributes']['editorial'],
                  publishedYear: bookData['attributes']['published_year'],
                  code: bookData['attributes']['code'],
                  description: bookData['attributes']['description'] ?? '',
                  numberCopies: bookData['attributes']['number_copies'],
                  status: bookData['attributes']['status'],
                  category: bookData['attributes']['category'],
                ))
            .toList();

        books = retobook;
      } else {
        // ignore: avoid_print
        print('dio un error ');
        print(response.statusCode);
      }
    } catch (e) {
      print('Error en la inicialización de libros: $e');
    }

    return books;
  }
}
