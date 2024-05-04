import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/login_input.dart';

class GamesParameters {

  final int? offset;
  final int? limit;
  final String? status;

  const GamesParameters({
    this.offset,
    this.limit,
    this.status
  });

}

String formatRequestUrl(String url, GamesParameters parameters) {
  String returnString = url;
  bool multipleGamesParametersPresent = false;
  if (parameters.offset != null || parameters.limit != null || parameters.status != null) {
    returnString += '?';
  }
  if (parameters.offset != null) {
    returnString += 'offset=${parameters.offset}';
    multipleGamesParametersPresent = true;
  }
  if (parameters.limit != null) {
    if (multipleGamesParametersPresent) returnString += '&';
    returnString += 'limit=${parameters.limit}';
    multipleGamesParametersPresent = true;
  }
  if (parameters.status != null) {
    if (multipleGamesParametersPresent) returnString += '&';
    returnString += 'status=${parameters.status}';
  }
  return returnString;
}

Future<dynamic> getGames(GamesParameters parameters, String? directUrl) async {

  final Uri uri = Uri.parse(directUrl ?? formatRequestUrl('https://tictactoe.aboutdream.io/games/', parameters));
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.get(uri, headers: h);
  
  if (response.statusCode == 200) {
    if (directUrl != null) {
      gameItemsFrom = int.parse(uri.queryParameters['offset'] != null ? (int.parse(uri.queryParameters['offset']!) + 1).toString() : '1');
    } else {
      gameItemsFrom = 1;
      gameItemsTo = 10;
    }
    final jsonData = jsonDecode(response.body);
    gamesNextLink = jsonData['next'];
    gamesPreviousLink = jsonData['previous'];
    gameCount = jsonData['count'];
    gameItemsTo = gameItemsTo != null ? min(gameItemsFrom! + 9, gameCount ?? 0) : 10;
    await Clipboard.setData(ClipboardData(text: authToken!));
    return jsonData['results'];
  } else {
    throw Exception('Failed to get games');
  }
}
