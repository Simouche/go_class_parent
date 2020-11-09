import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_class_parent/backend/models/attachement_file.dart';
import 'package:go_class_parent/backend/repositories/downloads_repository.dart';
import 'package:meta/meta.dart';

part 'downloads_event.dart';
part 'downloads_state.dart';

class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  DownloadsBloc({this.repository}) : super(DownloadsPageOpenState());

  final DownloadsRepository repository;

  @override
  Stream<DownloadsState> mapEventToState(
    DownloadsEvent event,
  ) async* {
    switch (event.runtimeType) {
      case TriggerDownloadsEvent:
        yield* mapTriggerDownloadEventToState(
            (event as TriggerDownloadsEvent).files);
        break;
      case OpenDownloadsEvent:
        yield* mapOpenDownloadsEventToState();
        break;
    }
  }

  Stream<DownloadsState> mapTriggerDownloadEventToState(
      List<dynamic> files) async* {
    yield DownloadsInProgressState();
    try {
      final bool result = await repository.downloadFiles(files);
      if (result) {
        yield DownloadsSuccessfulState();
      } else {
        yield DownloadsFailedState();
      }
    } catch (e) {
      print(e);
      yield DownloadsFailedState();
    }
  }

  Stream<DownloadsState> mapOpenDownloadsEventToState() async* {
    yield DownloadsPageOpenState(files: (await repository.loadFromDatabase()));
  }
}
