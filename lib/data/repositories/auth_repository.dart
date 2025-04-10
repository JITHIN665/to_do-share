import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/data/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(id: user.uid, email: user.email ?? '', name: user.displayName ?? user.email!.split('@')[0]);
    }
    return null;
  }

  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return UserModel(id: credential.user!.uid, email: credential.user!.email ?? '', name: credential.user!.displayName ?? email.split('@')[0]);
  }

  Future<UserModel> registerWithEmailAndPassword(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user!.updateDisplayName(name);
    return UserModel(id: credential.user!.uid, email: credential.user!.email ?? '', name: name);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
