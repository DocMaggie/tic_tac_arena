import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/register_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/register_input.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import 'package:tic_tac_arena/ui_components/form_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    bool isPasswordObscure = true;
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController repeatPasswordController = TextEditingController();

    SnackBar snackBar = SnackBar(
      content: Text('Successfully registered as ${usernameController.text}. You may advance to Login now.'),
    );
    SnackBar unmatchingPasswordsSnackBar = SnackBar(
      content: Text('Passwords do not match. Please retype carefully.'),
    );

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TicTacArenaTitle(text: 'Registration'),
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
            TicTacArenaTextInput(
              icon: Icons.lock,
              hint: 'Repeat Password',
              obscure: isPasswordObscure,
              controller: repeatPasswordController,
            ),
            const SizedBox(height: 25.0),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext registeringContext) {
                    return AlertDialog(
                      title: Row(
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
                      actions: <Widget>[],
                    );
                  },
                );
                if (passwordController.text == repeatPasswordController.text) {
                  register(
                    context,
                    RegisterInput(
                      username: usernameController.text,
                      password: passwordController.text
                    )
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(unmatchingPasswordsSnackBar);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.inversePrimary
                ),
              ),
              child: const Text(
                'REGISTER',
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
                  'Already have an account?  ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Login',
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
