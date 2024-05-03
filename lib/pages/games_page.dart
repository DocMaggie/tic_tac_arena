import 'package:flutter/material.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import 'package:tic_tac_arena/ui_components/form_text_field.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    bool isPasswordObscure = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Games'),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TicTacArenaTitle(text: 'Login'),
          ]
        ),
      )
    );

  }
}
