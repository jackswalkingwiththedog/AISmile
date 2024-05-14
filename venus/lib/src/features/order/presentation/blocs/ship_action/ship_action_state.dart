import 'package:equatable/equatable.dart';

enum ShipActionStatus { initial, submitting, success, error }

final class ShipActionState extends Equatable {
  final String tracking;
  final String shipStatus;
  final String note;
  final ShipActionStatus status;

  factory ShipActionState.initial() {
    return const ShipActionState(
      tracking: '',
      shipStatus: '',
      note: "",
      status: ShipActionStatus.initial,
    );
  }

  ShipActionState copyWith({
    String? tracking,
    String? shipStatus,
    String? note,
    ShipActionStatus? status,
  }) {
    return ShipActionState(
      tracking: tracking ?? this.tracking,
      shipStatus: shipStatus ?? this.shipStatus,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }

  const ShipActionState({
    required this.tracking,
    required this.shipStatus,
    required this.status,
    required this.note,
  });

  @override
  List<Object> get props => [
        shipStatus,
        status,
        note,
        tracking,
      ];
}
