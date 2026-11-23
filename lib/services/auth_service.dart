import '../models/user_account.dart';
import 'api_service.dart';

class AuthService {
  static UserAccount? _currentUser;

  static UserAccount? get currentUser => _currentUser;

  static bool get isAuthenticated => _currentUser != null;

  // Connexion : POST /accounts/login
  static Future<UserAccount> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      'accounts/login',
      {
        'email': email.trim(),
        'password': password,
      },
    );

    if (response['data'] != null && response['data'] is Map<String, dynamic>) {
      final user = UserAccount.fromJson(response['data'] as Map<String, dynamic>);
      _currentUser = user;
      return user;
    } else {
      throw ApiException('Réponse inattendue lors de la connexion.');
    }
  }

  // Inscription : POST /accounts/register
  static Future<UserAccount> register({
    required String email,
    required String password,
  }) async {
    final response = await ApiService.post(
      'accounts/register',
      {
        'email': email.trim(),
        'password': password,
      },
    );

    if (response['data'] != null && response['data'] is Map<String, dynamic>) {
      final user = UserAccount.fromJson(response['data'] as Map<String, dynamic>);
      _currentUser = user;
      return user;
    } else {
      throw ApiException('Réponse inattendue lors de l’inscription.');
    }
  }

  // Déconnexion
  static void logout() {
    _currentUser = null;
  }
}
