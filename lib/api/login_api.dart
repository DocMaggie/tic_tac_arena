import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/models/credentials.dart';

Future<String> login(Credentials credentials) async {
  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/login/');
  final Map<String, String> h = {
    'Content-Type': 'application/json'
  };
  final Map<String, dynamic> b = {
    'username': credentials.username,
    'password': credentials.password
  };

  final String jsonBody = jsonEncode(b);

  final response = await http.post(uri, headers: h, body: jsonBody);
  
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['token'];
    //Navigator.of(context).pushReplacementNamed('/0');
  } else {
    throw Exception('Failed to load data');
  }
}
