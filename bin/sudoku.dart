import 'package:sudoku/sudoku.dart' hide Cell;

Future<void> main(List<String> arguments) async {
  final sudoku = Sudoku(size: PuzzleSize(size: Sizes.s9, vacancies: 45));
  sudoku.fillValues();
}
