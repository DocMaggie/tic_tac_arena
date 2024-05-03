import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/models/credentials.dart';

class TicTacArenaButton extends StatefulWidget {
  const TicTacArenaButton({
    super.key,
    required this.text,
    required this.functionn
  });

  final String text;
  final Future<void> functionn;

  @override
  State<TicTacArenaButton> createState() => _TicTacArenaButtonState();
}

class _TicTacArenaButtonState extends State<TicTacArenaButton> {

  late AnimationController _controller;
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: () {
        login(
          const Credentials(
            username: 'domagoj',
            password: 'mypassword'
          )
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.inversePrimary
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
    );

  }

}
