class HomeNoticeListModel {
  int? id;
  int? adminUserId;
  int? categoryId;
  int? viewCount;
  dynamic cover;
  int? status;
  int? order;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  int? isRecommend;
  String? categoryName;
  String? fullCover;
  String? title;
  String? body;
  dynamic excerpt;

  HomeNoticeListModel({
    this.id,
    this.adminUserId,
    this.categoryId,
    this.viewCount,
    this.cover,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isRecommend,
    this.categoryName,
    this.fullCover,
    this.title,
    this.body,
    this.excerpt,
  });

  factory HomeNoticeListModel.fromJson(Map<String, dynamic> json) {
    return HomeNoticeListModel(
      id: json['id'] as int?,
      adminUserId: json['admin_user_id'] as int?,
      categoryId: json['category_id'] as int?,
      viewCount: json['view_count'] as int?,
      cover: json['cover'] as dynamic,
      status: json['status'] as int?,
      order: json['order'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as dynamic,
      isRecommend: json['is_recommend'] as int?,
      categoryName: json['category_name'] as String?,
      fullCover: json['full_cover'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      excerpt: json['excerpt'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'admin_user_id': adminUserId,
        'category_id': categoryId,
        'view_count': viewCount,
        'cover': cover,
        'status': status,
        'order': order,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'is_recommend': isRecommend,
        'category_name': categoryName,
        'full_cover': fullCover,
        'title': title,
        'body': body,
        'excerpt': excerpt,
      };
}
