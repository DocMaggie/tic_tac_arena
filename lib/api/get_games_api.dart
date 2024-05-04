import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/login_input.dart';

class Parameters {

  final int? offset;
  final int? limit;
  final String? status;

  const Parameters({
    this.offset,
    this.limit,
    this.status
  });

}

String formatRequestUrl(String url, Parameters parameters) {
  String returnString = url;
  bool multipleParametersPresent = false;
  if (parameters.offset != null || parameters.limit != null || parameters.status != null) {
    returnString += '?';
  }
  if (parameters.offset != null) {
    returnString += 'offset=${parameters.offset}';
    multipleParametersPresent = true;
  }
  if (parameters.limit != null) {
    if (multipleParametersPresent) returnString += '&';
    returnString += 'limit=${parameters.limit}';
    multipleParametersPresent = true;
  }
  if (parameters.status != null) {
    if (multipleParametersPresent) returnString += '&';
    returnString += 'status=${parameters.status}';
  }
  return returnString;
}

Future<dynamic> getGames(Parameters parameters) async {

  final Uri uri = Uri.parse(formatRequestUrl('https://tictactoe.aboutdream.io/games/', parameters));
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.get(uri, headers: h);
  
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['results'];
  } else {
    throw Exception('Failed to get games');
  }
}
