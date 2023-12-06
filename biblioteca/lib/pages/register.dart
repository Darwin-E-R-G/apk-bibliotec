import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

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

  int currentStep = 1;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      // Realizar acciones de registro aquí
      String username = _usernameController.text;
      String email = _emailController.text;
      String firstname = _firstnameController.text;
      String lastname = _lastnameController.text;
      String documentType = _documentTypeController.text;
      String documentId = _documentIdController.text;
      String password = _passwordController.text;
      String url = 'http://localhost:1337/api/auth/local/register';
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
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/logoiser.png',
                    width: 150, height: 150),
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
                            ),
                          ),
                          if (currentStep == 1) ...[
                            platillaCampos(_firstnameController, 'Nombres*'),
                            sepracionentrecampos,
                            platillaCampos(_lastnameController, 'Apellidos*'),
                            sepracionentrecampos,
                            platillaCampos(_documentTypeController,
                                'tipo de documento cc, ti o otro*'),
                            sepracionentrecampos,
                            platillaCampos(
                                _documentIdController, 'Numero de documento* '),
                            sepracionentrecampos,
                          ],
                          if (currentStep == 2) ...[
                            platillaCampos(
                                _usernameController, 'Nombre usuario*'),
                            sepracionentrecampos,
                            platillaCampos(
                                _emailController, 'Correo electrónico*'),
                            sepracionentrecampos,
                            platillaCamposContrasena(
                                _passwordController, 'Contraseña*'),
                            sepracionentrecampos,
                            botonRegister(),
                            sepracionentrecampos,
                          ],
                          if (currentStep == 1) ...[
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    currentStep += 1;
                                  });
                                }
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
                                  'Continuar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                          if (currentStep == 2) ...[
                            InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    currentStep -= 1;
                                  });
                                }
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
                                  'Atras',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
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

  InkWell botonRegister() {
    return InkWell(
      onTap: () {
        _register();
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
          'Registrarte',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container platillaCampos(TextEditingController n, String p) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0.5),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          controller: n,
          decoration: InputDecoration(
              labelText: p,
              labelStyle: const TextStyle(decorationThickness: 10)),
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

  Container platillaCamposContrasena(TextEditingController n, String p) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          obscureText: true,
          controller: n,
          decoration:
              InputDecoration(labelText: p, labelStyle: const TextStyle()),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Este campo es obligatorio';
            }
            if (value.length <= 6) {
              return 'La contraseña debe tener más de 6 caracteres';
            }
            return null;
          },
        ),
      ),
    );
  }
}
