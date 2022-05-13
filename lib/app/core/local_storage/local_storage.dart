abstract class LocalStorage {
  //! v? -> é o tipo do nosso parametro que vamos ler
  Future<V?> read<V>(String key);
  Future<void> write<V>(String key, V value);
  Future<bool> contains(String key);
  Future<void> clear();
  Future<void> remove(String key);
}


abstract class LocalSecureStorage {
  Future<String?> read<V>(String key);
  Future<void> write<V>(String key, String value);
  Future<bool> contains(String key);
  Future<void> clear();
  Future<void> remove(String key);
}
