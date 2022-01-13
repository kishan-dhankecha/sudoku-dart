import 'dart:math' show sqrt;

import '../helpers/command_line_color.dart';

/// Number of columns/rows.
///
/// eg: [4, 9, 16]
enum Sizes { s4, s9, s16 }

class PuzzleSize {
  final Sizes size;
  final int vacancies;

  PuzzleSize({this.size = Sizes.s9, this.vacancies = 0});

  /// Returns the square root of [PuzzleSize.n]
  int get sq {
    return sqrt(n).toInt();
  }

  /// Returns the [int] value of [PuzzleSize.size].
  int get n {
    switch (size) {
      case Sizes.s4:
        return 4;
      case Sizes.s9:
        return 9;
      case Sizes.s16:
        return 16;
    }
  }

  /// Return the ASCCI color code string for console output based on [PuzzleSize].
  String get clColor {
    switch (size) {
      case Sizes.s4:
        return CL.y;
      case Sizes.s9:
        return CL.g;
      case Sizes.s16:
        return CL.b;
    }
  }
}
