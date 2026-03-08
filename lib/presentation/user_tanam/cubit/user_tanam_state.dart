abstract class UserTanamState {}

class UserTanamInitial extends UserTanamState {}

class UserTanamLoading extends UserTanamState {}

class UserTanamSuccess extends UserTanamState {
  final int userTanamId;
  UserTanamSuccess(this.userTanamId);
}

class UserTanamError extends UserTanamState {
  final String message;
  UserTanamError(this.message);
}

class RepoTanamanLoading extends UserTanamState {}

class RepoTanamanLoaded extends UserTanamState {
  final List<dynamic> repoList;
  RepoTanamanLoaded(this.repoList);
}

class JenisTanamanLoaded extends UserTanamState {
  final List<String> jenisList;
  JenisTanamanLoaded(this.jenisList);
}

class UserTanamDetailLoaded extends UserTanamState {
  final Map<String, dynamic> detail;
  UserTanamDetailLoaded(this.detail);
}

class UserTanamListLoaded extends UserTanamState {
  final List<dynamic> userTanamList;
  UserTanamListLoaded(this.userTanamList);
}

