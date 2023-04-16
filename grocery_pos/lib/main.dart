import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'domain_data/authentications/repositories/authentication_repository.dart';

import 'common/config/firebase_options.dart';
import 'presentation/app/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final AuthenticationRepository repository = AuthenticationRepository();
  runApp(App(authenticationRepository: repository));
}
