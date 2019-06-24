// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) {
  return Login(
      success: json['success'] as int,
      server_time: json['server_time'] as int,
      response: json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>),
      error_code: json['error_code'] as int,
      error_message: json['error_message'] as String);
}

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'success': instance.success,
      'server_time': instance.server_time,
      'response': instance.response,
      'error_code': instance.error_code,
      'error_message': instance.error_message
    };

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
      token: json['token'] as String,
      keyword_filter_list: json['keyword_filter_list'] as List,
      category_order:
          (json['category_order'] as List)?.map((e) => e as String)?.toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      fixed_category_list: (json['fixed_category_list'] as List)
          ?.map((e) => e == null
              ? null
              : Fixed_category.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      me: json['me'] == null
          ? null
          : User.fromJson(json['me'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'token': instance.token,
      'keyword_filter_list': instance.keyword_filter_list,
      'category_order': instance.category_order,
      'user': instance.user,
      'fixed_category_list': instance.fixed_category_list,
      'me': instance.me
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      user_id: json['user_id'] as String,
      nickname: json['nickname'] as String,
      email: json['email'] as String,
      level: json['level'] as String,
      gender: json['gender'] as String,
      status: json['status'] as String,
      plus_expiry_time: json['plus_expiry_time'] as int,
      create_time: json['create_time'] as int,
      last_login_time: json['last_login_time'] as int,
      level_name: json['level_name'] as String,
      is_disappear: json['is_disappear'] as bool,
      is_plus_user: json['is_plus_user'] as bool,
      meta_data: json['meta_data'] == null
          ? null
          : MetaData.fromJson(json['meta_data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.user_id,
      'nickname': instance.nickname,
      'email': instance.email,
      'level': instance.level,
      'gender': instance.gender,
      'status': instance.status,
      'level_name': instance.level_name,
      'plus_expiry_time': instance.plus_expiry_time,
      'create_time': instance.create_time,
      'last_login_time': instance.last_login_time,
      'is_disappear': instance.is_disappear,
      'is_plus_user': instance.is_plus_user,
      'meta_data': instance.meta_data
    };

MetaData _$MetaDataFromJson(Map<String, dynamic> json) {
  return MetaData(
      custom_cat:
          (json['custom_cat'] as List)?.map((e) => e as String)?.toList(),
      keyword_filter: json['keyword_filter'] as String,
      login_count: json['login_count'] as int,
      last_read_notify_time: json['last_read_notify_time'] as int,
      notify_count: json['notify_count'] as int,
      push_setting: json['push_setting'] == null
          ? null
          : PushSetting.fromJson(json['push_setting'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'custom_cat': instance.custom_cat,
      'keyword_filter': instance.keyword_filter,
      'login_count': instance.login_count,
      'last_read_notify_time': instance.last_read_notify_time,
      'notify_count': instance.notify_count,
      'push_setting': instance.push_setting
    };

PushSetting _$PushSettingFromJson(Map<String, dynamic> json) {
  return PushSetting(
      all: json['all'] as bool,
      show_preview: json['show_preview'] as bool,
      new_reply: json['new_reply'] as bool,
      quote: json['quote'] as bool,
      following_new_thread: json['following_new_thread'] as bool);
}

Map<String, dynamic> _$PushSettingToJson(PushSetting instance) =>
    <String, dynamic>{
      'all': instance.all,
      'show_preview': instance.show_preview,
      'new_reply': instance.new_reply,
      'quote': instance.quote,
      'following_new_thread': instance.following_new_thread
    };
