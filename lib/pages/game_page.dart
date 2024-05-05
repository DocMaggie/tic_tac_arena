import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/login_input.dart';
import 'package:tic_tac_arena/ui_components/form_button.dart';
import 'package:tic_tac_arena/ui_components/form_title.dart';
import '../ui_components/form_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  String circle = 'lib/assets/images/svg/circle.svg';
  String cross = 'lib/assets/images/svg/cross.svg';

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double boardSize = min(size.height, size.width) * 0.7;
    
    Widget circleWidget = Padding(
      padding: EdgeInsets.all(boardSize * 0.0),
      child: SvgPicture.asset(
        circle,
        width: 200.0,
        height: 200.0,
      ),
    );
    Widget crossWidget = Padding(
      padding: EdgeInsets.all(boardSize * 0.02),
      child: SvgPicture.asset(
        cross,
        width: 200.0,
        height: 200.0,
      ),
    );

    Widget? getWidget(int? id) {
      if (viewedGame != null) {
        if (viewedGame!.firstPlayer != null) {
          if (id == viewedGame!.firstPlayer!.id) {
            return crossWidget;
          }
        }
        if (viewedGame!.secondPlayer != null) {
          if (id == viewedGame!.secondPlayer!.id) {
            return circleWidget;
          }
        }
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Game'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              icon: Icon(Icons.arrow_back)
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.black,
                height: boardSize,
                width: boardSize,
                child: GridView.count(
                  primary: false,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[0][0])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[0][1])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[0][2])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[1][0])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[1][1])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[1][2])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[2][0])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[2][1])
                    ),
                    Container(
                      padding: EdgeInsets.all(boardSize * 0.02),
                      color: Theme.of(context).colorScheme.background,
                      child: getWidget(viewedGame?.board.values[2][2])
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('First player'),
                        Text(
                          viewedGame!.firstPlayer!.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                    Column(
                      children: <Widget>[
                        Text('Second player'),
                        Text(
                          viewedGame!.secondPlayer != null ? viewedGame!.secondPlayer!.username : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]
      ),
    );

  }
}
