// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return Property(
      success: json['success'] as int,
      server_time: json['server_time'] as int,
      response: json['response'] == null
          ? null
          : Response.fromJson(json['response'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'success': instance.success,
      'server_time': instance.server_time,
      'response': instance.response
    };

Response _$ResponseFromJson(Map<String, dynamic> json) {
  return Response(
      lihkg: json['lihkg'] as bool,
      category_list: (json['category_list'] as List)
          ?.map((e) =>
              e == null ? null : Category.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      fixed_category_list: (json['fixed_category_list'] as List)
          ?.map((e) => e == null
              ? null
              : Fixed_category.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      config: json['config']);
}

Map<String, dynamic> _$ResponseToJson(Response instance) => <String, dynamic>{
      'lihkg': instance.lihkg,
      'category_list': instance.category_list,
      'fixed_category_list': instance.fixed_category_list,
      'config': instance.config
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
      cat_id: json['cat_id'] as String,
      name: json['name'] as String,
      postable: json['postable'] as bool,
      type: json['type'] as String,
      url: json['url'] as String,
      query: (json['query'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      sub_category: (json['sub_category'] as List)
          ?.map((e) => e == null
              ? null
              : Sub_category.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'cat_id': instance.cat_id,
      'name': instance.name,
      'postable': instance.postable,
      'type': instance.type,
      'url': instance.url,
      'query': instance.query,
      'sub_category': instance.sub_category
    };

Sub_category _$Sub_categoryFromJson(Map<String, dynamic> json) {
  return Sub_category(
      cat_id: json['cat_id'] as String,
      sub_cat_id: json['sub_cat_id'],
      name: json['name'] as String,
      postable: json['postable'] as bool,
      filterable: json['filterable'] as bool,
      orderable: json['orderable'] as bool,
      is_filter: json['is_filter'] as bool,
      url: json['url'] as String,
      query: (json['query'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as String),
      ));
}

Map<String, dynamic> _$Sub_categoryToJson(Sub_category instance) =>
    <String, dynamic>{
      'cat_id': instance.cat_id,
      'sub_cat_id': instance.sub_cat_id,
      'name': instance.name,
      'postable': instance.postable,
      'filterable': instance.filterable,
      'orderable': instance.orderable,
      'is_filter': instance.is_filter,
      'url': instance.url,
      'query': instance.query
    };

Fixed_category _$Fixed_categoryFromJson(Map<String, dynamic> json) {
  return Fixed_category(
      name: json['name'] as String,
      cat_list: (json['cat_list'] as List)
          ?.map((e) =>
              e == null ? null : Category.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$Fixed_categoryToJson(Fixed_category instance) =>
    <String, dynamic>{'name': instance.name, 'cat_list': instance.cat_list};
