import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/login_input.dart';

Future<dynamic> joinGame(int id) async {

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/games/$id/join/');
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.post(uri, headers: h);
  
  if (response.statusCode == 200) {
    print('Successfully joined game!');
  } else {
    throw Exception('Failed to get games');
  }
}
