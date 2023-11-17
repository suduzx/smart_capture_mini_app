class RootPropertiesDto {
  String? name;
  String? nodeType;
  String? bpmDocumentCode;
  String? bpmLoanId;

  RootPropertiesDto(
      {String? name,
      String? nodeType,
      String? bpmDocumentCode,
      String? bpmLoanId}) {
    if (name != null) {
      this.name = name;
    }
    if (nodeType != null) {
      this.nodeType = nodeType;
    }
    if (bpmDocumentCode != null) {
      this.bpmDocumentCode = bpmDocumentCode;
    }
    if (bpmLoanId != null) {
      this.bpmLoanId = bpmLoanId;
    }
  }

  RootPropertiesDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodeType = json['nodeType'];
    bpmDocumentCode = json['bpmDocumentCode'];
    bpmLoanId = json['bpmLoanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nodeType'] = nodeType;
    data['bpmDocumentCode'] = bpmDocumentCode;
    data['bpmLoanId'] = bpmLoanId;
    return data;
  }
}
