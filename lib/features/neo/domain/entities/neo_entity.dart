import 'package:equatable/equatable.dart';

/// Entité représentant un objet proche de la Terre (Near Earth Object)
class NeoEntity extends Equatable {
  /// Identifiant unique
  final String id;

  /// Nom de l'astéroïde
  final String name;

  /// URL vers la page NASA JPL
  final String nasaJplUrl;

  /// Diamètre estimé minimum en mètres
  final double diameterMinMeters;

  /// Diamètre estimé maximum en mètres
  final double diameterMaxMeters;

  /// Date d'approche au format YYYY-MM-DD
  final String closeApproachDate;

  /// Vitesse relative en km/s
  final double velocityKmPerSecond;

  /// Distance minimale en kilomètres
  final double missDistanceKm;

  /// Distance minimale en distance lunaire (plus parlant)
  final double missDistanceLunar;

  /// Indique si l'astéroïde est potentiellement dangereux
  final bool isPotentiallyHazardous;

  const NeoEntity({
    required this.id,
    required this.name,
    required this.nasaJplUrl,
    required this.diameterMinMeters,
    required this.diameterMaxMeters,
    required this.closeApproachDate,
    required this.velocityKmPerSecond,
    required this.missDistanceKm,
    required this.missDistanceLunar,
    required this.isPotentiallyHazardous,
  });

  /// Diamètre moyen estimé en mètres
  double get averageDiameterMeters =>
      (diameterMinMeters + diameterMaxMeters) / 2;

  /// Vitesse en km/h (plus parlant)
  double get velocityKmPerHour => velocityKmPerSecond * 3600;

  @override
  List<Object?> get props => [
    id,
    name,
    nasaJplUrl,
    diameterMinMeters,
    diameterMaxMeters,
    closeApproachDate,
    velocityKmPerSecond,
    missDistanceKm,
    missDistanceLunar,
    isPotentiallyHazardous,
  ];
}

/// Entité représentant la réponse du feed NEO
class NeoFeedEntity extends Equatable {
  /// Nombre total d'éléments
  final int elementCount;

  /// Liste des NEOs par date
  final Map<String, List<NeoEntity>> nearEarthObjects;

  const NeoFeedEntity({
    required this.elementCount,
    required this.nearEarthObjects,
  });

  /// Récupère tous les NEOs en une seule liste
  List<NeoEntity> get allNeos =>
      nearEarthObjects.values.expand((list) => list).toList();

  /// Récupère les NEOs potentiellement dangereux
  List<NeoEntity> get hazardousNeos =>
      allNeos.where((neo) => neo.isPotentiallyHazardous).toList();

  @override
  List<Object?> get props => [elementCount, nearEarthObjects];
}
