import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/authentication_repository.dart';
import 'package:grocery_pos/presentation/authentication/login/cubit/login_cubit.dart';

import 'login_form.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LogInPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
