import 'package:equatable/equatable.dart';

class AlignerOrder extends Equatable {
  const AlignerOrder(
      {required this.id,
      required this.customerId,
      this.designerId,
      this.printerId,
      this.reviewerId,
      this.shipperId,
      this.createAt,
      this.imagesScan,
      this.description,
      this.fileDesign,
      this.linkDesign,
      this.printFrequency,
      this.totalCase,
      this.status,
      this.caseInWeek,
      this.passCode,
      this.addressReceive,
      this.casePrinted,
      this.userReceive,
      this.timeStart,
      this.userSend,
      this.tracking,
      this.images,
    });

  final String id;
  final String customerId;
  final String? designerId;
  final String? printerId;
  final String? reviewerId;
  final String? shipperId;
  final String? createAt;
  final String? imagesScan;
  final String? description;
  final String? fileDesign;
  final String? linkDesign;
  final int? printFrequency;

  // For Shipper
  final String? userSend;
  final String? userReceive;
  final String? addressReceive;
  final String? tracking;
  final List<String>? images;

  // For Designer
  final String? passCode;
  final int? totalCase;
  final int? caseInWeek;
  // Printer
  final int? casePrinted;
  // Wearing
  final String? timeStart;

  final String? status;

  static const empty = AlignerOrder(id: '', customerId: '');
  bool get isEmpty => this == AlignerOrder.empty;
  bool get isNotEmpty => this != AlignerOrder.empty;

  @override
  List<Object?> get props => [
        id,
        customerId,
        designerId,
        printerId,
        reviewerId,
        totalCase,
        shipperId,
        createAt,
        imagesScan,
        description,
        fileDesign,
        linkDesign,
        printFrequency,
        totalCase,
        caseInWeek,
        passCode,
        addressReceive,
        casePrinted,
        userReceive,
        userSend,
        timeStart,
        tracking,
        status,
        images,
      ];
}
