import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/login_input.dart';
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
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext loggingOutContext) {
                    return AlertDialog(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Please wait...'),
                        ]
                      ),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    );
                  },
                );
                authToken = await login(
                  context,
                  LoginInput(
                    username: usernameController.text,
                    password: passwordController.text
                  )
                );
                print('Evo: $authToken');
                if (authToken != null) {
                  Navigator.of(context).pushReplacementNamed('/home');
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
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Don\'t have an account yet?  ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      )
    );

  }
}
