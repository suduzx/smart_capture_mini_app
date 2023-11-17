class SignInRequestDto {
  String? username;
  String? password;
  String? clientId;

  SignInRequestDto({
    this.username,
    this.password,
    this.clientId,
  });

  SignInRequestDto.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    clientId = json['clientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['clientId'] = clientId;
    return data;
  }
}
