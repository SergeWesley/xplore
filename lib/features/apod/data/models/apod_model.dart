import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/apod_entity.dart';

part 'apod_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApodModel extends ApodEntity {
  const ApodModel({
    required super.title,
    required super.explanation,
    required super.url,
    required super.date,
    super.hdurl,
    required super.mediaType,
    super.copyright,
  });

  factory ApodModel.fromJson(Map<String, dynamic> json) =>
      _$ApodModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApodModelToJson(this);
}
