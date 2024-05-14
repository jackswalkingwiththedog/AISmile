
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';
import 'package:venus/src/features/client/presentation/blocs/wearing/wearing_state.dart';
import 'package:venus/src/services/firestore/entities/wearing.dart';
import 'package:venus/src/services/firestore/repository/wearing_repository.dart';
import 'package:venus/src/utils/uuid.dart';

class WearingCubit extends Cubit<WearingState> {
  WearingCubit() : super(WearingState.initial());

  bool isAcceptCreate() {
    if (state.files.isNotEmpty) {
      return true;
    }
    return false;
  }

  void onSubmit() {
    emit(state.copyWith(status: WearingStatus.loading));
  }

  void onSuccess() {
    emit(state.copyWith(status: WearingStatus.success));
  }

  void addFiles({required List<FileData> files}) {
    emit(state.addFiles(listFiles: files));
  }

  void addFile({required FileData file}) {
    emit(state.addFile(file: file));
  }

  void addImage({required String image}) {
    emit(state.addImage(image: image));
  }

  void addImages({required List<String> images}) {
    emit(state.addImages(images: images));
  }

  void noteChanged(String value) {
    emit(state.copyWith(note: value, status: WearingStatus.initial));
  }

  void clearState() {
    emit(state.clear());
  }

  Future<void> createWearing({required String uid}) async {
    if (state.status == WearingStatus.submitting) {
      return;
    }
    emit(state.copyWith(status: WearingStatus.submitting));

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);
      
      await WearingRepository().createWearing(Wearing(
        id: generateID(),
        createTime: formattedDate,
        customerId: uid,
        images: state.images,
        note: state.note,
      ));

      emit(state.copyWith(status: WearingStatus.success));
    } catch(_){}
  }

  Future<void> createWearinDebug({required String uid, required List<String> images}) async {
    if (state.status == WearingStatus.submitting) {
      return;
    }

    emit(state.copyWith(status: WearingStatus.submitting));

    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(now);

      print("load");
      
      await WearingRepository().createWearing(Wearing(
        id: generateID(),
        createTime: formattedDate,
        customerId: uid,
        images: images,
        note: state.note,
      ));

      print("end load");

      emit(state.copyWith(status: WearingStatus.success));
    } catch(err){
      print(err);
    }
  }
}
