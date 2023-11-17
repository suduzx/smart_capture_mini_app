import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class SyncBPMResponseDto extends ApiResponseDataResultGeneric {
  String? id;
  int? treeLevel;
  Root? root;

  SyncBPMResponseDto({this.id, this.treeLevel, this.root});

  SyncBPMResponseDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treeLevel = json['treeLevel'];
    root = json['root'] != null ? Root.fromJson(json['root']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['treeLevel'] = treeLevel;
    if (root != null) {
      data['root'] = root!.toJson();
    }
    return data;
  }
}

class Root {
  String? version;
  RootProperties? properties;
  List<ChildrenNodes>? childrenNodes;

  Root({this.version, this.properties, this.childrenNodes});

  Root.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    properties = json['properties'] != null
        ? RootProperties.fromJson(json['properties'])
        : null;
    if (json['childrenNodes'] != null) {
      childrenNodes = <ChildrenNodes>[];
      json['childrenNodes'].forEach((v) {
        childrenNodes!.add(ChildrenNodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    if (childrenNodes != null) {
      data['childrenNodes'] =
          childrenNodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RootProperties {
  String? name;
  String? nodeType;
  String? type;
  String? bpmDocumentCode;
  String? bpmLoanId;

  RootProperties(
      {this.name,
      this.nodeType,
      this.type,
      this.bpmDocumentCode,
      this.bpmLoanId});

  RootProperties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodeType = json['nodeType'];
    type = json['type'];
    bpmDocumentCode = json['bpmDocumentCode'];
    bpmLoanId = json['bpmLoanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nodeType'] = nodeType;
    data['type'] = type;
    data['bpmDocumentCode'] = bpmDocumentCode;
    data['bpmLoanId'] = bpmLoanId;
    return data;
  }
}

class ChildrenNodes {
  String? version;
  Properties? properties;
  String? extractData;
  String? storageInfo;
  String? childrenNodes;
  String? dataFileId;
  List<String>? childrenDataFileIds;
  String? syncDataFile;
  String? childrenSyncDataFiles;

  ChildrenNodes(
      {this.version,
      this.properties,
      this.extractData,
      this.storageInfo,
      this.childrenNodes,
      this.dataFileId,
      this.childrenDataFileIds,
      this.syncDataFile,
      this.childrenSyncDataFiles});

  ChildrenNodes.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    extractData = json['extractData'];
    storageInfo = json['storageInfo'];
    childrenNodes = json['childrenNodes'];
    dataFileId = json['dataFileId'];
    childrenDataFileIds = (json['childrenDataFileIds'] ?? []).cast<String>();
    syncDataFile = json['syncDataFile'];
    childrenSyncDataFiles = json['childrenSyncDataFiles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    data['extractData'] = extractData;
    data['storageInfo'] = storageInfo;
    data['childrenNodes'] = childrenNodes;
    data['dataFileId'] = dataFileId;
    data['childrenDataFileIds'] = childrenDataFileIds;
    data['syncDataFile'] = syncDataFile;
    data['childrenSyncDataFiles'] = childrenSyncDataFiles;
    return data;
  }
}

class Properties {
  String? name;
  String? nodeType;
  String? type;
  String? bpmDocumentCode;
  String? bpmLoanId;

  Properties(
      {this.name,
      this.nodeType,
      this.type,
      this.bpmDocumentCode,
      this.bpmLoanId});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodeType = json['nodeType'];
    type = json['type'];
    bpmDocumentCode = json['bpmDocumentCode'];
    bpmLoanId = json['bpmLoanId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nodeType'] = nodeType;
    data['type'] = type;
    data['bpmDocumentCode'] = bpmDocumentCode;
    data['bpmLoanId'] = bpmLoanId;
    return data;
  }
}
