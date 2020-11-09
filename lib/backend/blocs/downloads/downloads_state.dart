part of 'downloads_bloc.dart';

@immutable
abstract class DownloadsState extends Equatable {}

class DownloadsInitial extends DownloadsState {
  @override
  List<Object> get props => [];
}

class DownloadsInProgressState extends DownloadsState {
  @override
  List<Object> get props => [];
}

class DownloadsSuccessfulState extends DownloadsState {
  @override
  List<Object> get props => [];
}
class DownloadsFailedState extends DownloadsState {
  @override
  List<Object> get props => [];
}

class DownloadsPageOpenState extends DownloadsState {
  final List<AttachmentFile> files;

  DownloadsPageOpenState({this.files});

  @override
  List<Object> get props => [files];
}
