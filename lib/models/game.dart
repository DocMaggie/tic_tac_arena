
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/board.dart';
import 'package:tic_tac_arena/models/reduced_user.dart';
import 'package:tic_tac_arena/models/status.dart';

class Game {
  final int id;
  final Board board;
  final ReducedUser? winner;
  final ReducedUser? firstPlayer;
  final ReducedUser? secondPlayer;
  final DateTime created;
  final String status;

  const Game({
    required this.id,
    required this.board,
    required this.winner,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.created,
    required this.status
  });

  factory Game.fromJson(Map<String, dynamic> json) {

    List<List<int?>> convertToBoard(dynamic value) {
      List<List<int?>> returnValue = [];
        for (int i = 0; i < value.length; i++) {
          returnValue.add([]);
          for (int j = 0; j < value[i].length; j++) {
            returnValue[i].add(value[i][j]);
          }
        }
      return returnValue;
    }
    
    return Game(
      id: json['id'],
      board: Board(values: convertToBoard(json['board'])),
      //board: Board(values: [[null, null, null], [null, null, null], [null, null, null]]),
      winner: json['winner'] != null ? ReducedUser.fromJson(json['winner']) : null,
      firstPlayer: ReducedUser.fromJson(json['first_player']),
      secondPlayer: json['second_player'] != null ? ReducedUser.fromJson(json['second_player']) : null,
      created: DateTime.parse(json['created']),
      status: json['status']
    );
  }

}
