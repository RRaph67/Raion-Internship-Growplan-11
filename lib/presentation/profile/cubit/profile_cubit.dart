import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfilePhotoUpdated extends ProfileState {
  final String photoUrl;
  ProfilePhotoUpdated(this.photoUrl);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final SupabaseClient supabase;

  ProfileCubit(this.supabase) : super(ProfileInitial());

  Future<void> updateProfilePhoto({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 75);

      if (picked == null) return;

      emit(ProfileLoading());

      final userId = supabase.auth.currentUser!.id;
      final file = File(picked.path);
      final ext = picked.path.split('.').last;
      final filePath = '$userId/avatar.$ext';

      await supabase.storage
          .from('avatar')
          .upload(filePath, file, fileOptions: const FileOptions(upsert: true));

      final publicUrl = supabase.storage.from('avatar').getPublicUrl(filePath);

      await supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': publicUrl}),
      );

      await supabase.auth.refreshSession();

      emit(ProfilePhotoUpdated(publicUrl));
    } catch (err) {
      emit(ProfileError(err.toString()));
    }
  }
}
