import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'thread.g.dart';

@JsonSerializable()
class Thread {
  Thread({
    this.success,
    this.server_time,
    this.response,
  });

  factory Thread.fromJson(Map<String, dynamic> json) => _$ThreadFromJson(json);
  Map<String, dynamic> toJson() => _$ThreadToJson(this);

  final int success;
  final int server_time;
  final Response response;
}

@JsonSerializable()
class Response {
  Response({
    this.category,
    this.is_pagination,
    this.items,
  });

  factory Response.fromJson(Map<String, dynamic> json) =>
      _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  final Category category;
  final bool is_pagination;
  final List<Item> items;
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
class Item {
  Item({
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
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

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
      max_reply;
  final int create_time, last_reply_time, total_page;
  final bool is_adu, is_hot, is_bookmarked, is_replied;
  final Remark remark;
  final Category category;
  final User user;
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

Future<Thread> getThread(String threadURL, Map<String, String> query) async {
  final Uri uri = Uri.parse(threadURL).replace(queryParameters: query);
  final response = await http.get(uri.toString());
  if (response.statusCode == 200) {
    return Thread.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: uri);
  }
}
