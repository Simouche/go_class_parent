import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'matiere_state.dart';

class MatiereCubit extends Cubit<int> {
  MatiereCubit(int initial) : super(initial);

  void selectMatiere(int index) => emit(index);

  @override
  void onChange(Change<int> change) {
    print(change);
    super.onChange(change);
  }

}
