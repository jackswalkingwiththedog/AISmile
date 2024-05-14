
import 'package:equatable/equatable.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';

enum WearingStatus { initial, submitting, loading, success, error }

final class WearingState extends Equatable {
  final List<String> images;
  final List<FileData> files;
  final String note;
  final WearingStatus status;

  factory WearingState.initial() {
    return const WearingState(
      note: '',
      images: [],
      files: [],
      status: WearingStatus.initial,
    );
  }

  WearingState copyWith({
    String? note,
    WearingStatus? status,
  }) {
    return WearingState(
      files: files,
      images: images,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  WearingState clear() {
    return const WearingState(
      files: [],
      images: [],
      note: '',
      status: WearingStatus.initial,
    );
  }

  WearingState addFile({required FileData file}) {
    return WearingState(
      images: images,
      files: [...files, file],
      note: note,
      status: status,
    );
  }

  WearingState addFiles({required List<FileData> listFiles}) {
    return WearingState(
      images: images,
      files: [...files, ...listFiles],
      note: note,
      status: status,
    );
  }

  WearingState addImage({required String image}) {
    final nImages = [...images, image];
    print("leng${nImages.length}");

    return WearingState(
      images: nImages,
      files: files,
      note: note,
      status: status,
    );
  }

  WearingState addImages({required List<String> images}) {
    return WearingState(
      images: images,
      files: files,
      note: note,
      status: status,
    );
  }

  const WearingState({
    required this.files,
    required this.images,
    required this.note,
    required this.status,
  });

  @override
  List<Object> get props => [
        files,
        images,
        note,
        status,
      ];
}
