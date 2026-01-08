import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/firebase_options.dart';
import 'package:flutter_ecommerce_app/utils/app_router.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/category_cubit/category_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/favorite_cubit/favorite_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/home_cubit/home_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await initializeApp();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const CommerceApp(),
    ),
  );
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  handleNotifications();
}

Future<void> handleNotifications() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint('User granted permission: ${settings.authorizationStatus}');
}

class CommerceApp extends StatelessWidget {
  const CommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => HomeCubit()..getHomeData()),
            BlocProvider(create: (context) => AuthCubit()..checkAuth()),
            BlocProvider(create: (context) => CategoryCubit()..getCategory()),
            BlocProvider(create: (context) => FavoriteCubit()..getFavorites()),
          ],
          child: Builder(
            builder: (context) {
              return BlocBuilder<AuthCubit, AuthState>(
                bloc: BlocProvider.of<AuthCubit>(context),
                builder: (context, state) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: DevicePreview.locale(context),
                    builder: DevicePreview.appBuilder,
                    darkTheme: ThemeData.dark(),
                    title: 'E-Commerce App',
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: Colors.deepPurple,
                      ),
                      useMaterial3: true,
                      scaffoldBackgroundColor: Colors.grey[50],
                    ),
                    initialRoute: state is AuthSuccess
                        ? AppRoutes.homeRoute
                        : AppRoutes.loginRoute,
                    onGenerateRoute: AppRouter.onGeneratedRoute,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
