import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/models/register_input.dart';

Future<String?> register(BuildContext context, RegisterInput registerInput) async {

  SnackBar successSnackBar = SnackBar(
    content: Text('Successfully registered! You can start playing now.'),
  );
  SnackBar errorSnackBar = SnackBar(
    content: Text('Error while trying to register.'),
  );

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/register/');
  final Map<String, String> h = {
    'Content-Type': 'application/json'
  };
  final Map<String, dynamic> b = {
    'username': registerInput.username,
    'password': registerInput.password
  };

  final String jsonBody = jsonEncode(b);

  final response = await http.post(uri, headers: h, body: jsonBody);
  
  print(response.statusCode);
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    Navigator.of(context).pushReplacementNamed('/login');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    throw Exception('Failed to register');
  }
}
