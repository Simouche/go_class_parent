part of 'homework_bloc.dart';

abstract class HomeWorkState extends Equatable {
  const HomeWorkState();
}

class HomeworkInitial extends HomeWorkState {
  @override
  List<Object> get props => [];
}

class HomeWorkLoadingState extends HomeWorkState {
  @override
  List<Object> get props => [];
}

class HomeWorkLoadedSuccessState extends HomeWorkState {
  final List<ClassWithHomeWorks> homeWorks;

  const HomeWorkLoadedSuccessState({this.homeWorks});

  @override
  List<Object> get props => [homeWorks];
}

class HomeWorkLoadedFailedState extends HomeWorkState {
  @override
  List<Object> get props => [];
}
