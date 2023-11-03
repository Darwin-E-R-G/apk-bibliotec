//import 'package:biblioteca/pages/categoria.dart';
import 'package:flutter/material.dart';

import 'categoria.dart';

// ignore: camel_case_types
class inicioScreen extends StatefulWidget {
  final String token;
  const inicioScreen({super.key, required this.token});

  @override
  // ignore: library_private_types_in_public_api
  _inicioScreen createState() => _inicioScreen();
}

// ignore: camel_case_types
class _inicioScreen extends State<inicioScreen> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String opcionSeleccionada = '';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(65, 150, 125, 1),
        title: const Text(
          "BIBLIOTECA",
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        toolbarHeight: 80,
      ),
      // ignore: avoid_unnecessary_containers
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),

        // ignore: avoid_unnecessary_containers
        child: Container(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    width: 270,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 216, 216, 216),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Buscar por',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // ignore: avoid_unnecessary_containers
                  Container(
                    width: 300,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color.fromARGB(255, 216, 216, 216),
                    ),
                    child: Column(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyDataScreen(token: widget.token),
                            ),
                          );
                        },
                        child: Container(
                          width: 250,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.category_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Categoría',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black, // Color del texto
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            opcionSeleccionada = 'autor';
                          });
                        },
                        child: Container(
                          width: 250,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.person_sharp),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Autor',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black, // Color del texto
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            opcionSeleccionada = 'titulo';
                          });
                        },
                        child: Container(
                          width: 250,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.my_library_books_outlined),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Título',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black, // Color del texto
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
