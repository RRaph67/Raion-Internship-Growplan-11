import 'package:flutter_application_1/data/models/repo_tanaman_model.dart';

abstract class RepoTanamanState {}

class RepoTanamanInitial extends RepoTanamanState {}

class RepoTanamanLoading extends RepoTanamanState {}

class RepoTanamanListLoaded extends RepoTanamanState {
  final List<RepoTanamanModel> list;
  RepoTanamanListLoaded(this.list);
}

class RepoTanamanDetailLoaded extends RepoTanamanState {
  final RepoTanamanModel detail;
  RepoTanamanDetailLoaded(this.detail);
}

class JenisTanamanLoaded extends RepoTanamanState {
  final List<String> jenisList;
  JenisTanamanLoaded(this.jenisList);
}

class RepoTanamanError extends RepoTanamanState {
  final String message;
  RepoTanamanError(this.message);
}
