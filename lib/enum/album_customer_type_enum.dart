enum CustomerType {
  khcn(isSelected: _personalIsSelected, text: "Cá nhân"),
  khdn(isSelected: _businessIsSelected, text: "Doanh nghiệp");

  const CustomerType({
    required this.isSelected,
    required this.text,
  });

  final bool Function(CustomerType customerType) isSelected;
  final String text;

  @override
  String toString() => name;

  static CustomerType fromString(String value) {
    Iterable<CustomerType> iterable =
        CustomerType.values.where((element) => element.name == value);
    return iterable.isEmpty ? CustomerType.khcn : iterable.first;
  }
}

bool _personalIsSelected(CustomerType customerType) {
  return customerType == CustomerType.khcn ? true : false;
}

bool _businessIsSelected(CustomerType customerType) {
  return customerType == CustomerType.khdn ? true : false;
}
