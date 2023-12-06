import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Book {
  final int id;
  final String title;
  final String author;
  final String editorial;
  final int publishedYear;
  final String code;
  // final String description;
  final int numberCopies;
  String status;
  final String category;
  final String description;

  Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.editorial,
      required this.publishedYear,
      required this.code,
      //required this.description,
      required this.numberCopies,
      required this.status,
      required this.category,
      this.description = ''});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
        id: json['id'],
        title: json['attributes']['title'],
        author: json['attributes']['author'],
        editorial: json['attributes']['editorial'],
        publishedYear: json['attributes']['published_year'],
        code: json['attributes']['code'],
        description: json['attributes']['description'] ?? '',
        numberCopies: json['attributes']['number_copies'],
        status: json['attributes']['status'],
        category: json['attributes']['category']);
  }

  Future<void> reserveBook(String token, int id, int iduser) async {
    DateTime now = DateTime.now();

    // Utilizar DateFormat para formatear la fecha sin la hora
    String fechaActual = DateFormat('yyyy-MM-dd').format(now);
    if (status == "disponible") {
      status = "reservado";

      // Actualizar el estado en el servidor Strapi
      // ignore: avoid_print
      print(id);
      final String apiUrl = 'http://localhost:1337/api/books/$id';
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "data": {"status": "reservado"}
        }),
      );
      if (response.statusCode != 200) {
        // Manejar el error al actualizar el estado en el servidor
        throw Exception('Failed to reserve book');
      }

      final repons = await http.post(
        Uri.parse('http://localhost:1337/api/bookings'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "data": {
            "booking_date": fechaActual,
            "start": fechaActual,
            "status": "pendiente",
            "book": id,
            "users_permissions_user": iduser
          }
        }),
      );
      if (repons.statusCode != 200) {
        // Manejar el error al actualizar el estado en el servidor
        throw Exception('Failed to reserve book');
      }
    }
  }
}
