import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:medired/app_observer.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/core/database/firebase_options.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/router/router.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/constants/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; 

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform(dotenv),
  );
  //FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  HydratedBloc.storage = storage;

  await setupLocator();

  Flurorouter.configureRoutes();

  /*FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };*/

  /*PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };*/

  Bloc.observer = AppBlocObserver();
  if (kIsWeb) {
    // initialize the facebook javascript SDK
   await FacebookAuth.i.webAndDesktopInitialize(
      appId: "584858571103290",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(),
              sl(), sl(), sl(), sl(), sl(), sl(), sl(),sl())
            ..add(const InitializeAuth()),
        ),
        BlocProvider(
          create: (context) => MessageBloc(),
        ),
      ],
      child: const RoutePage(),
    );
  }
}

class myCustomScrollBahavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _authListener,
      listenWhen: (previous, current) =>
          (previous is LoadingAuthState && current is UnauthenticatedState) ||
          (previous is UnauthenticatedState && current is LoadingAuthState) ||
          (previous is LoadingAuthState && current is AuthenticatedState),
      child: MaterialApp.router(
        scrollBehavior: myCustomScrollBahavior(),
        debugShowCheckedModeBanner: false,
        title: 'Medired',
        routerConfig: router,
        theme: AppTheme().themeData,
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthenticatedState) {
      //router.go(RoutePath.profile);
    } else if (state is UnauthenticatedState) {
      router.go(RoutePath.login);
    }
  }
}
