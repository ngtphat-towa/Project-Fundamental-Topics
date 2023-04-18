import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/authentication_repository.dart';
import 'package:grocery_pos/presentation/app/bloc/app_bloc.dart';
import 'package:grocery_pos/presentation/authentication/login/views/login_page.dart';
import 'package:grocery_pos/presentation/home/views/views.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  const App(
      {Key? key, required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const MaterialApp(
          home: AuthenticationWrapper(),
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (_, state) {
        final authenticationRepository =
            context.read<AuthenticationRepository>();
        switch (state.status) {
          case AppStatus.authenticated:
            debugPrint(state.user.uid);
            return HomePage(
              authenticationRepository: authenticationRepository,
            );

          case AppStatus.unauthenticated:
            return const LogInPage();
        }
      },
    );
  }
}
