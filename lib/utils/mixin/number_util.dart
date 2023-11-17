mixin NumberUtil {
  int string2Int(String str) {
    try {
      return int.parse(str);
    } on FormatException {
      return 0;
    }
  }
}
