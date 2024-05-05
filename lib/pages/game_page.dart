import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tic_tac_arena/api/get_game_by_id_api.dart';
import 'package:tic_tac_arena/api/login_api.dart';
import 'package:tic_tac_arena/api/make_move_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
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
  int? whosTurnIsItId;
  int totalCounter = 0;
  late Timer timer;

  getCurrentGameState(Timer timer) async {
    await getGameById(viewedGame!.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    calcWhosTurnIsIt();
    timer = Timer.periodic(
      Duration(seconds: 3),
      getCurrentGameState
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void calcWhosTurnIsIt() {
    if (viewedGame!.secondPlayer != null && viewedGame!.winner == null) {
      int firstPlayerCounter = 0;
      int secondPlayerCounter = 0;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (viewedGame!.board.values[i][j] == viewedGame!.firstPlayer!.id) {
            firstPlayerCounter++;
            totalCounter++;
          }
          if (viewedGame!.board.values[i][j] == viewedGame!.secondPlayer!.id) {
            secondPlayerCounter++;
            totalCounter++;
          }
        }
      }
      if (firstPlayerCounter == secondPlayerCounter) {
        whosTurnIsItId = viewedGame!.firstPlayer!.id;
      } else {
        whosTurnIsItId = viewedGame!.secondPlayer!.id;
      }
    }
  }

  String getMiddleText() {
    String returnValue = '';
    if (viewedGame!.winner == null) {
      if (viewedGame!.secondPlayer == null) {
        return 'Waiting for the\nsecond player...';
      }
      if (totalCounter < 9) {
        return 'Turn';
      }
      if (totalCounter == 9) {
        return 'Draw';
      }
    }
    if (viewedGame!.winner != null) {
      return 'Winner:\n${viewedGame!.winner!.username}';
    }
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double boardSize = min(size.height, size.width) * 0.7;
    Move? tappedField;

    
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
      if (id == null) {
        return null/*Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(),
        )*/;
      }
    }
    Future<void> makeMoveCheck(Move move) async {
      if (viewedGame != null) {
        if (viewedGame!.secondPlayer != null &&
            viewedGame!.board.values[move.row][move.column] == null &&
            loggedInUser!.id == whosTurnIsItId) {
          await makeMove(viewedGame!.id, move);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: null,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Game (ID: ${viewedGame!.id})'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Tooltip(
              message: 'Back to games list',
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                icon: Icon(Icons.arrow_back)
              ),
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
              ElevatedButton(onPressed: () {
                print(viewedGame!.board.values);
                setState(() {});
              }, child: Text('test')),
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
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 0, column: 0));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[0][0])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 0, column: 1));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[0][1])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 0, column: 2));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[0][2])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 1, column: 0));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[1][0])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 1, column: 1));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[1][1])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 1, column: 2));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[1][2])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 2, column: 0));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[2][0])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 2, column: 1));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[2][1])
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await makeMoveCheck(const Move(row: 2, column: 2));
                        await getGameById(viewedGame!.id);
                        calcWhosTurnIsIt();
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.all(boardSize * 0.02),
                        color: Theme.of(context).colorScheme.background,
                        child: getWidget(viewedGame?.board.values[2][2])
                      ),
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
                        Text('First player (X)'),
                        Text(
                          viewedGame!.firstPlayer!.username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID: ${viewedGame!.firstPlayer!.id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          whosTurnIsItId == viewedGame!.firstPlayer!.id && viewedGame!.winner == null ? Icon(Icons.arrow_back) : Container(),
                          Text(
                            getMiddleText()
                          ),
                          if (viewedGame!.secondPlayer != null)
                            whosTurnIsItId == viewedGame!.secondPlayer!.id && viewedGame!.winner == null ? Icon(Icons.arrow_forward) : Container()
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text('Second player (O)'),
                        Text(
                          viewedGame!.secondPlayer != null ? viewedGame!.secondPlayer!.username : '?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (viewedGame!.secondPlayer != null) Text(
                          'ID: ${viewedGame!.secondPlayer!.id}',
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
