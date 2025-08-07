class VersionUpdateModel {
  String? content;
  String? device;
  int? isForce;
  int? type;
  String? url;
  String? version;
  String? h5Url;

  VersionUpdateModel({
    this.content,
    this.device,
    this.isForce,
    this.type,
    this.url,
    this.version,
    this.h5Url,
  });

  factory VersionUpdateModel.fromJson(Map<String, dynamic> json) {
    return VersionUpdateModel(
      type: json['type'] as int?,
      content: json['content'] as String?,
      device: json['device'] as String?,
      isForce: json['is_force'] as int?,
      url: json['url'] as String?,
      version: json['version'] as String?,
      h5Url: json['h5_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'content': content,
        'device': device,
        'is_force': isForce,
        'url': url,
        'version': version,
        'h5_url': h5Url,
      };
}
