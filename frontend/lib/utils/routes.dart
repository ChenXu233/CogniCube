import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// View Models
import '../view_models/auth_view_model.dart';

// Screens
import '../views/screens/chat/chat_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/registration_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/CBT/CBT_screen.dart';
import '../views/screens/CBT/tests/tests_assessment_screen.dart';
import '../views/screens/user/profile_screen.dart';
import '../views/screens/CBT/tests/tests_screen.dart';
import '../views/screens/CBT/moodtracker_screen.dart';
import '../views/screens/setting/setting_screen.dart';
import '../views/screens/CBT/countdown_screen.dart';
import '../views/screens/setting/editprofile_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true,

  redirect: (BuildContext context, GoRouterState state) {
    final auth = Provider.of<AuthViewModel>(context, listen: false);
    final currentPath = state.uri.path;
    final isLoggingIn = currentPath.startsWith('/login');
    final isRegistering = currentPath.startsWith('/register');
    final from = state.uri.queryParameters['from'];

    if (!auth.isAuthenticated && !isLoggingIn && !isRegistering) {
      final encodedFrom = Uri.encodeComponent(currentPath);
      return '/login?from=$encodedFrom&message=请先登录';
    }

    if (auth.isAuthenticated &&
        (isLoggingIn || isRegistering) &&
        from != null &&
        from.isNotEmpty) {
      return from;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
      routes: [
        GoRoute(
          path: 'profile',
          pageBuilder:
              (context, state) => const MaterialPage(child: ProfileScreen()),
        ),
        GoRoute(
          path: 'setting',
          pageBuilder:
              (context, state) => const MaterialPage(child: SettingsScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/edit-profile',
      pageBuilder:
          (context, state) => const MaterialPage(child: EditProfileScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder:
          (context, state) => const MaterialPage(child: RegistrationScreen()),
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) => const MaterialPage(child: ChatScreen()),
    ),
    GoRoute(
      path: '/cbt',
      pageBuilder: (context, state) => MaterialPage(child: CBTScreen()),
      routes: [
        GoRoute(
          path: 'mood',
          pageBuilder:
              (context, state) =>
                  const MaterialPage(child: MoodTrackerScreen()),
        ),
        GoRoute(
          path: 'tests',
          pageBuilder: (context, state) => MaterialPage(child: TestsScreen()),
          routes: [
            GoRoute(
              path: ':assessmentId',
              pageBuilder: (context, state) {
                final assessmentId = state.pathParameters['assessmentId']!;
                return MaterialPage(
                  child: AssessmentScreen(assessmentId: assessmentId),
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'countdown',
          pageBuilder:
              (context, state) => const MaterialPage(child: CountdownScreen()),
        ),
      ],
    ),
  ],
);
