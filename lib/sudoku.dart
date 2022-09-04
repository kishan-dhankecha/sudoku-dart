/* Dart program for Sudoku generator */
import 'dart:math' show Random, Point;

import 'enums/puzzle_size.dart';
import 'models/cell.dart';

export 'dart:math' show Random;

export 'enums/puzzle_size.dart';
export 'models/cell.dart';

class Sudoku {
  /// Defines the size of the current sudoku board.
  final PuzzleSize size;

  /// Defines the empty cell in board.
  ///
  /// by default set to [0]
  final int vacancies;

  late final Random _random;

  /// Defines the board generation seed.
  ///
  /// by default set to [DateTime.now().millisecondsSinceEpoch]
  late final int seed;

  /// Matrix of [Cell] for the current sudoku board.
  late List<List<Cell>> board;

  Sudoku({int? seed, required this.size, this.vacancies = 0}) {
    assert(
      vacancies >= 0 && vacancies < (size.n * size.n),
      "Vacancies must be between 0 and ${size.n * size.n}",
    );

    /// Generate the new [matrix] with relative point and value as 0.
    board = List.generate(size.n, (x) {
      return List.generate(size.n, (y) {
        return Cell(Point(x, y));
      }, growable: false);
    }, growable: false);

    /// Seed the seed for new game
    this.seed = seed ?? DateTime.now().millisecondsSinceEpoch;
    _random = Random(this.seed);

    /// Generate board
    generate();
  }

  /// Sudoku Generator
  void generate() {
    do {
      _fillDiagonal();
    } while (!_fillRemaining(0, size.sqr));
    _addVacancies();
  }

  /// Fill the diagonal [size.sqr] x [size.sqr] matrix of [size.n] x [size.n] matrices
  void _fillDiagonal() {
    for (int i = 0; i < size.n; i = i + size.sqr) {
      // for diagonal box, start coordinates -> i==j
      _fillBox(i, i);
    }
  }

  /// Fill a [size.sqr] x [size.sqr] matrix.
  void _fillBox(int row, int col) {
    var options = List.generate(size.n, (index) => index + 1);
    for (int i = 0; i < size.sqr; i++) {
      for (int j = 0; j < size.sqr; j++) {
        var n = options.removeAt(_random.nextInt(options.length));
        board[row + i][col + j].setVal(n);
      }
    }
  }

  /// A recursive function to fill remaining matrix
  bool _fillRemaining(int x, int y) {
    if (y >= size.n && x < size.n - 1) {
      x = x + 1;
      y = 0;
    }
    if (x >= size.n && y >= size.n) return true;

    if (x < size.sqr) {
      if (y < size.sqr) y = size.sqr;
    } else if (x < size.n - size.sqr) {
      if (y == (x ~/ size.sqr) * size.sqr) y = y + size.sqr;
    } else {
      if (y == size.n - size.sqr) {
        x = x + 1;
        y = 0;
        if (x >= size.n) return true;
      }
    }
    for (int n = 1; n <= size.n; n++) {
      if (_checkIfSafe(x, y, n)) {
        board[x][y].setVal(n);
        if (_fillRemaining(x, y + 1)) return true;
        board[x][y].setVal(0);
      }
    }
    return false;
  }

  /// Check if safe to put in cell
  bool _checkIfSafe(int i, int j, int n) {
    return (_availInRow(i, n) &&
        _availInCol(j, n) &&
        _availInBox(i - i % size.sqr, j - j % size.sqr, n));
  }

  /// check in the row for existence
  bool _availInRow(int i, int n) {
    for (int j = 0; j < size.n; j++) {
      if (board[i][j].value == n) return false;
    }
    return true;
  }

  /// check in the row for existence
  bool _availInCol(int j, int n) {
    for (int i = 0; i < size.n; i++) {
      if (board[i][j].value == n) return false;
    }
    return true;
  }

  /// Returns true if given 3 x 3 block contains num.
  bool _availInBox(int rowStart, int colStart, int number) {
    for (var i = 0; i < size.sqr; i++) {
      for (var j = 0; j < size.sqr; j++) {
        if (board[rowStart + i][colStart + j].value == number) return false;
      }
    }
    return true;
  }

  /// Add [vacancies] to complete game
  void _addVacancies() {
    int count = vacancies;
    while (count != 0) {
      int i = _random.nextInt(size.n);
      int j = _random.nextInt(size.n);
      if (board[i][j].value != 0) {
        count--;
        board[i][j].setVal(0);
      }
    }
  }

  String get prettyBoard {
    var table = '';

    // to add '0' as prefix for smaller numbers
    var length = '${size.n}'.length;

    // loop through every row of matrix
    for (int row = 0; row < size.n; row++) {
      // Add line break for every row
      table += '\n';

      // Add --+-- if its a edge of box
      if (row != 0 && row % size.sqr == 0) {
        // calculate the number of dashes (-) for 1 box
        var dashes = (size.sqr * 2) + size.sqr * length;

        // multiplies the total dashes number by total box in row
        var totalDashes = dashes * size.sqr;

        // loop for adding dashes
        for (var i = 0; i < totalDashes; i++) {
          // add + sign if its a corner
          if (i != 0 && i % (dashes) == 0) table += '+';
          // adds the dashes
          table += '-';
        }
        // Add line break for every row
        table += '\n';
      }

      // loop through every cell of row
      for (int col = 0; col < size.n; col++) {
        // Add | if its a edge of box with color
        if (col != 0 && col % size.sqr == 0) table += '|';

        // add space before the number
        table += ' ';

        // show the number or if its a zero show '.'
        if (board[row][col].value == 0) {
          table += '.'.padLeft(length, '.');
        } else {
          table += '${board[row][col].value}'.padLeft(length, '0');
        }

        // add space after the number
        table += ' ';
      }
    }
    return table;
  }

  @override
  String toString() {
    return 'Puzzle size: ${size.n}x${size.n}\n'
        'Vacancies: $vacancies\n'
        'Seed: $seed\n'
        '$prettyBoard';
  }
}
