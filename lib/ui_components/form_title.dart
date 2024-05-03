import 'package:flutter/material.dart';

class TicTacArenaTitle extends StatefulWidget {
  const TicTacArenaTitle({
    super.key,
    required this.text
  });

  final String text;

  @override
  State<TicTacArenaTitle> createState() => _TicTacArenaTitleState();
}

class _TicTacArenaTitleState extends State<TicTacArenaTitle> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Text(
      widget.text,
      style: TextStyle(
        fontSize: 28.0,
        color: Colors.blueGrey
      ),
    );

  }
}