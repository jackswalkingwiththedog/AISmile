import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:venus/src/app/app.dart';
import 'package:venus/src/app/bloc_observer.dart';
import 'firebase_options.dart';

import 'nonweb_url_strategy.dart' if (dart.library.html) 'web_url_strategy.dart';

void configureApp() {
  configureUrl();
  // setUrlStrategy(PathUrlStrategy());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  configureApp();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
