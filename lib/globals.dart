import 'package:flutter/material.dart';
import 'package:tic_tac_arena/models/board.dart';
import 'package:tic_tac_arena/models/game.dart';
import 'package:tic_tac_arena/models/game_status.dart';
import 'package:tic_tac_arena/models/reduced_user.dart';
import 'package:tic_tac_arena/models/user.dart';

String? authToken;

String? gamesNextLink;
String? gamesPreviousLink;

String? usersNextLink;
String? usersPreviousLink;

Game? viewedGame = Game(
      id: 1930,
      board: Board(
        values: [
          [
            null,
            383,
            null
          ],
          [
            null,
            null,
            381
          ],
          [
            null,
            null,
            null
          ]
        ]
      ),
      winner: null,
      firstPlayer: ReducedUser(
        id: 383,
        username: "ccc"
      ),
      secondPlayer: ReducedUser(
        id: 381,
        username: "aaa"
      ),
      created: DateTime.parse("2024-05-03T19:08:44.550887Z"),
      status: "progress"
    );
User? firstPlayer;
User? secondPlayer;

int? gameCount;
int? gameItemsFrom;
int? gameItemsTo;

int? userCount;
int? userItemsFrom;
int? userItemsTo;

ReducedUser? loggedInUser;
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
