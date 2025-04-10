import 'package:flutter/foundation.dart';
import 'package:to_do/data/models/user_model.dart';
import 'package:to_do/data/repositories/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository;
  UserModel? _user;
  bool _isLoading = true;

  AuthViewModel(this._repository);

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _user = await _repository.getCurrentUser();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      _user = await _repository.signInWithEmailAndPassword(email, password);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      _user = await _repository.registerWithEmailAndPassword(email, password, name);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _user = null;
    notifyListeners();
  }
}
