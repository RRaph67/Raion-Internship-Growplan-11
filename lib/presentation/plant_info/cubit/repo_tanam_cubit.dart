import 'package:flutter_application_1/presentation/plant_info/cubit/repo_tanam_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/data/models/repo_tanaman_model.dart';

class RepoTanamanCubit extends Cubit<RepoTanamanState> {
  RepoTanamanCubit(SupabaseClient client) : super(RepoTanamanInitial());

  final supabase = Supabase.instance.client;

  Future<void> fetchRepoTanamanList() async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select(
            'id, nama_statis, nama_ilmiah, jenis_tanaman, persiapan, perawatan, ringkasan',
          );

      final list = (response as List)
          .map((map) => RepoTanamanModel.fromMap(map))
          .toList();

      emit(RepoTanamanListLoaded(list));
    } catch (e) {
      emit(RepoTanamanError(e.toString()));
    }
  }

  Future<void> fetchRepoTanamanDetail(int repoId) async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select(
            'id, nama_statis, nama_ilmiah, jenis_tanaman, persiapan, perawatan, ringkasan',
          )
          .eq('id', repoId)
          .single();

      final detail = RepoTanamanModel.fromMap(response);
      emit(RepoTanamanDetailLoaded(detail));
    } catch (e) {
      emit(RepoTanamanError(e.toString()));
    }
  }

  Future<void> fetchJenisTanaman() async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select('jenis_tanaman')
          .order('jenis_tanaman', ascending: true);

      final allJenis = <String>{};
      for (var row in response) {
        final String? jenis = row['jenis_tanaman'];
        if (jenis != null && jenis.trim().isNotEmpty) {
          allJenis.add(jenis.trim());
        }
      }

      emit(JenisTanamanLoaded(allJenis.toList()));
    } catch (e) {
      emit(RepoTanamanError(e.toString()));
    }
  }
}
