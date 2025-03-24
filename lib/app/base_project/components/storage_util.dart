import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  final IStorage  _storage;
  final String _userId = "userId";
  final String _hasLogin = "hasLogin";
  final String _userToken = "token";
  final String _refreshToken = "refreshToken";
  final String _roleName = "roleName";
  final String _fcmToken = "fcmToken";
  final String _jwtToken = "jwtToken";
  final String _deviceId = "deviceId";

  StorageUtil(this._storage);

  Future<String?> getUserId() => _storage.read(key: _userId);

  setUserId(String userId)async => await _storage.write(key: _userId, value: userId);

  Future<bool?> hasLogin() => _storage.readBoolean(key: _hasLogin);

  setLogin(String loginState) => _storage.write(key: _hasLogin, value: loginState);

  Future<String?> getUserToken() => _storage.read(key: _userToken);

  setUserToken(String token)async => await _storage.write(key: _userToken, value: token);

  Future<String?> getFcmToken() => _storage.read(key: _fcmToken);

  setFcmToken(String fcmToken) async =>
      await _storage.write(key: _fcmToken, value: fcmToken);

  Future<String?> getJwtToken() => _storage.read(key: _jwtToken);

  setJwtToken(String jwtToken) async =>
      await _storage.write(key: _jwtToken, value: jwtToken);

  Future<String?> getDeviceId() => _storage.read(key: _deviceId);

  setDeviceId(String deviceId) async =>
      await _storage.write(key: _deviceId, value: deviceId);

  Future<String?> getRoleName() => _storage.read(key: _roleName);

  setRoleName(String token)async => await _storage.write(key: _roleName, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshToken);

  setRefreshToken(String refreshToken)async => await _storage.write(key: _refreshToken, value: refreshToken);


  Future<void> removeAll() => _storage.deleteAll();

  Future<void> logout() async {
    await removeAll();
  }

}

class SecureStorage implements IStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<bool> containKey({required String key}) {
    return _storage.containsKey(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() {
    return _storage.deleteAll();
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<bool?> readBoolean({required String key}) {
    return _storage.read(key: key).then((value) =>  value?.parseBool());
  }

  @override
  Future<double?> readDouble({required String key}) {
    return _storage.read(key: key).then((value) =>  double.parse(value ?? ""));
  }

  @override
  Future<int?> readInt({required String key}) {
    return _storage.read(key: key).then((value) =>  int.tryParse(value ?? ""));
  }

  @override
  Future<void> write({required String key, required String? value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<bool> has(String key) async {
    return await _storage.read(key: key) != null;
  }



}

abstract class IStorage {
  Future<String?> read({required String key});
  Future<int?> readInt({required String key});
  Future<double?> readDouble({required String key});
  Future<bool?> readBoolean({required String key});

  Future<void> write({
    required String key,
    required String? value,
  });

  Future<bool> containKey({
    required String key,
  });

  Future<void> delete({
    required String key,
  });

  Future<void> deleteAll();

  Future<bool> has(String key);
}

extension StringExt on String {
  String toRupiah({String separator='.', String trailing=''}) {
    return "Rp ${replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$separator')}$trailing";
  }
  bool parseBool() {
    return toLowerCase() == 'true';
  }

  String getInitials(String fullName) => fullName.isNotEmpty
      ? fullName
      .trim()
      .split(RegExp(' +'))
      .map((s) => s[0])
      .take(2)
      .join()
      : '';


  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}