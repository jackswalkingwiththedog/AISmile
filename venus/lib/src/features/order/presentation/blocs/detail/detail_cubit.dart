import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus/src/features/order/presentation/blocs/detail/detail_state.dart';

class DetailOrderCubit extends Cubit<DetailOrderState> {
  DetailOrderCubit() : super(DetailOrderState.initial());
}
