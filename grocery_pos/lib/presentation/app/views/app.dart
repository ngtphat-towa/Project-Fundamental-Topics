import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_data/authentications/repositories/repositories.dart';
import '../../authentication/login/views/views.dart';
import '../../home/views/views.dart';
import '../bloc/app_bloc.dart';

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
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            // textTheme: AppThemes.textTheme,
            // appBarTheme: AppBarTheme(
            //   elevation: 0,
            //   centerTitle: true,
            //   titleTextStyle: AppThemes.textTheme.headlineSmall,
            //   foregroundColor: AppColors.contextColor,
            // ),
            // buttonTheme: ButtonThemeData(
            //   colorScheme: AppThemes.colorScheme,
            //   textTheme: ButtonTextTheme.accent,
            // ),
          ),
          home: const AuthenticationWrapper(),
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
        switch (state.status) {
          case AppStatus.authenticated:
            debugPrint(state.user.uid);
            return const HomePage();

          case AppStatus.unauthenticated:
            return const LogInPage();
        }
      },
    );
  }
}
