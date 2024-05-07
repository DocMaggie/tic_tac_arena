import 'package:flutter/material.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/login_input.dart';
import 'package:tic_tac_arena/models/user.dart';
import 'package:tic_tac_arena/ui_components/form_button.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import '../ui_components/form_text_field.dart';

class UserDetailsPage extends StatelessWidget {

  static const routeName = '/user-details';

  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('User Details'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Tooltip(
              message: 'Back to homepage',
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                icon: Icon(Icons.arrow_back)
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.width * 0.5,
              width: size.width * 0.5,
              child: Icon(
                Icons.person_outline_rounded,
                size: size.width * 0.5
              )
            ),
            Center(
              child: Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text('ID'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(user.id.toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text('Username'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(user.username.toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text('Game count'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text(user.gameCount.toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text('Games won'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text((user.gameCount * user.winRate).round().toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text('Games lost'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text((user.gameCount * (1 - user.winRate)).round().toString()),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableCell(
                        child: Center(
                          child: Text('Winrate'),
                        ),
                      ),
                      TableCell(
                        child: Center(
                          child: Text('${(user.winRate * 100).toStringAsFixed(2)}%'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );

  }
}
