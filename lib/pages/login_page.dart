import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/credentials.dart';
import 'package:tic_tac_arena/ui_components/form_button.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import '../ui_components/form_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    bool isPasswordObscure = true;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TicTacArenaTitle(text: 'Tic Tac Arena'),
            const TicTacArenaTitle(text: 'Login'),
            const SizedBox(height: 25.0),
            TicTacArenaTextInput(
              icon: Icons.person,
              hint: 'Username',
              obscure: false,
              controller: usernameController,
            ),
            const SizedBox(height: 25.0),
            TicTacArenaTextInput(
              icon: Icons.lock,
              hint: 'Password',
              obscure: isPasswordObscure,
              controller: passwordController,
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () async {
                authToken = await login(
                  Credentials(
                    username: usernameController.text,
                    password: passwordController.text
                  )
                );
                print('Evo: $authToken');
                if (authToken != null) {
                  Navigator.of(context).pushReplacementNamed('/register');
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            )
          ]
        ),
      )
    );

  }
}
