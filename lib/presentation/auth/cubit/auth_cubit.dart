import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final supabase.SupabaseClient _client = supabase.Supabase.instance.client;

  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  AuthCubit() : super(AuthInitial()) {
    _authStateSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final event = data.event;

      if (event == supabase.AuthChangeEvent.passwordRecovery) {
        emit(PasswordRecovery());
        return;
      }

      if (session != null) {
        emit(
          AuthSuccess(
            UserModel(
              nama: session.user.userMetadata?['name'] ?? '',
              fotoProfil: session.user.userMetadata?['avatar_url'] ?? '',
              email: session.user.email ?? '',
            ),
          ),
        );
      } else {
        emit(AuthInitial());
      }
    });
  }

  @override
  Future<void> close() async {
    await _authStateSubscription?.cancel();
    return super.close();
  }

  // REGISTER
  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'avatar_url': null},
        emailRedirectTo: 'io.supabase.growplan://auth-callback',
      );

      if (response.user != null) {
        emit(AuthEmailSent());
      } else {
        emit(AuthFailure("Akun dibuat, tapi email verifikasi gagal dikirim."));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // LOGIN
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _client.auth.signOut();
  }

   Future<void> sendEmailForgotPassword(String email) async {
    emit(AuthLoading());

    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.malangventure://auth-callback',
      );
      emit(SendEmailForgotPassword());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    emit(AuthLoading());
    try {
      await _client.auth.updateUser(UserAttributes(password: newPassword));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
