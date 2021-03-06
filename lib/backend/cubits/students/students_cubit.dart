import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<int> {
  StudentsCubit(int initial) : super(initial);

  void selectStudent(int index) => emit(index);

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }

}
