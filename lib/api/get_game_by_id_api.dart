import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/login_input.dart';

Future<Map<String, dynamic>> getGameById(int id) async {

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/games/$id/');
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.get(uri, headers: h);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    viewedGame = Game.fromJson(jsonData);
    print('jsonData: ' + response.body);
    return jsonData;
  } else {
    throw Exception('Failed to get the game by Id');
  }
}
