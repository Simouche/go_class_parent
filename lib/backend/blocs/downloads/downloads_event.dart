part of 'downloads_bloc.dart';

@immutable
abstract class DownloadsEvent extends Equatable {}

class TriggerDownloadsEvent extends DownloadsEvent {
  final List<dynamic> files;

  TriggerDownloadsEvent({this.files});

  @override
  List<Object> get props => [files];
}

class OpenDownloadsEvent extends DownloadsEvent {
  @override
  List<Object> get props => [];
}
