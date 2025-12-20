import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_apod.dart';
import '../../domain/usecases/get_apod_range.dart';
import 'apod_state.dart';

class ApodCubit extends Cubit<ApodState> {
  final GetApod getApod;
  final GetApodRange getApodRange;

  ApodCubit({required this.getApod, required this.getApodRange})
    : super(const ApodInitial());

  Future<void> fetchApod({String? date}) async {
    emit(const ApodLoading());

    final result = await getApod(date: date);

    result.fold(
      (failure) => emit(ApodError(failure.message)),
      (apod) => emit(ApodLoaded(apod)),
    );
  }

  Future<void> fetchTodayApod() async {
    await fetchApod();
  }

  Future<void> fetchApodList({
    required String startDate,
    required String endDate,
  }) async {
    emit(const ApodLoading());

    final result = await getApodRange(startDate: startDate, endDate: endDate);

    result.fold((failure) => emit(ApodError(failure.message)), (apodList) {
      final imagesOnly = apodList
          .where((apod) => apod.mediaType == 'image')
          .toList();
      emit(ApodListLoaded(imagesOnly));
    });
  }

  Future<void> fetchLastWeekApods() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    await fetchApodList(
      startDate: _formatDate(weekAgo),
      endDate: _formatDate(now),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
