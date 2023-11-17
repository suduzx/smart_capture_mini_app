class AccessTokenInfo {
  int? exp;
  int? iat;
  String? jti;
  String? iss;
  List<String>? aud;
  String? sub;
  String? typ;
  String? azp;
  String? sessionState;
  String? acr;
  List<String>? allowedOrigins;
  RealmAccess? realmAccess;
  ResourceAccess? resourceAccess;
  String? scope;
  String? sid;
  bool? emailVerified;
  String? name;
  List<String>? groups;
  String? preferredUsername;
  String? email;

  AccessTokenInfo({
    this.exp,
    this.iat,
    this.jti,
    this.iss,
    this.aud,
    this.sub,
    this.typ,
    this.azp,
    this.sessionState,
    this.acr,
    this.allowedOrigins,
    this.realmAccess,
    this.resourceAccess,
    this.scope,
    this.sid,
    this.emailVerified,
    this.name,
    this.groups,
    this.preferredUsername,
    this.email,
  });

  AccessTokenInfo.fromJson(Map<String, dynamic> json) {
    exp = json['exp'];
    iat = json['iat'];
    jti = json['jti'];
    iss = json['iss'];
    aud = json['aud'].cast<String>();
    sub = json['sub'];
    typ = json['typ'];
    azp = json['azp'];
    sessionState = json['session_state'];
    acr = json['acr'];
    allowedOrigins = json['allowed-origins'].cast<String>();
    realmAccess = json['realm_access'] != null
        ? RealmAccess.fromJson(json['realm_access'])
        : null;
    resourceAccess = json['resource_access'] != null
        ? ResourceAccess.fromJson(json['resource_access'])
        : null;
    scope = json['scope'];
    sid = json['sid'];
    emailVerified = json['email_verified'];
    name = json['name'] ?? json['preferred_username'];
    groups = json['groups'] == null ? [] : json['groups'].cast<String>();
    preferredUsername = json['preferred_username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exp'] = exp;
    data['iat'] = iat;
    data['jti'] = jti;
    data['iss'] = iss;
    data['aud'] = aud;
    data['sub'] = sub;
    data['typ'] = typ;
    data['azp'] = azp;
    data['session_state'] = sessionState;
    data['acr'] = acr;
    data['allowed-origins'] = allowedOrigins;
    if (realmAccess != null) {
      data['realm_access'] = realmAccess!.toJson();
    }
    if (resourceAccess != null) {
      data['resource_access'] = resourceAccess!.toJson();
    }
    data['scope'] = scope;
    data['sid'] = sid;
    data['email_verified'] = emailVerified;
    data['name'] = name;
    data['groups'] = groups;
    data['preferred_username'] = preferredUsername;
    data['email'] = email;
    return data;
  }
}

class RealmAccess {
  List<String>? roles;

  RealmAccess({this.roles});

  RealmAccess.fromJson(Map<String, dynamic> json) {
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roles'] = roles;
    return data;
  }
}

class ResourceAccess {
  RealmAccess? realmManagement;
  RealmAccess? crmFrontend;
  RealmAccess? saleService;
  RealmAccess? pamsServiceV2;
  RealmAccess? pmhServicePentest;
  RealmAccess? ecmSmartScanAdminMcrs;
  RealmAccess? ecmSmartScanWeb;
  RealmAccess? ecmSmartScanDesktop;
  RealmAccess? mymbServiceV1;
  RealmAccess? ecmSmartCaptureMobile;
  RealmAccess? pmhServiceUat;
  RealmAccess? ecmSmartScanAdminWeb;
  RealmAccess? ecmSmartScanMcrs;
  RealmAccess? account;

  ResourceAccess({
    this.realmManagement,
    this.crmFrontend,
    this.saleService,
    this.pamsServiceV2,
    this.pmhServicePentest,
    this.ecmSmartScanAdminMcrs,
    this.ecmSmartScanWeb,
    this.ecmSmartScanDesktop,
    this.mymbServiceV1,
    this.ecmSmartCaptureMobile,
    this.pmhServiceUat,
    this.ecmSmartScanAdminWeb,
    this.ecmSmartScanMcrs,
    this.account,
  });

  ResourceAccess.fromJson(Map<String, dynamic> json) {
    realmManagement = json['realm-management'] != null
        ? RealmAccess.fromJson(json['realm-management'])
        : null;
    crmFrontend = json['crm-frontend'] != null
        ? RealmAccess.fromJson(json['crm-frontend'])
        : null;
    saleService = json['sale-service'] != null
        ? RealmAccess.fromJson(json['sale-service'])
        : null;
    pamsServiceV2 = json['pams-service-v2'] != null
        ? RealmAccess.fromJson(json['pams-service-v2'])
        : null;
    pmhServicePentest = json['pmh-service-pentest'] != null
        ? RealmAccess.fromJson(json['pmh-service-pentest'])
        : null;
    ecmSmartScanAdminMcrs = json['ecm-smart-scan-admin-mcrs'] != null
        ? RealmAccess.fromJson(json['ecm-smart-scan-admin-mcrs'])
        : null;
    ecmSmartScanWeb = json['ecm-smart-scan-web'] != null
        ? RealmAccess.fromJson(json['ecm-smart-scan-web'])
        : null;
    ecmSmartScanDesktop = json['ecm-smart-scan-desktop'] != null
        ? RealmAccess.fromJson(json['ecm-smart-scan-desktop'])
        : null;
    mymbServiceV1 = json['mymb-service-v1'] != null
        ? RealmAccess.fromJson(json['mymb-service-v1'])
        : null;
    ecmSmartCaptureMobile = json['ecm-smart-capture-mobile'] != null
        ? RealmAccess.fromJson(json['ecm-smart-capture-mobile'])
        : null;
    pmhServiceUat = json['pmh-service-uat'] != null
        ? RealmAccess.fromJson(json['pmh-service-uat'])
        : null;
    ecmSmartScanAdminWeb = json['ecm-smart-scan-admin-web'] != null
        ? RealmAccess.fromJson(json['ecm-smart-scan-admin-web'])
        : null;
    ecmSmartScanMcrs = json['ecm-smart-scan-mcrs'] != null
        ? RealmAccess.fromJson(json['ecm-smart-scan-mcrs'])
        : null;
    account =
        json['account'] != null ? RealmAccess.fromJson(json['account']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (realmManagement != null) {
      data['realm-management'] = realmManagement!.toJson();
    }
    if (crmFrontend != null) {
      data['crm-frontend'] = crmFrontend!.toJson();
    }
    if (saleService != null) {
      data['sale-service'] = saleService!.toJson();
    }
    if (pamsServiceV2 != null) {
      data['pams-service-v2'] = pamsServiceV2!.toJson();
    }
    if (pmhServicePentest != null) {
      data['pmh-service-pentest'] = pmhServicePentest!.toJson();
    }
    if (ecmSmartScanAdminMcrs != null) {
      data['ecm-smart-scan-admin-mcrs'] = ecmSmartScanAdminMcrs!.toJson();
    }
    if (ecmSmartScanWeb != null) {
      data['ecm-smart-scan-web'] = ecmSmartScanWeb!.toJson();
    }
    if (ecmSmartScanDesktop != null) {
      data['ecm-smart-scan-desktop'] = ecmSmartScanDesktop!.toJson();
    }
    if (mymbServiceV1 != null) {
      data['mymb-service-v1'] = mymbServiceV1!.toJson();
    }
    if (ecmSmartCaptureMobile != null) {
      data['ecm-smart-capture-mobile'] = ecmSmartCaptureMobile!.toJson();
    }
    if (pmhServiceUat != null) {
      data['pmh-service-uat'] = pmhServiceUat!.toJson();
    }
    if (ecmSmartScanAdminWeb != null) {
      data['ecm-smart-scan-admin-web'] = ecmSmartScanAdminWeb!.toJson();
    }
    if (ecmSmartScanMcrs != null) {
      data['ecm-smart-scan-mcrs'] = ecmSmartScanMcrs!.toJson();
    }
    if (account != null) {
      data['account'] = account!.toJson();
    }
    return data;
  }
}
