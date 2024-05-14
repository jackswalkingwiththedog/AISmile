import 'package:localstorage/localstorage.dart';

class LocalStorageRepository {
  final LocalStorage storage;

  LocalStorageRepository()
      : storage = LocalStorage('my_local_storage');

  Future<String?> get(String key) async {
    return await storage.getItem(key);
  }

  Future<void> set(String key, String value) async {
    await storage.setItem(key, value);
  }

  Future<void> delete(String key) async {
    await storage.deleteItem(key);
  }
}