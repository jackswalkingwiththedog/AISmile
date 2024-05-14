import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/employee/presentation/blocs/detail/detail_state.dart';

class DetailEmployeeCubit extends Cubit<DetailEmployeeState> {
  DetailEmployeeCubit() : super(DetailEmployeeState.initial());
}
