import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';

Future<String?> logout(BuildContext context) async {

  SnackBar successSnackBar = SnackBar(
    content: Text('Successfully logged out'),
  );
  SnackBar errorSnackBar = SnackBar(
    content: Text('Error while trying to logout.'),
  );

  final Uri uri = Uri.parse('https://tictactoe.aboutdream.io/logout/');
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.post(uri, headers: h);
  
  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    Navigator.of(context).pushReplacementNamed('/login');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
    Navigator.of(context).pop();
    throw Exception('Failed to logout');
  }
}
