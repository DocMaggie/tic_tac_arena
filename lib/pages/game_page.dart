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
import 'package:tic_tac_arena/models/reduced_user.dart';
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
  String horizontalTop = 'lib/assets/images/svg/horizontal-top.svg';
  String horizontalMiddle = 'lib/assets/images/svg/horizontal-middle.svg';
  String horizontalBottom = 'lib/assets/images/svg/horizontal-bottom.svg';
  String verticalLeft = 'lib/assets/images/svg/vertical-left.svg';
  String verticalMiddle = 'lib/assets/images/svg/vertical-middle.svg';
  String verticalRight = 'lib/assets/images/svg/vertical-right.svg';
  String diagonalRising = 'lib/assets/images/svg/diagonal-rising.svg';
  String diagonalFalling = 'lib/assets/images/svg/diagonal-falling.svg';
  int? whosTurnIsItId;
  int totalCounter = 0;
  Move? tappedField;
  ReducedUser? winner;
  bool isWinnerDialogShown = false;
  late Timer timer;

  getCurrentGameState(Timer timer) async {
    await getGameById(viewedGame!.id);
    if (winner == null) {
      if (viewedGame!.winner != null && !isWinnerDialogShown) {
        if (viewedGame!.winner!.id == loggedInUser!.id) {
          isWinnerDialogShown = true;
          showDialog(
            context: context,
            builder: (BuildContext subcontext) {
              return AlertDialog(
                title: const Text('Victory!'),
                content: const Text('You won!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(subcontext).pop();
                    },
                    child: const Text('Yay'),
                  ),
                ],
              );
            },
          );
        } else {
          isWinnerDialogShown = true;
          showDialog(
            context: context,
            builder: (BuildContext subcontext) {
              return AlertDialog(
                title: const Text('Defeat!'),
                content: const Text('You lost!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(subcontext).pop();
                    },
                    child: const Text('Damn'),
                  ),
                ],
              );
            },
          );
        }
      }
      if (viewedGame!.winner == null && totalCounter == 9) {
        showDialog(
          context: context,
          builder: (BuildContext subcontext) {
            return AlertDialog(
              title: const Text('Tie!'),
              content: const Text('Nobody won.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(subcontext).pop();
                  },
                  child: const Text('Boring'),
                ),
              ],
            );
          },
        );
      }
    }
    calcWhosTurnIsIt();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkIsGameAlreadyFinished();
    calcWhosTurnIsIt();
    timer = Timer.periodic(
      const Duration(seconds: 3),
      getCurrentGameState
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void calcWhosTurnIsIt() {
    totalCounter = 0;
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
      if (totalCounter < 9) {
        if (firstPlayerCounter == secondPlayerCounter) {
          whosTurnIsItId = viewedGame!.firstPlayer!.id;
        } else {
          whosTurnIsItId = viewedGame!.secondPlayer!.id;
        }
      } else {
        whosTurnIsItId = null;
      }
    }
  }

  void checkIsGameAlreadyFinished() {
    if (viewedGame!.winner != null) {
      winner = viewedGame!.winner;
    }
  }

  String getMiddleText() {
    String returnValue = '';
    print(totalCounter);
    if (viewedGame!.winner == null) {
      if (viewedGame!.secondPlayer == null) {
        return 'Waiting for the\nsecond player...';
      }
      if (totalCounter < 9) {
        return 'Turn';
      }
      if (totalCounter == 9) {
        return 'Tie';
      }
    }
    if (viewedGame!.winner != null) {
      return 'Winner:';
    }
    return returnValue;
  }

  String getWinningLine() {
    if (viewedGame!.board.values[0][0] != null &&
        viewedGame!.board.values[0][0] == viewedGame!.board.values[0][1] &&
        viewedGame!.board.values[0][1] == viewedGame!.board.values[0][2]) {
      return horizontalTop;
    }
    if (viewedGame!.board.values[1][0] != null &&
        viewedGame!.board.values[1][0] == viewedGame!.board.values[1][1] &&
        viewedGame!.board.values[1][1] == viewedGame!.board.values[1][2]) {
      return horizontalMiddle;
    }
    if (viewedGame!.board.values[2][0] != null &&
        viewedGame!.board.values[2][0] == viewedGame!.board.values[2][1] &&
        viewedGame!.board.values[2][1] == viewedGame!.board.values[2][2]) {
      return horizontalBottom;
    }
    if (viewedGame!.board.values[0][0] != null &&
        viewedGame!.board.values[0][0] == viewedGame!.board.values[1][0] &&
        viewedGame!.board.values[1][0] == viewedGame!.board.values[2][0]) {
      return verticalLeft;
    }
    if (viewedGame!.board.values[0][1] != null &&
        viewedGame!.board.values[0][1] == viewedGame!.board.values[1][1] &&
        viewedGame!.board.values[1][1] == viewedGame!.board.values[2][1]) {
      return verticalMiddle;
    }
    if (viewedGame!.board.values[0][2] != null &&
        viewedGame!.board.values[0][2] == viewedGame!.board.values[1][2] &&
        viewedGame!.board.values[1][2] == viewedGame!.board.values[2][2]) {
      return verticalRight;
    }
    if (viewedGame!.board.values[0][0] != null &&
        viewedGame!.board.values[0][0] == viewedGame!.board.values[1][1] &&
        viewedGame!.board.values[1][1] == viewedGame!.board.values[2][2]) {
      return diagonalFalling;
    }
    if (viewedGame!.board.values[2][0] != null &&
        viewedGame!.board.values[2][0] == viewedGame!.board.values[1][1] &&
        viewedGame!.board.values[1][1] == viewedGame!.board.values[0][2]) {
      return diagonalRising;
    }
    return horizontalTop;
  }

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
      padding: EdgeInsets.all(boardSize * 0.025),
      child: SvgPicture.asset(
        cross,
        width: 200.0,
        height: 200.0,
      ),
    );

    Widget? getWidget(int? id, int row, int column) {
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
      if (row == tappedField?.row && column == tappedField?.column) {
        return const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(),
        );
      }
      return null;
    }

    Future<void> checkMakeMove(Move move) async {

      if (viewedGame != null) {
        if (viewedGame!.secondPlayer != null &&
            viewedGame!.board.values[move.row][move.column] == null &&
            loggedInUser!.id == whosTurnIsItId &&
            viewedGame!.winner == null) {
          tappedField = move;
          setState(() {});
          await makeMove(viewedGame!.id, move);
        }
      }
    }

    Future<void> makeRandomMove() async {

      if (viewedGame != null) {
        if (viewedGame!.secondPlayer != null &&
            loggedInUser!.id == whosTurnIsItId &&
            viewedGame!.winner == null) {
          int nullCounter = 0;
          for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
              if (viewedGame!.board.values[i][j] == null) {
                nullCounter++;
              }
            }
          }
          if (nullCounter > 0) {
            Random random = Random();
            int randomField = random.nextInt(nullCounter) + 1;
            nullCounter = 0;
            bool isGenerated = false;
            for (int i = 0; i < 3; i++) {
              if (!isGenerated) {
                for (int j = 0; j < 3; j++) {
                  if (viewedGame!.board.values[i][j] == null) {
                    nullCounter++;
                    if (nullCounter == randomField) {
                      isGenerated = true;
                      await checkMakeMove(Move(row: i, column: j));
                      await getGameById(viewedGame!.id);
                      calcWhosTurnIsIt();
                      setState(() {});
                      break;
                    }
                  }
                }
              }
            }
          }
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
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if ((viewedGame!.firstPlayer!.id == loggedInUser!.id ||
                  viewedGame!.secondPlayer?.id == loggedInUser!.id) &&
                  viewedGame!.winner == null) Tooltip(
                message: whosTurnIsItId == loggedInUser!.id ?
                         'In case you\'re uncertain about your next move, or you just don\'t care too much about the outcome'
                         :
                         'Please wait for your turn...',
                child: ElevatedButton(
                  onPressed: whosTurnIsItId == loggedInUser!.id ? () {
                    makeRandomMove();
                  } : null,
                  child: Text('Make a Random Move')
                ),
              ),
              const SizedBox(height: 20.0),
              Stack(
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
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 0, column: 0));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[0][0], 0, 0)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 0, column: 1));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[0][1], 0, 1)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 0, column: 2));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[0][2], 0, 2)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 1, column: 0));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[1][0], 1, 0)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 1, column: 1));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[1][1], 1, 1)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 1, column: 2));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[1][2], 1, 2)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 2, column: 0));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[2][0], 2, 0)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 2, column: 1));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[2][1], 2, 1)
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await checkMakeMove(const Move(row: 2, column: 2));
                            await getGameById(viewedGame!.id);
                            calcWhosTurnIsIt();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(boardSize * 0.02),
                            color: Theme.of(context).colorScheme.background,
                            child: getWidget(viewedGame?.board.values[2][2], 2, 2)
                          ),
                        )
                      ],
                    ),
                  ),
                  if (viewedGame!.winner != null) SvgPicture.asset(
                    getWinningLine(),
                    height: boardSize,
                    width: boardSize,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'First player (X)',
                              style: TextStyle(
                                color: whosTurnIsItId == viewedGame!.firstPlayer!.id && viewedGame!.winner == null ?
                                      Color.fromARGB(255, 216, 68, 0) : null
                              ),
                            ),
                            Text(
                              viewedGame!.firstPlayer!.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whosTurnIsItId == viewedGame!.firstPlayer!.id && viewedGame!.winner == null ?
                                      Color.fromARGB(255, 216, 68, 0) : null
                              ),
                            ),
                            Text(
                              'ID: ${viewedGame!.firstPlayer!.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whosTurnIsItId == viewedGame!.firstPlayer!.id && viewedGame!.winner == null ?
                                      Color.fromARGB(255, 216, 68, 0) : null
                              ),
                            ),
                          ]
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Second player (O)',
                              style: TextStyle(
                              color: viewedGame!.secondPlayer != null ? (whosTurnIsItId == viewedGame!.secondPlayer!.id && viewedGame!.winner == null ?
                                    Color.fromARGB(255, 216, 68, 0) : null) : null
                              ),
                            ),
                            Text(
                              viewedGame!.secondPlayer != null ? viewedGame!.secondPlayer!.username : '?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: viewedGame!.secondPlayer != null ? (whosTurnIsItId == viewedGame!.secondPlayer!.id && viewedGame!.winner == null ?
                                     Color.fromARGB(255, 216, 68, 0) : null) : null,
                              ),
                            ),
                            if (viewedGame!.secondPlayer != null) Text(
                              'ID: ${viewedGame!.secondPlayer!.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whosTurnIsItId == viewedGame!.secondPlayer!.id && viewedGame!.winner == null ?
                                     Color.fromARGB(255, 216, 68, 0) : null,
                              ),
                            ),
                          ]
                        ),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          whosTurnIsItId == viewedGame!.firstPlayer!.id && viewedGame!.winner == null ? Flexible(
                            flex: 1,
                            child: Container(
                              width: size.width * 0.375,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Color.fromARGB(255, 216, 68, 0)
                                ),
                              ),
                            ),
                          ) : Flexible(
                            flex: 1,
                            child: Container(
                              width: size.width * 0.375,
                            ),
                          ),
                          Container(
                            width: viewedGame!.winner == null ? size.width * 0.25 : size.width * 0.9,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  getMiddleText()
                                ),
                                if (viewedGame!.winner != null) Text(
                                  viewedGame!.winner!.username,
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (viewedGame!.secondPlayer != null)
                            whosTurnIsItId == viewedGame!.secondPlayer!.id && viewedGame!.winner == null ? Flexible(
                            flex: 1,
                            child: Container(
                              width: size.width * 0.375,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Color.fromARGB(255, 216, 68, 0)
                                ),
                              ),
                            ),
                          ) : Flexible(
                            flex: 1,
                            child: Container(
                              width: size.width * 0.375,
                            )
                          ),
                        ],
                      ),
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
