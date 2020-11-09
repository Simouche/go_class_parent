part of 'canteen_bloc.dart';

abstract class CanteenState extends Equatable {
  const CanteenState();
}

class CanteenLoadingState extends CanteenState {
  @override
  List<Object> get props => [];
}

class CanteenLoadedState extends CanteenState {
  final List<Canteen> canteens;

  CanteenLoadedState({this.canteens});

  @override
  List<Object> get props => [canteens];
}

class CanteenLoadingFailedState extends CanteenState {
  @override
  List<Object> get props => [];
}
