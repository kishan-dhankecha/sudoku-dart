/* Dart program for Sudoku generator */
import 'dart:math' show Random, Point;

import '../helpers/command_line_color.dart';
import 'cell.dart';
import 'puzzle_size.dart';

export 'dart:math' show Random;

export 'cell.dart';
export 'puzzle_size.dart';

class Sudoku {
  /// Defines the [PuzzleSize] of the current sudoku board.
  final PuzzleSize size;

  late final Random rand;

  late final int seed;

  /// Matrix of [Cell] for the current sudoku board.
  late List<List<Cell>> matrix;

  Sudoku({int? seed, required this.size}) {
    /// Generate the new [matrix] with relative point and value as 0.
    matrix = List.generate(size.n, (x) {
      return List.generate(size.n, (y) {
        return Cell(Point(x, y));
      }, growable: false);
    }, growable: false);

    if (seed == null) {
      this.seed = DateTime.now().millisecondsSinceEpoch;
    } else {
      this.seed = seed;
    }

    /// Seed the seed for new game
    rand = Random(this.seed);

    fillValues();
  }

  /// Sudoku Generator
  void fillValues() {
    final stopwatch = Stopwatch()..start();
    var attept = 0;
    do {
      attept++;
      _fillDiagonal();
    } while (!_fillRemaining(0, size.sq));
    _addVacancies();
    stopwatch.stop();
    printPuzzle(time: stopwatch.elapsed.inMilliseconds, attept: attept);
  }

  /// Fill the diagonal [size.sq] x [size.sq] metrix of [size.n] x [size.n] matrices
  void _fillDiagonal() {
    for (int i = 0; i < size.n; i = i + size.sq) {
      // for diagonal box, start coordinates -> i==j
      _fillBox(i, i);
    }
  }

  /// Fill a [size.sq] x [size.sq] matrix.
  void _fillBox(int row, int col) {
    var options = List.generate(size.n, (index) => index + 1);
    for (int i = 0; i < size.sq; i++) {
      for (int j = 0; j < size.sq; j++) {
        var n = options[rand.nextInt(options.length)];
        matrix[row + i][col + j].setVal(n);
        options.remove(n);
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

    if (x < size.sq) {
      if (y < size.sq) y = size.sq;
    } else if (x < size.n - size.sq) {
      if (y == (x ~/ size.sq) * size.sq) y = y + size.sq;
    } else {
      if (y == size.n - size.sq) {
        x = x + 1;
        y = 0;
        if (x >= size.n) return true;
      }
    }
    for (int n = 1; n <= size.n; n++) {
      if (_checkIfSafe(x, y, n)) {
        matrix[x][y].setVal(n);
        if (_fillRemaining(x, y + 1)) return true;
        matrix[x][y].setVal(0);
      }
    }
    return false;
  }

  /// Check if safe to put in cell
  bool _checkIfSafe(int i, int j, int n) {
    return (_availInRow(i, n) &&
        _availInCol(j, n) &&
        _availInBox(i - i % size.sq, j - j % size.sq, n));
  }

  /// check in the row for existence
  bool _availInRow(int i, int n) {
    for (int j = 0; j < size.n; j++) {
      if (matrix[i][j].value == n) return false;
    }
    return true;
  }

  /// check in the row for existence
  bool _availInCol(int j, int n) {
    for (int i = 0; i < size.n; i++) {
      if (matrix[i][j].value == n) return false;
    }
    return true;
  }

  /// Returns true if given 3 x 3 block contains num.
  bool _availInBox(int rowStart, int colStart, int number) {
    for (var i = 0; i < size.sq; i++) {
      for (var j = 0; j < size.sq; j++) {
        if (matrix[rowStart + i][colStart + j].value == number) return false;
      }
    }
    return true;
  }

  /// Add [vacancies] to complete game
  void _addVacancies() {
    int count = size.vacancies;
    while (count != 0) {
      int i = rand.nextInt(size.n);
      int j = rand.nextInt(size.n);
      if (matrix[i][j].value != 0) {
        count--;
        matrix[i][j].setVal(0);
      }
    }
  }

  void displayPuzzle() {
    var table = '';

    // to add '0' as prefix for smaller numbers
    var length = '${size.n}'.length;

    // loop through every row of matrix
    for (int row = 0; row < size.n; row++) {
      // Add line break for every row
      table += '\n';

      // Add --+-- if its a edge of box
      if (row != 0 && row % size.sq == 0) {
        // set termial color
        table += size.clColor;

        // calculate the number of dashes (-) for 1 box
        var dashes = (size.sq * 2) + size.sq * length;

        // multiplies the total dashes number by total box in row
        var totalDashes = dashes * size.sq;

        // loop for adding dashes
        for (var i = 0; i < totalDashes; i++) {
          // add + sign if its a corner
          if (i != 0 && i % (dashes) == 0) table += '+';
          // adds the dashes
          table += '-';
        }
        // reset termial color
        table += '${CL.rt}\n';
      }

      // loop through every cell of row
      for (int col = 0; col < size.n; col++) {
        // Add | if its a edge of box with color
        if (col != 0 && col % size.sq == 0) table += '${size.clColor}|${CL.rt}';

        // add space before the number
        table += ' ';

        // show the number or if its a zero show '.'
        if (matrix[row][col].value == 0) {
          table += '.'.padLeft(length, '.');
        } else {
          table += '${matrix[row][col].value}'.padLeft(length, '0');
        }

        // add space after the number
        table += ' ';
      }
    }
    table += '\n\n';
    print(table);
  }

  void printPuzzle({required int time, required int attept}) {
    print(this);
    displayPuzzle();
    print('Seed: ${size.clColor}$seed${CL.rt}');
    print('Time taken to generate: ${size.clColor}${time}ms${CL.rt}');
    print('Attepts to get solvable puzzle: ${size.clColor}$attept${CL.rt}');
  }

  @override
  String toString() {
    return ''
        'Puzzle size: '
        '${size.clColor}${size.n}x${size.n}${CL.rt}\n'
        'Vacancies: '
        '${size.clColor}${size.vacancies}${CL.rt}';
  }
}
