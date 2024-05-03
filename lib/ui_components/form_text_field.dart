import 'package:flutter/material.dart';

class TicTacArenaTextInput extends StatefulWidget {
  const TicTacArenaTextInput({
    super.key,
    required this.icon,
    required this.hint,
    required this.obscure,
    required this.controller
  });

  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController controller;

  @override
  State<TicTacArenaTextInput> createState() => _TicTacArenaTextInputState();
}

class _TicTacArenaTextInputState extends State<TicTacArenaTextInput> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.7,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: TextField(
          obscureText: widget.obscure,
          decoration: InputDecoration(
            icon: Icon(
              widget.icon,
              color: Colors.black,
            ),
            hintText: widget.hint,
            border: InputBorder.none,
          ),
          controller: widget.controller,
        ),
      ),
    );

  }
}