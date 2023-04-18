import 'package:flutter/material.dart';
import 'package:grocery_pos/domain_data/authentications/repositories/repositories.dart';

class HomePage extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const HomePage({
    Key? key,
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(key: key);

  Future<void> _handleLogOut() async {
    await _authenticationRepository.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Sign successfully"),
            ElevatedButton(
              onPressed: _handleLogOut,
              child: const Text("Log out"),
            ),
            const SizedBox(height: 30),
          ]),
    );
  }
}
