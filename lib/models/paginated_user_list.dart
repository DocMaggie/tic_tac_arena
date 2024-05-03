import 'package:tic_tac_arena/models/user.dart';

class PaginatedUserList {

  final int count;
  final String next;
  final String previous;
  final List<User> results;

  const PaginatedUserList({
    required this.count,
    required this.next,
    required this.previous,
    required this.results
  });

}
