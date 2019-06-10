import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  Property({
    this.success,
    this.server_time,
    this.response,
  });

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  final int success;
  final int server_time;
  final Response response;
}

@JsonSerializable()
class Response {
  Response({
    this.lihkg,
    this.category_list,
    this.fixed_category_list,
    this.config,
  });

  factory Response.fromJson(Map<String, dynamic> json) => _$ResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseToJson(this);

  final bool lihkg;
  final List<Category> category_list;
  final List<Fixed_category> fixed_category_list; //TODO: define class
  final dynamic config; //TODO: define class
}

@JsonSerializable()
class Category {
  Category({
    this.cat_id,
    this.name,
    this.postable,
    this.type,
    this.url,
    this.query,
    this.sub_category,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  final String cat_id;
  final String name;
  final bool postable;
  final String type;
  final String url;
  final Map<String, String> query;
  final List<Sub_category> sub_category;
}

@JsonSerializable()
class Sub_category {
  Sub_category({
    this.cat_id,
    this.sub_cat_id,
    this.name,
    this.postable,
    this.filterable,
    this.orderable,
    this.is_filter,
    this.url,
    this.query,
  });

  factory Sub_category.fromJson(Map<String, dynamic> json) => _$Sub_categoryFromJson(json);
  Map<String, dynamic> toJson() => _$Sub_categoryToJson(this);

  final String cat_id;
  final dynamic sub_cat_id;
  final String name;
  final bool postable;
  final bool filterable;
  final bool orderable;
  final bool is_filter;
  final String url;
  final Map<String,String> query;
}

@JsonSerializable()
class Fixed_category {
  Fixed_category({
    this.name,
    this.cat_list,
  });

  factory Fixed_category.fromJson(Map<String, dynamic> json) => _$Fixed_categoryFromJson(json);
  Map<String, dynamic> toJson() => _$Fixed_categoryToJson(this);

  final String name;
  final List<Category> cat_list;
}


Future<Property> getProperty() async {
  const propertyURL = 'https://lihkg.com/api_v2/system/property';

  final response = await http.get(propertyURL);
  if (response.statusCode == 200) {
    return Property.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(propertyURL));
  }
}