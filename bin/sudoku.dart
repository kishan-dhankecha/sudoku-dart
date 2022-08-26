import 'package:sudoku/sudoku.dart' hide Cell;

Future<void> main(List<String> arguments) async {
  final sudoku = Sudoku(size: PuzzleSize.s9);
  print(sudoku);
}
