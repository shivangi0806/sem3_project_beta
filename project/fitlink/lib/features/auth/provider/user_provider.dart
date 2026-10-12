import 'package:fitlink/core/model/user.dart';
import 'package:flutter/foundation.dart';

/// Holds the signed-in user and JWT tokens for the current app session.
class UserProvider extends ChangeNotifier {
  User? _user;
  String _userToken = '';
  String _refreshToken = '';

  User? get user => _user;
  String get userToken => _userToken;
  String get refreshToken => _refreshToken;
  bool get isAuthenticated => _user != null && _userToken.isNotEmpty;

  /// Stores the user and both tokens returned by the login API.
  void setSession(UserSession session) {
    _user = session.user;
    _userToken = session.accessToken;
    _refreshToken = session.refreshToken;
    notifyListeners();
  }

  /// Updates the user profile while retaining the current authentication.
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Updates the access token, for example after refreshing the JWT.
  void setUserToken(String token) {
    if (_userToken == token) return;
    _userToken = token;
    notifyListeners();
  }

  /// Updates the refresh token after a refresh-token response.
  void setRefreshToken(String token) {
    if (_refreshToken == token) return;
    _refreshToken = token;
    notifyListeners();
  }

  /// Clears the signed-in user and tokens on logout.
  void clearSession() {
    if (_user == null && _userToken.isEmpty && _refreshToken.isEmpty) return;
    _user = null;
    _userToken = '';
    _refreshToken = '';
    notifyListeners();
  }
}
