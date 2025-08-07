class LoginConfirmReq {
  String? code;
  int? codeType;
  String? signature;

  LoginConfirmReq({this.code, this.codeType, this.signature});

  Map<String, dynamic> toJson() => {
        'code': code,
        'code_type': codeType,
        'signature': signature,
      };
}
