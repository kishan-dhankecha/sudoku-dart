import 'dart:math' show Point;

class Cell {
  final Point<int> point;
  int _value;

  Cell(this.point, [this._value = 0]);

  int get value => _value;
  void setVal(int n) {
    _value = n;
  }
}
