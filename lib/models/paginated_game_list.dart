import 'package:tic_tac_arena/models/game.dart';

class PaginatedGameList {

  final int count;
  final String next;
  final String previous;
  final List<Game> results;

  const PaginatedGameList({
    required this.count,
    required this.next,
    required this.previous,
    required this.results
  });

}
