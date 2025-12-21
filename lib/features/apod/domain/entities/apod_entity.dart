import 'package:equatable/equatable.dart';

class ApodEntity extends Equatable {
  final String title;
  final String explanation;
  final String? url;
  final String date;
  final String? hdurl;
  final String mediaType;
  final String? copyright;

  const ApodEntity({
    required this.title,
    required this.explanation,
    this.url,
    required this.date,
    this.hdurl,
    required this.mediaType,
    this.copyright,
  });

  @override
  List<Object?> get props => [
    title,
    explanation,
    url,
    date,
    hdurl,
    mediaType,
    copyright,
  ];
}
