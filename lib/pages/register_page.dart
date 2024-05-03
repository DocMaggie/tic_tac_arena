import 'package:flutter/material.dart';
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

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TicTacArenaTitle(text: 'Register'),
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
          ]
        ),
      )
    );

  }
}
