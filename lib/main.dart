import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_application_1/presentation/auth/pages/forgot_password_page.dart';
import 'package:flutter_application_1/presentation/auth/pages/login_page.dart';
import 'package:flutter_application_1/presentation/auth/pages/register_page.dart';
import 'package:flutter_application_1/presentation/home/pages/home_page.dart';
import 'package:flutter_application_1/presentation/profile/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ykliuppxcrlhvjvynjzf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlrbGl1cHB4Y3JsaHZqdnluanpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE5MTgwMzcsImV4cCI6MjA4NzQ5NDAzN30.3jNNWW8-3G0dl7f8222jqqef-7QXUk-wdWldqhMWegM',
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ProfileCubit(Supabase.instance.client)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GrowPlan',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LogIn(),
        '/regis': (context) => const SignUp(),
        '/home': (context) => const HomePage(),
        '/forgot': (context) => const ForgotPasswordPage(),
      },
    );
  }
}
