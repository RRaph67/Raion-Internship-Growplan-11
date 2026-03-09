import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/user_tanam_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_tanam_cubit.dart';

class AddUserTanamPage extends StatelessWidget {
  const AddUserTanamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Tambah Tanaman"),
      body: BlocProvider(
        create: (_) => UserTanamCubit()..fetchJenisTanaman(),
        child: const UserTanamForm(),
      ),
    );
  }
}
