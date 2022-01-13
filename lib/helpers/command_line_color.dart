///Escape sequences to get the color effects in terminal output
class CL {
  ///RED
  static const r = "\x1B[31m";

  ///GREEN
  static const g = "\x1B[32m";

  ///YELLOW
  static const y = "\x1B[33m";

  ///BLUE
  static const b = "\x1B[34m";

  ///MAGENTA
  static const m = "\x1B[35m";

  ///CYAN
  static const c = "\x1B[36m";

  ///WHITE
  static const w = "\x1B[37m";

  ///for reset the applied color
  static const rt = "\x1B[0m";
}
