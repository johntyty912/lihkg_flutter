import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'page.g.dart';

@JsonSerializable()
class Page {
  Page({
    this.success,
    this.server_time,
    this.response,
    this.error_code,
    this.error_message,
  });

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  Map<String, dynamic> toJson() => _$PageToJson(this);

  final int success;
  final int server_time;
  final Response response;
  final int error_code;
  final String error_message;
}

@JsonSerializable()
class Response {
  Response({
    this.thread_id,
    this.cat_id,
    this.sub_cat_id,
    this.title,
    this.user_id,
    this.user_nickname,
    this.user_gender,
    this.no_of_reply,
    this.no_of_uni_user_reply,
    this.like_count,
    this.dislike_count,
    this.reply_like_count,
    this.reply_dislike_count,
    this.max_reply_like_count,
    this.max_reply_dislike_count,
    this.create_time,
    this.last_reply_time,
    this.status,
    this.is_adu,
    this.remark,
    this.last_reply_user_id,
    this.max_reply,
    this.total_page,
    this.is_hot,
    this.category,
    this.is_bookmarked,
    this.is_replied,
    this.user,
    this.page,
    this.item_data,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  final String thread_id,
      cat_id,
      sub_cat_id,
      title,
      user_id,
      user_nickname,
      user_gender,
      no_of_reply,
      no_of_uni_user_reply,
      like_count,
      dislike_count,
      reply_like_count,
      reply_dislike_count,
      max_reply_like_count,
      max_reply_dislike_count,
      status,
      last_reply_user_id,
      max_reply,
      page;
  final int create_time, last_reply_time, total_page;
  final bool is_adu, is_hot, is_bookmarked, is_replied;
  final Remark remark;
  final Category category;
  final User user;
  final List<Item_data> item_data;
}

@JsonSerializable()
class Remark {
  Remark({
    this.last_reply_count,
  });

  factory Remark.fromJson(Map<String, dynamic> json) => _$RemarkFromJson(json);
  Map<String, dynamic> toJson() => _$RemarkToJson(this);

  final int last_reply_count;
}

@JsonSerializable()
class Category {
  Category({
    this.cat_id,
    this.name,
    this.postable,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  final dynamic cat_id;
  final String name;
  final bool postable;
}

@JsonSerializable()
class User {
  User({
    this.user_id,
    this.nickname,
    this.level,
    this.gender,
    this.status,
    this.create_time,
    this.level_name,
    this.is_following,
    this.is_blocked,
    this.is_disappear,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String user_id, nickname, level, gender, status, level_name;
  final int create_time;
  final bool is_following, is_blocked, is_disappear;
}

@JsonSerializable()
class Item_data {
  Item_data({
    this.post_id,
    this.quote_post_id,
    this.thread_id,
    this.user_nickname,
    this.user_gender,
    this.like_count,
    this.dislike_count,
    this.vote_score,
    this.no_of_quote,
    this.status,
    this.reply_time,
    this.msg_num,
    this.msg,
    this.user,
    this.page,
    this.quote,
  });

  factory Item_data.fromJson(Map<String, dynamic> json) =>
      _$Item_dataFromJson(json);
  Map<String, dynamic> toJson() => _$Item_dataToJson(this);

  final String post_id,
      quote_post_id,
      thread_id,
      user_nickname,
      user_gender,
      like_count,
      dislike_count,
      vote_score,
      no_of_quote,
      msg_num,
      msg;
  final int reply_time, page;
  final dynamic status;
  final User user;
  final Item_data quote;
}

Future<Page> getPage(String pageURL, Map<String, String> query, [Map<String, String> headers]) async {
  final Uri uri = Uri.parse(pageURL).replace(queryParameters: query);
  dynamic response;
  if (headers == null) {
    response = await http.get(uri.toString());
  } else {
    response = await http.get(uri.toString(), headers: headers);
  }
  if (response.statusCode == 200) {
    return Page.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: uri);
  }
}
