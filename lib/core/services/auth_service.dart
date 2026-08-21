import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';
import '../utils/permission_helper.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  AccessLevel _accessLevel = AccessLevel.viewer;
  AccessLevel get accessLevel => _accessLevel;

  Future<AccessLevel> initialize() async {
    final stored = await _storage.read(key: "access_level");
    _accessLevel = stored == "executer" ? AccessLevel.executer : AccessLevel.viewer;
    return _accessLevel;
  }

  Future<bool> verifyPin(String pin) async {
    if (pin == AppConstants.executerPin) {
      _accessLevel = AccessLevel.executer;
      await _storage.write(key: "access_level", value: "executer");
      return true;
    }
    if (pin == AppConstants.viewerPin) {
      _accessLevel = AccessLevel.viewer;
      await _storage.write(key: "access_level", value: "viewer");
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: "access_level");
    _accessLevel = AccessLevel.viewer;
  }
}