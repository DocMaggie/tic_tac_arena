import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/login_input.dart';
import 'package:tic_tac_arena/models/reduced_user.dart';

Future<String> login(BuildContext context, LoginInput loginInput) async {

  SnackBar successSnackBar = const SnackBar(
    content: Text('Welcome!'),
  );
  SnackBar errorSnackBar = const SnackBar(
    content: Text('Error while trying to login.'),
  );

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/login/');
  final Map<String, String> h = {
    'Content-Type': 'application/json'
  };
  final Map<String, dynamic> b = {
    'username': loginInput.username,
    'password': loginInput.password
  };

  final String jsonBody = jsonEncode(b);

  final response = await http.post(uri, headers: h, body: jsonBody);
  
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    loggedInUser = ReducedUser(
      id: jsonData['id'],
      username: jsonData['username']
    );
    return jsonData['token'];
  } else {
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    Navigator.of(context).pop();
    throw Exception('Failed to login');
  }
}
