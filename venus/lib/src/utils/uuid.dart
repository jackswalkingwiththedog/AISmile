import 'package:uuid/uuid.dart';

String generateID() {
  return const Uuid().v4();
}