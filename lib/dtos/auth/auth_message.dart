class AuthMessage {
  String? error;
  String? errorDescription;

  AuthMessage({
    this.error,
    this.errorDescription,
  });

  AuthMessage.fromJson(Map<String, dynamic> json) {
    error = json['error'] as String?;
    errorDescription = json['error_description'] as String?;
  }
}
