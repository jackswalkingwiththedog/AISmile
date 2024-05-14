import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/branch_employee/presentation/blocs/detail/detail_state.dart';

class DetailBranchEmployeeCubit extends Cubit<DetailBranchEmployeeState> {
  DetailBranchEmployeeCubit() : super(DetailBranchEmployeeState.initial());
}
