import 'dart:math' show sqrt;

/// Defines the size of puzzle. number of columns/rows.
///
/// Each puzzle size must be perfect square numbers.
/// eg: [4, 9, 16]
enum PuzzleSize {
  small(4),
  medium(9),
  large(16);

  /// The value of size is number of rows and columns.
  final int n;

  /// Returns the square root of [PuzzleSize.n]
  int get sqr => sqrt(n).toInt();

  const PuzzleSize(this.n);
}
