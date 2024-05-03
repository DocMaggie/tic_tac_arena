import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/board.dart';
import 'package:tic_tac_arena/models/reduced_user.dart';
import 'package:tic_tac_arena/models/status.dart';

class Game {

  final int id;
  final Board board;
  final ReducedUser winner;
  final ReducedUser firstPlayer;
  final ReducedUser secondPlayer;
  final DateTime created;
  final Status status;

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
    return Game(
      id: json['id'],
      board: json['board'],
      winner: json['winner'],
      firstPlayer: json['first_player'],
      secondPlayer: json['second_player'],
      created: json['created'],
      status: json['status']
    );
  }

}
