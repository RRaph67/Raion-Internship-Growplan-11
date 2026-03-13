// File: lib/presentation/user_tanam/pages/add_user_tanam_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/plant_info/cubit/repo_tanam_cubit.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/user_tanam_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddUserTanamPage extends StatelessWidget {
  const AddUserTanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Tambah Tanaman"),
      body: MultiBlocProvider(
        providers: [
          // ✅ Hapus UserTanamCubit BlocProvider (sudah ada di main.dart)
          // ✅ Tambahkan SupabaseClient ke RepoTanamanCubit
          BlocProvider(
            create: (_) =>
                RepoTanamanCubit(Supabase.instance.client)..fetchJenisTanaman(),
          ),
        ],
        child: const UserTanamForm(),
      ),
    );
  }
}
