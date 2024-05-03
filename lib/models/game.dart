import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/board.dart';
import 'package:tic_tac_arena/models/player.dart';

class Game {

  final int id;
  final Board board;
  final Player winner;
  final Player first_player;
  final Player second_player;
  final DateTime created;
  final Status status;

  const Game({
    required this.id,
    required this.board,
    required this.winner,
    required this.first_player,
    required this.second_player,
    required this.created,
    required this.status
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      board: json['board'],
      winner: json['winner'],
      first_player: json['first_player'],
      second_player: json['second_player'],
      created: json['created'],
      status: json['status']
    );
  }

}
