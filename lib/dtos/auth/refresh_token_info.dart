class RefreshTokenInfo {
  int? exp;
  int? iat;
  String? jti;
  String? iss;
  String? aud;
  String? sub;
  String? typ;
  String? azp;
  String? sessionState;
  String? scope;
  String? sid;

  RefreshTokenInfo(
      {this.exp,
      this.iat,
      this.jti,
      this.iss,
      this.aud,
      this.sub,
      this.typ,
      this.azp,
      this.sessionState,
      this.scope,
      this.sid});

  RefreshTokenInfo.fromJson(Map<String, dynamic> json) {
    exp = json['exp'];
    iat = json['iat'];
    jti = json['jti'];
    iss = json['iss'];
    aud = json['aud'];
    sub = json['sub'];
    typ = json['typ'];
    azp = json['azp'];
    sessionState = json['session_state'];
    scope = json['scope'];
    sid = json['sid'];
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
    data['scope'] = scope;
    data['sid'] = sid;
    return data;
  }
}
