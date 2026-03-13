// File: lib/data/state/user_tanam_state.dart
import 'package:flutter_application_1/data/models/user_tanam_model.dart';

abstract class UserTanamState {}

class UserTanamInitial extends UserTanamState {}

class UserTanamLoading extends UserTanamState {}

// State untuk List Tanaman (untuk HomePage)
class UserTanamListLoaded extends UserTanamState {
  final List<UserTanamModel> list;

  UserTanamListLoaded(this.list);
}

// State untuk Detail Tanaman (untuk Detail Page)
class UserTanamLoaded extends UserTanamState {
  final UserTanamModel userTanam;
  final int daysSincePlanted;

  UserTanamLoaded(this.userTanam, this.daysSincePlanted);
}

class UserTanamSuccess extends UserTanamState {
  final int userTanamId;
  UserTanamSuccess(this.userTanamId);
}

class UserTanamError extends UserTanamState {
  final String message;
  UserTanamError(this.message);
}
