mixin DatetimeUtil {
  DateTime string2Datetime(String s) {
    DateTime dt = DateTime.parse(s);
    if (dt.isUtc) {
      dt = dt.toLocal();
    }
    return dt;
  }

  String dateTime2DdMmYyyy(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}';
  }

  String dateTime2HhMi(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String dateTime2HhMiSs(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }
}
