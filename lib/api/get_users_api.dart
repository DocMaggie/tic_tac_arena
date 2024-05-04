import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tic_tac_arena/globals.dart';
import 'package:tic_tac_arena/models/user.dart';
import 'package:tic_tac_arena/models/login_input.dart';

class UsersParameters {

  final int? offset;
  final int? limit;

  const UsersParameters({
    this.offset,
    this.limit
  });

}

String formatRequestUrl(String url, UsersParameters parameters) {
  String returnString = url;
  bool multipleUsersParametersPresent = false;
  if (parameters.offset != null || parameters.limit != null) {
    returnString += '?';
  }
  if (parameters.offset != null) {
    returnString += 'offset=${parameters.offset}';
    multipleUsersParametersPresent = true;
  }
  if (parameters.limit != null) {
    if (multipleUsersParametersPresent) returnString += '&';
    returnString += 'limit=${parameters.limit}';
    multipleUsersParametersPresent = true;
  }
  return returnString;
}

Future<dynamic> getUsers(UsersParameters parameters, String? directUrl) async {

  final Uri uri = Uri.parse(directUrl ?? formatRequestUrl('https://tictactoe.aboutdream.io/users/', parameters));
  final Map<String, String> h = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${authToken != null ? authToken! : ''}'
  };

  final response = await http.get(uri, headers: h);
  
  if (response.statusCode == 200) {
    if (directUrl != null) {
      userItemsFrom = int.parse(uri.queryParameters['offset'] != null ? (int.parse(uri.queryParameters['offset']!) + 1).toString() : '1');
    } else {
      userItemsFrom = 1;
      userItemsTo = 10;
    }
    final jsonData = jsonDecode(response.body);
    usersNextLink = jsonData['next'];
    usersPreviousLink = jsonData['previous'];
    userCount = jsonData['count'];
    userItemsTo = userItemsTo != null ? min(userItemsFrom! + 9, userCount ?? 0) : 10;
    await Clipboard.setData(ClipboardData(text: authToken!));
    return jsonData['results'];
  } else {
    throw Exception('Failed to get users');
  }
}
