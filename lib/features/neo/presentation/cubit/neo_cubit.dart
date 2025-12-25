import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_neo_feed.dart';
import 'neo_state.dart';

/// Cubit pour gérer l'état des Near Earth Objects
class NeoCubit extends Cubit<NeoState> {
  final GetNeoFeed getNeoFeed;

  NeoCubit({required this.getNeoFeed}) : super(const NeoInitial());

  /// Récupère les NEOs pour une plage de dates spécifique
  Future<void> fetchNeoFeed({
    required String startDate,
    required String endDate,
  }) async {
    emit(const NeoLoading());

    final result = await getNeoFeed(startDate: startDate, endDate: endDate);

    result.fold(
      (failure) => emit(NeoError(failure.message)),
      (feed) =>
          emit(NeoLoaded(feed: feed, startDate: startDate, endDate: endDate)),
    );
  }

  /// Récupère les NEOs des 7 derniers jours
  Future<void> fetchLastWeekNeos() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    await fetchNeoFeed(
      startDate: _formatDate(weekAgo),
      endDate: _formatDate(now),
    );
  }

  /// Récupère les NEOs pour aujourd'hui uniquement
  Future<void> fetchTodayNeos() async {
    final now = DateTime.now();

    await fetchNeoFeed(startDate: _formatDate(now), endDate: _formatDate(now));
  }

  /// Formate une date au format YYYY-MM-DD attendu par l'API
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
