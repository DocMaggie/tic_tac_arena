import 'package:flutter/material.dart';
import 'package:tic_tac_arena/models/game_status.dart';
import 'package:tic_tac_arena/models/user.dart';

String? authToken;

String? gamesNextLink;
String? gamesPreviousLink;

String? usersNextLink;
String? usersPreviousLink;

int? gameCount;
int? gameItemsFrom;
int? gameItemsTo;

int? userCount;
int? userItemsFrom;
int? userItemsTo;

User? loggedInUser;
List<GameStatus> gameStatuses = [
  const GameStatus(
    id: 1,
    displayedText: 'All',
    value: '',
    statusColor: Colors.black
  ),
  const GameStatus(
    id: 2,
    displayedText: 'Open',
    value: 'open',
    statusColor: Colors.blueAccent
  ),
  const GameStatus(
    id: 3,
    displayedText: 'In progress',
    value: 'progress',
    statusColor: Colors.green
  ),
  const GameStatus(
    id: 4,
    displayedText: 'Finished',
    value: 'finished',
    statusColor: Colors.orange
  )
];
