import 'package:equatable/equatable.dart';
import '../../domain/entities/apod_entity.dart';

sealed class ApodState extends Equatable {
  const ApodState();

  @override
  List<Object?> get props => [];
}

class ApodInitial extends ApodState {
  const ApodInitial();
}

class ApodLoading extends ApodState {
  const ApodLoading();
}

class ApodLoaded extends ApodState {
  final ApodEntity apod;

  const ApodLoaded(this.apod);

  @override
  List<Object?> get props => [apod];
}

class ApodListLoaded extends ApodState {
  final List<ApodEntity> apodList;

  const ApodListLoaded(this.apodList);

  @override
  List<Object?> get props => [apodList];
}

class ApodError extends ApodState {
  final String message;

  const ApodError(this.message);

  @override
  List<Object?> get props => [message];
}
