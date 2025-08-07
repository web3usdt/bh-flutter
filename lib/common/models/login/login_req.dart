class LoginReq {
  String? account;
  String? password;
  int? type;
  String? googleCode;
  String? signature;

  LoginReq({this.account, this.password, this.type, this.googleCode, this.signature});

  factory LoginReq.fromJson(Map<String, dynamic> json) => LoginReq(
        account: json['account'] as String?,
        password: json['password'] as String?,
        type: json['type'] as int?,
        googleCode: json['google_code'] as String?,
        signature: json['signature'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'account': account,
        'password': password,
        'type': type,
        'google_code': googleCode,
        'signature': signature,
      };
}
