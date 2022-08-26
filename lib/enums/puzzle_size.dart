import 'dart:math' show sqrt;

import '../helpers/command_line_color.dart';

/// Number of columns/rows.
///
/// eg: [4, 9, 16]
enum PuzzleSize {
  s4(4, CL.y),
  s9(9, CL.g),
  s16(16, CL.m);

  /// The value of size is number of rows and columns.
  final int n;

  /// Return the ASCCI color code string for console output based on [n].
  final String clColor;

  /// Returns the square root of [PuzzleSize.n]
  int get sq => sqrt(n).toInt();

  const PuzzleSize(this.n, this.clColor);
}
