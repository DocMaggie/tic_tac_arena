import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/api/get_game_by_id_api.dart';
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/login_input.dart';

class Move {

  final int row;
  final int column;

  const Move({
    required this.row,
    required this.column
  });

}

Future<dynamic> makeMove(int id, Move move) async {

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/games/$id/move/');
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };
  final Map<String, dynamic> b = {
    'row': move.row,
    'col': move.column
  };

  final String jsonBody = jsonEncode(b);
  print('jsonBody: ' + jsonBody);

  final response = await http.post(uri, headers: h, body: jsonBody);

  if (response.statusCode == 200) {
    print('Move made!');
  } else {
    throw Exception('Failed to make the move');
  }
}
