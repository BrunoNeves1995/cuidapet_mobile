import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SheredPreferencesLocalStorageImpl implements LocalStorage {
  Future<SharedPreferences> get _intance => SharedPreferences.getInstance();

  @override
  Future<void> clear() async {
    final sharedPreferences = await _intance;
    sharedPreferences.clear();
  }

  @override
  Future<bool> contains(String key) async {
    final sharedPreferences = await _intance;
    return sharedPreferences.containsKey(key);
  }

  @override
  Future<V?> read<V>(String key) async {
    final sharedPreferences = await _intance;
    return sharedPreferences.get(key) as V?;
  }

  @override
  Future<void> remove(String key) async {
    final sharedPreferences = await _intance;
    sharedPreferences.remove(key);
  }

  @override
  Future<void> write<V>(String key, V value) async {
    final sharedPreferences = await _intance;
   
    //! fazemos um switch do tipo V que veio e salvamos como o seu tipo que veio
    switch (V) {
      case String:
        await sharedPreferences.setString(key, value as String);
        break;

      case int:
        await sharedPreferences.setInt(key, value as int);
        break;

      case bool:
        await sharedPreferences.setBool(key, value as bool);
        break;

      case double:
        await sharedPreferences.setDouble(key, value as double);
        break;

      case List<String>:
        await sharedPreferences.setStringList(key, value as List<String>);
        break;

      default:
        throw Exception('Type not suported'); // tipo nao supotado

    }
  }
}
