import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capy_car/domain/models/usuario/usuario.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<User?> registerWithEmailAndPassword(
      String email,
      String password,
      Map<String, dynamic> usuarioExtraInfo,
      ) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      // Salva informações no Firestore
      await _firestore.collection('usuarios').doc(user.uid).set(usuarioExtraInfo);

      // Envia e-mail de verificação
      await user.sendEmailVerification();
    }

    return user;
  }


  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<Usuario?> getUsuarioData(String uid) async {
      final doc = await _firestore.collection('usuarios').doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      final json = {
        ...data,
        'uId': uid,
        'nome': data['nomeCompleto'] ?? '',
        'isAtivo': data['isAtivo'] ?? true,
      };

      return Usuario.fromJson(json);
  }




  Future<void> updateUsuario(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('usuarios').doc(uid).update(data);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw FirebaseAuthException(
        code: 'user-not-authenticated',
        message: 'Usuário não autenticado',
      );
    }

    // Reautentica o usuário
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);

    // Altera a senha
    await user.updatePassword(newPassword);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      // Aqui você pode tratar erros específicos se quiser
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Erro ao enviar e-mail de redefinição de senha.',
      );
    }
  }

  Future<void> deleteAccount({required String currentPassword}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null || user.email == null) {
        throw FirebaseAuthException(
          code: 'user-not-authenticated',
          message: 'Nenhum usuário logado para excluir.',
        );
      }

      // 1. Reautenticar o usuário para confirmar a identidade
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);


      await user.delete();

    } on FirebaseAuthException catch (e) {
      // Trata erros comuns como senha incorreta ('wrong-password')
      // ou se a ação requer um login recente ('requires-recent-login').
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Ocorreu um erro ao excluir a conta.',
      );
    }
  }


}
