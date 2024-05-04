import 'package:flutter/material.dart';

class GameStatus {

  final int id;
  final String displayedText;
  final String value;
  final Color statusColor;

  const GameStatus({
    required this.id,
    required this.displayedText,
    required this.value,
    required this.statusColor
  });

}
