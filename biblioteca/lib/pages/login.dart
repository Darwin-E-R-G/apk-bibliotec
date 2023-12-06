// ignore_for_file: avoid_print, sized_box_for_whitespace, deprecated_member_use
import 'dart:convert';
import 'package:biblioteca/pages/incio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
// ignore: unused_import
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;
      String password = _passwordController.text;
      String url = 'http://localhost:1337/api/auth/local';
      Map<String, dynamic> data = {
        'identifier': username,
        'password': password,
      };
      print(data.toString());
      // Realizar la petición POST
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            <String, dynamic>{"identifier": username, "password": password}),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        String responseBody = response.body;
        Map<String, dynamic> jsonResponse = json.decode(responseBody);
        String jwtToken = jsonResponse['jwt'];
        int userId = jsonResponse['user']['id'];
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => inicioScreen(
                    token: jwtToken,
                    iduser: userId,
                  )),
        );
        _usernameController.clear();
        _passwordController.clear();
      } else {
        // Error en el inicio de sesión
        print('Error en el inicio de sesión');
      }
    }
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
      // ignore: avoid_unnecessary_containers
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/logoiser.png',
                    width: 150, height: 150),
                // ignore: avoid_unnecessary_containers
                Container(
                  width: 300,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color.fromARGB(255, 216, 216, 216),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            username(),
                            const SizedBox(
                              height: 20,
                            ),
                            passwor(),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                olvidoContrasena(context),
                                const Spacer()
                              ],
                            ),
                            Row(
                              children: [
                                registro(context),
                                const Spacer(), // Esto empujará el texto hacia el lado derecho
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            botonAcceder(),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(65, 150, 125, 1),
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Center(
              child: InkWell(
            onTap: () {
              BookDetailsDialog.show(context);
              // Reemplaza OtraVista con el nombre de tu vista
            },
            child: const Text(
              'copyright©',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(240, 243, 242, 1), // Color del texto
                fontWeight: FontWeight.bold, // Texto en negrita
                fontFamily: AutofillHints.addressCity,
              ),
            ),
          )),
        ),
      ),
    );
  }

  InkWell olvidoContrasena(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Para recuperar tu contraseña, por favor, acude a la biblioteca.'), // Personaliza el mensaje
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            ),
          ),
        );
      },
      child: const Text(
        '¿Olvidaste tu contraseña?',
        style: TextStyle(
          color: Color.fromRGBO(65, 150, 125, 1), // Color del texto
          fontWeight: FontWeight.bold, // Texto en negrita
          fontFamily: AutofillHints.addressCity,
        ),
      ),
    );
  }

  InkWell registro(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const RegisterScreen(), // Reemplaza OtraVista con el nombre de tu vista
          ),
        );
      },
      child: const Text(
        'Regístrese aquí',
        style: TextStyle(
          fontSize: 15,
          color: Color.fromRGBO(65, 150, 125, 1), // Color del texto
          fontWeight: FontWeight.bold, // Texto en negrita
          fontFamily: AutofillHints.addressCity,
        ),
      ),
    );
  }

  InkWell botonAcceder() {
    return InkWell(
      onTap: () {
        // Coloca aquí la acción para navegar a otra vista (pantalla)
        _login();
      },
      child: Container(
        width: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(65, 150, 125, 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          'Acceder',
          style: TextStyle(
            //fontSize: 25,
            color: Colors.white, // Color del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            fontFamily: AutofillHints.addressCity,
          ),
        ),
      ),
    );
  }

  Container username() {
    // ignore: avoid_unnecessary_containers
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          //style: const TextStyle(fontSize: 10),
          controller: _usernameController,
          decoration: const InputDecoration(labelText: 'Correo institucional'),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ),
    );
  }

  Container passwor() {
    // ignore: avoid_unnecessary_containers
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextFormField(
            //style: const TextStyle(fontSize: 10),
            obscureText: true,
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Contraseña'),
            validator: (value) {
              // ignore: dead_code
              if (value!.length <= 6) {
                return 'La contraseña debe tener màs de 6 caracteres';
                // ignore: dead_code
                if (value.isEmpty) {
                  return 'Este campo es obligatorio';
                }
              }
              return null;
            },
          ),
        ));
  }
}

class BookDetailsDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desarrollado por:'),
          content: Container(
            height: 100,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Darwin Elpidio Robles Garcia'),
                Text('Dylan Santiago Bautista'),
                // Agrega más detalles según sea necesario
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
