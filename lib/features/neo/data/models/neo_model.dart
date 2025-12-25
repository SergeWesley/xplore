import '../../domain/entities/neo_entity.dart';

/// Modèle de données pour un Near Earth Object
///
/// Le JSON de l'API est imbriqué, donc on utilise un fromJson manuel
/// qui extrait uniquement les données utiles.
class NeoModel extends NeoEntity {
  const NeoModel({
    required super.id,
    required super.name,
    required super.nasaJplUrl,
    required super.diameterMinMeters,
    required super.diameterMaxMeters,
    required super.closeApproachDate,
    required super.velocityKmPerSecond,
    required super.missDistanceKm,
    required super.missDistanceLunar,
    required super.isPotentiallyHazardous,
  });

  /// Factory pour créer un NeoModel depuis le JSON de l'API
  factory NeoModel.fromJson(Map<String, dynamic> json) {
    // Extraire le diamètre en mètres
    final diameter = json['estimated_diameter']?['meters'] ?? {};
    final diameterMin =
        (diameter['estimated_diameter_min'] as num?)?.toDouble() ?? 0.0;
    final diameterMax =
        (diameter['estimated_diameter_max'] as num?)?.toDouble() ?? 0.0;

    // Extraire les données d'approche (premier élément de la liste)
    final approachList = json['close_approach_data'] as List<dynamic>? ?? [];
    final approach = approachList.isNotEmpty
        ? approachList.first as Map<String, dynamic>
        : <String, dynamic>{};

    final velocity = approach['relative_velocity'] ?? {};
    final distance = approach['miss_distance'] ?? {};

    return NeoModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Inconnu',
      nasaJplUrl: json['nasa_jpl_url'] as String? ?? '',
      diameterMinMeters: diameterMin,
      diameterMaxMeters: diameterMax,
      closeApproachDate: approach['close_approach_date'] as String? ?? '',
      velocityKmPerSecond:
          double.tryParse(
            velocity['kilometers_per_second'] as String? ?? '0',
          ) ??
          0.0,
      missDistanceKm:
          double.tryParse(distance['kilometers'] as String? ?? '0') ?? 0.0,
      missDistanceLunar:
          double.tryParse(distance['lunar'] as String? ?? '0') ?? 0.0,
      isPotentiallyHazardous:
          json['is_potentially_hazardous_asteroid'] as bool? ?? false,
    );
  }
}

/// Modèle pour la réponse complète du feed NEO
class NeoFeedModel extends NeoFeedEntity {
  const NeoFeedModel({
    required super.elementCount,
    required super.nearEarthObjects,
  });

  /// Factory pour créer un NeoFeedModel depuis le JSON de l'API
  factory NeoFeedModel.fromJson(Map<String, dynamic> json) {
    final elementCount = json['element_count'] as int? ?? 0;
    final nearEarthObjectsJson =
        json['near_earth_objects'] as Map<String, dynamic>? ?? {};

    final nearEarthObjects = <String, List<NeoEntity>>{};
    nearEarthObjectsJson.forEach((date, neoList) {
      nearEarthObjects[date] = (neoList as List<dynamic>)
          .map((neo) => NeoModel.fromJson(neo as Map<String, dynamic>))
          .toList();
    });

    return NeoFeedModel(
      elementCount: elementCount,
      nearEarthObjects: nearEarthObjects,
    );
  }
}
