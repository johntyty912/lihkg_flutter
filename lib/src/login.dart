import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:lihkg_flutter/src/property.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  Login({
    this.success,
    this.server_time,
    this.response,
    this.error_code,
    this.error_message,
  });

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);
  Map<String, dynamic> toJson() => _$LoginToJson(this);

  final int success;
  final int server_time;
  final Response response;
  final int error_code;
  final String error_message;
}

@JsonSerializable()
class Response {
  Response({
    this.token,
    this.keyword_filter_list,
    this.category_order,
    this.user,
    this.fixed_category_list,
    this.me,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  final String token;
  final List keyword_filter_list;
  final List<String> category_order;
  final User user;
  final List<Fixed_category> fixed_category_list;
  final User me;
}

@JsonSerializable()
class User {
  User({
    this.user_id,
    this.nickname,
    this.email,
    this.level,
    this.gender,
    this.status,
    this.plus_expiry_time,
    this.create_time,
    this.last_login_time,
    this.level_name,
    this.is_disappear,
    this.is_plus_user,
    this.meta_data,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String user_id, nickname, email, level, gender, status, level_name;
  final int plus_expiry_time, create_time, last_login_time;
  final bool is_disappear, is_plus_user;
  final MetaData meta_data;
}

@JsonSerializable()
class MetaData {
  MetaData({
    this.custom_cat,
    this.keyword_filter,
    this.login_count,
    this.last_read_notify_time,
    this.notify_count,
    this.push_setting,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);
  Map<String, dynamic> toJson() => _$MetaDataToJson(this);

  final List<String> custom_cat;
  final String keyword_filter;
  final int login_count, last_read_notify_time, notify_count;
  final PushSetting push_setting;
}

@JsonSerializable()
class PushSetting {
  PushSetting({
    this.all,
    this.show_preview,
    this.new_reply,
    this.quote,
    this.following_new_thread,
  });

  factory PushSetting.fromJson(Map<String, dynamic> json) =>
      _$PushSettingFromJson(json);
  Map<String, dynamic> toJson() => _$PushSettingToJson(this);

  final bool all, show_preview, new_reply, quote, following_new_thread;
}

Future<Login> pushLogin(Map<String, String> body) async {
  final String loginURL = "https://lihkg.com/api_v2/auth/login";
  final response = await http.post(loginURL, body: body);
  if (response.statusCode == 200) {
    return Login.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(loginURL));
  }
}
