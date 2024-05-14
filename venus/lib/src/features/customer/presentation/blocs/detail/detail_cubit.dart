import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/customer/presentation/blocs/detail/detail_state.dart';
import 'package:venus/src/services/firestore/entities/note.dart';
import 'package:venus/src/services/firestore/repository/note_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class DetailCustomerCubit extends Cubit<DetailCustomerState> {
  DetailCustomerCubit() : super(DetailCustomerState.initial());

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: DetailCustomerStatus.initial));
  }

  void openChanged(bool value) {
    emit(state.copyWith(open: value, status: DetailCustomerStatus.initial));
  }

  Future<void> createNoteSubmitting(
      {required String customerId, required String doctorId}) async {
    if (state.status == DetailCustomerStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: DetailCustomerStatus.submitting));

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      await NoteRepository().createNote(Note(
        id: generateID(),
        createAt: formattedDate,
        customerId: customerId,
        doctorId: doctorId,
        note: state.note
      ));
      emit(state.copyWith(status: DetailCustomerStatus.success));
    } catch (_) {}
  }
}
