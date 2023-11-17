enum ActionLogEnum {
  login,
  takePhoto,
  editImage,
  other;

  @override
  String toString() => name;

  static ActionLogEnum fromString(String value) {
    Iterable<ActionLogEnum> iterable =
        ActionLogEnum.values.where((element) => element.name == value);
    return iterable.isEmpty ? ActionLogEnum.other : iterable.first;
  }
}
