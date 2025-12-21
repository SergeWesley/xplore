import 'package:isar/isar.dart';

part 'apod_entity.g.dart';

@collection
class ApodEntity {
  Id get isarId => fastHash(date);

  final String title;
  final String explanation;
  final String? url;
  @Index(unique: true)
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApodEntity &&
          runtimeType == other.runtimeType &&
          date == other.date;

  @override
  int get hashCode => date.hashCode;
}

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  for (var i = 0; i < string.length; i++) {
    final codeUnit = string.codeUnitAt(i);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }
  return hash;
}
