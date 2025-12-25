import 'package:equatable/equatable.dart';
import '../../domain/entities/neo_entity.dart';

/// États du Cubit NEO
sealed class NeoState extends Equatable {
  const NeoState();

  @override
  List<Object?> get props => [];
}

/// État initial
class NeoInitial extends NeoState {
  const NeoInitial();
}

/// État de chargement
class NeoLoading extends NeoState {
  const NeoLoading();
}

/// État chargé avec les données du feed
class NeoLoaded extends NeoState {
  final NeoFeedEntity feed;
  final String startDate;
  final String endDate;

  const NeoLoaded({
    required this.feed,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [feed, startDate, endDate];
}

/// État d'erreur
class NeoError extends NeoState {
  final String message;

  const NeoError(this.message);

  @override
  List<Object?> get props => [message];
}
