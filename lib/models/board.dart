class Board {

  late List<List<int?>> values = List.generate(3, (i) =>
                                 List.generate(3, (j) => null));

  Board({
    required this.values
  });

  factory Board.fromJson(List<List<int?>> json) {
    return Board(
      values: json
    );
  }

}
