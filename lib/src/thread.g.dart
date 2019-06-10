// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) {
  return Thread(
      success: json['success'] as int,
      server_time: json['server_time'] as int,
      response: json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'success': instance.success,
      'server_time': instance.server_time,
      'response': instance.response
    };

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      is_pagination: json['is_pagination'] as bool,
      items: (json['items'] as List)
          ?.map((e) =>
              e == null ? null : Item.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'category': instance.category,
      'is_pagination': instance.is_pagination,
      'items': instance.items
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      cat_id: json['cat_id'] as String,
      name: json['name'] as String,
      postable: json['postable'] as bool);
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'cat_id': instance.cat_id,
      'name': instance.name,
      'postable': instance.postable
    };

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      thread_id: json['thread_id'] as String,
      cat_id: json['cat_id'] as String,
      sub_cat_id: json['sub_cat_id'] as String,
      title: json['title'] as String,
      user_id: json['user_id'] as String,
      user_nickname: json['user_nickname'] as String,
      user_gender: json['user_gender'] as String,
      no_of_reply: json['no_of_reply'] as String,
      no_of_uni_user_reply: json['no_of_uni_user_reply'] as String,
      like_count: json['like_count'] as String,
      dislike_count: json['dislike_count'] as String,
      reply_like_count: json['reply_like_count'] as String,
      reply_dislike_count: json['reply_dislike_count'] as String,
      max_reply_like_count: json['max_reply_like_count'] as String,
      max_reply_dislike_count: json['max_reply_dislike_count'] as String,
      create_time: json['create_time'] as int,
      last_reply_time: json['last_reply_time'] as int,
      status: json['status'] as String,
      is_adu: json['is_adu'] as bool,
      remark: json['remark'] == null
          ? null
          : Remark.fromJson(json['remark'] as Map<String, dynamic>),
      last_reply_user_id: json['last_reply_user_id'] as String,
      max_reply: json['max_reply'] as String,
      total_page: json['total_page'] as int,
      is_hot: json['is_hot'] as bool,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      is_bookmarked: json['is_bookmarked'] as bool,
      is_replied: json['is_replied'] as bool,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'thread_id': instance.thread_id,
      'cat_id': instance.cat_id,
      'sub_cat_id': instance.sub_cat_id,
      'title': instance.title,
      'user_id': instance.user_id,
      'user_nickname': instance.user_nickname,
      'user_gender': instance.user_gender,
      'no_of_reply': instance.no_of_reply,
      'no_of_uni_user_reply': instance.no_of_uni_user_reply,
      'like_count': instance.like_count,
      'dislike_count': instance.dislike_count,
      'reply_like_count': instance.reply_like_count,
      'reply_dislike_count': instance.reply_dislike_count,
      'max_reply_like_count': instance.max_reply_like_count,
      'max_reply_dislike_count': instance.max_reply_dislike_count,
      'status': instance.status,
      'last_reply_user_id': instance.last_reply_user_id,
      'max_reply': instance.max_reply,
      'create_time': instance.create_time,
      'last_reply_time': instance.last_reply_time,
      'total_page': instance.total_page,
      'is_adu': instance.is_adu,
      'is_hot': instance.is_hot,
      'is_bookmarked': instance.is_bookmarked,
      'is_replied': instance.is_replied,
      'remark': instance.remark,
      'category': instance.category,
      'user': instance.user
    };

Remark _$RemarkFromJson(Map<String, dynamic> json) {
  return Remark(last_reply_count: json['last_reply_count'] as int);
}

Map<String, dynamic> _$RemarkToJson(Remark instance) =>
    <String, dynamic>{'last_reply_count': instance.last_reply_count};

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      user_id: json['user_id'] as String,
      nickname: json['nickname'] as String,
      level: json['level'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
      create_time: json['create_time'] as int,
      level_name: json['level_name'] as String,
      is_following: json['is_following'] as bool,
      is_blocked: json['is_blocked'] as bool,
      is_disappear: json['is_disappear'] as bool);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'nickname': instance.nickname,
      'level': instance.level,
      'gender': instance.gender,
      'status': instance.status,
      'level_name': instance.level_name,
      'create_time': instance.create_time,
      'is_following': instance.is_following,
      'is_blocked': instance.is_blocked,
      'is_disappear': instance.is_disappear
    };
