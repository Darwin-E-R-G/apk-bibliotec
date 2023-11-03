import 'dart:convert';

import 'package:biblioteca/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _documentTypeController = TextEditingController();
  final TextEditingController _documentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    // ignore: avoid_print

    if (_formKey.currentState!.validate()) {
      // Datos del formulario
      String username = _usernameController.text;
      String email = _emailController.text;
      String firstname = _firstnameController.text;
      String lastname = _lastnameController.text;
      String documentType = _documentTypeController.text;
      String documentId = _documentIdController.text;
      String password = _passwordController.text;

      // URL de tu servidor Strapi
      String url = 'http://localhost:1337/api/auth/local/register';

      // Datos a enviar
      Map<String, dynamic> data = {
        "username": username,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "document_type": documentType,
        "document_id": documentId,
        "role": 'student-teacher',
        "password": password
      };

      // Realizar la petición POST
      // ignore: unused_local_variable
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        // Registro exitoso
        // ignore: avoid_print
        print('Registro exitoso');
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // Error en el registro
        // ignore: avoid_print
        print(response.statusCode);
        // ignore: avoid_print
        print('Error en el registro');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const sepracionentrecampos = SizedBox(
      height: 10,
    );
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // ignore: avoid_unnecessary_containers
            child: Column(
              children: [
                Image.asset('assets/images/logoiser.png',
                    width: 150, height: 150),
                // ignore: avoid_unnecessary_containers
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color.fromARGB(255, 216, 216, 216),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Registro',
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                          // ignore: avoid_unnecessary_containers

                          platillaCampos(_firstnameController, 'Nombres'),
                          sepracionentrecampos,
                          platillaCampos(_lastnameController, 'Apellidos'),
                          sepracionentrecampos,
                          platillaCampos(
                              _documentTypeController, 'tipo de documento'),
                          sepracionentrecampos,
                          platillaCampos(
                              _documentIdController, 'Numero de documento '),
                          sepracionentrecampos,
                          platillaCampos(_usernameController, 'Nombre usuario'),
                          sepracionentrecampos,
                          platillaCampos(
                              _emailController, 'Correo electrónico'),
                          sepracionentrecampos,

                          platillaCamposContrasena(
                              _passwordController, 'Contraseña'),
                          const SizedBox(
                            height: 10,
                          ),
                          botonRegister(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell botonRegister() {
    return InkWell(
      onTap: () {
        // Coloca aquí la acción para navegar a otra vista (pantalla)
        _register();
      },
      child: Container(
        width: 250,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(65, 150, 125, 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          'Registrarte',
          style: TextStyle(
            fontSize: 25,
            color: Colors.white, // Color del texto
            fontWeight: FontWeight.bold, // Texto en negrita
            fontFamily: AutofillHints.addressCity,
          ),
        ),
      ),
    );
  }

  Container platillaCampos(TextEditingController n, String p) {
    // ignore: avoid_unnecessary_containers
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      child: TextFormField(
        style: const TextStyle(fontSize: 10),
        controller: n,
        decoration: InputDecoration(
            labelText: p,
            labelStyle: const TextStyle(fontSize: 10, decorationThickness: 10)),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Container platillaCamposContrasena(TextEditingController n, String p) {
    // ignore: avoid_unnecessary_containers
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 10),
        obscureText: true,
        controller: n,
        decoration: InputDecoration(
            labelText: p,
            labelStyle: const TextStyle(
              fontSize: 10,
            )),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }
}
