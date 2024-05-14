import 'package:bloc/bloc.dart';
import 'package:venus/src/features/branch/presentation/blocs/detail/detail_state.dart';

class DetailBranchCubit extends Cubit<DetailBranchState> {
  DetailBranchCubit() : super(DetailBranchState.initial());
}
