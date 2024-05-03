class Game {

  final int? id;
  final String? board;
  final String? nameTeamB;
  final DateTime? startTime;

  const Game({
    this.id,
    this.board,
    this.nameTeamB,
    this.startTime,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['set_id'],
      nameTeamB: json['set_team_b_name'],
      startTime: json['set_start_time'],
    );
  }

}