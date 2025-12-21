// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apod_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApodModel _$ApodModelFromJson(Map<String, dynamic> json) => ApodModel(
  title: json['title'] as String,
  explanation: json['explanation'] as String,
  url: json['url'] as String?,
  date: json['date'] as String,
  hdurl: json['hdurl'] as String?,
  mediaType: json['media_type'] as String,
  copyright: json['copyright'] as String?,
);

Map<String, dynamic> _$ApodModelToJson(ApodModel instance) => <String, dynamic>{
  'title': instance.title,
  'explanation': instance.explanation,
  'url': instance.url,
  'date': instance.date,
  'hdurl': instance.hdurl,
  'media_type': instance.mediaType,
  'copyright': instance.copyright,
};
