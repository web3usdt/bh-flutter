class UserGoogleUnbindReq {
  String? googleCode;
  String? emailCode;

  UserGoogleUnbindReq({this.googleCode, this.emailCode});

  Map<String, dynamic> toJson() => {
        'google_code': googleCode,
        'email_code': emailCode,
      };
}
