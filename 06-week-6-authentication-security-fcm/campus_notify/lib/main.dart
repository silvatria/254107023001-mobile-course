import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app_badge_plus/app_badge_plus.dart';

// Import model & pages sesuai struktur folder lu
import 'data/announcement_storage.dart';
import 'models/app_model.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/announcement_page.dart';
import 'pages/archive_page.dart';

// Background Handler Wajib Top-Level
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final announcement = _announcementFromMessage(message);
  final storage = AnnouncementStorage();
  await storage.upsert(announcement.toJson());

  final saved = await storage.readAll() ?? const <Map<String, dynamic>>[];
  final unreadCount = saved.where((item) => item['isRead'] != true).length;
  if (await AppBadgePlus.isSupported()) {
    await AppBadgePlus.updateBadge(unreadCount);
  }

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
  );
  const androidDetails = AndroidNotificationDetails(
    'pengumuman_channel_v2',
    'Pengumuman Kampus',
    channelDescription: 'Notifikasi penting untuk pengumuman kampus',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );
  await _local.show(
    id: message.messageId.hashCode,
    title: announcement.judul,
    body: announcement.deskripsi,
    notificationDetails: const NotificationDetails(android: androidDetails),
    payload: _routeForMessage(message, announcement),
  );

  debugPrint('Handling a background message: ${message.messageId}');
}

// ================= FUNGSI FCM & NOTIFIKASI =================
final _local = FlutterLocalNotificationsPlugin();

PengumumanModel _announcementFromMessage(RemoteMessage message) {
  final data = message.data;
  final route = data['route'] as String?;
  final routeId = route != null && route.startsWith('/pengumuman/')
      ? Uri.decodeComponent(route.substring('/pengumuman/'.length))
      : null;
  final id =
      data['announcementId'] ??
      data['announcement_id'] ??
      data['id'] ??
      routeId ??
      message.messageId ??
      DateTime.now().microsecondsSinceEpoch.toString();

  return PengumumanModel(
    id: id,
    judul:
        data['judul'] ??
        data['title'] ??
        message.notification?.title ??
        'Pengumuman Kampus',
    deskripsi:
        data['deskripsi'] ??
        data['description'] ??
        data['content'] ??
        data['message'] ??
        data['body'] ??
        message.notification?.body ??
        '',
  );
}

String _routeForMessage(RemoteMessage message, PengumumanModel announcement) {
  return '/pengumuman/${Uri.encodeComponent(announcement.id)}';
}

Future<bool> requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );
  return settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
}

Future<void> initLocalNotifications({
  required void Function(String route) onTap,
}) async {
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  await _local.initialize(
    settings: const InitializationSettings(android: android, iOS: ios),
    onDidReceiveNotificationResponse: (response) {
      final route = response.payload;
      if (route != null && route.isNotEmpty) onTap(route);
    },
  );

  final launchDetails = await _local.getNotificationAppLaunchDetails();
  final launchRoute = launchDetails?.notificationResponse?.payload;
  if (launchDetails?.didNotificationLaunchApp == true &&
      launchRoute != null &&
      launchRoute.isNotEmpty) {
    onTap(launchRoute);
  }
}

void listenForeground({
  required Future<void> Function(PengumumanModel announcement) onAnnouncement,
  required void Function(String route) go,
}) {
  FirebaseMessaging.onMessage.listen((message) async {
    final announcement = _announcementFromMessage(message);
    await onAnnouncement(announcement);

    // Konfigurasi Android Detail dengan Suara dan Getar Aktif
    const androidDetails = AndroidNotificationDetails(
      'pengumuman_channel_v2',
      'Pengumuman Kampus',
      channelDescription: 'Notifikasi penting untuk pengumuman kampus',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    await _local.show(
      id: message.hashCode,
      title: announcement.judul,
      body: announcement.deskripsi,
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: _routeForMessage(message, announcement),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) async {
    final announcement = _announcementFromMessage(message);
    await onAnnouncement(announcement);
    go(_routeForMessage(message, announcement));
  });
}

Future<void> handleTerminated({
  required Future<void> Function(PengumumanModel announcement) onAnnouncement,
  required void Function(String route) go,
}) async {
  final initial = await FirebaseMessaging.instance.getInitialMessage();
  if (initial != null) {
    final announcement = _announcementFromMessage(initial);
    await onAnnouncement(announcement);
    go(_routeForMessage(initial, announcement));
  }
}

Future<void> initFcmSetup({
  required Future<void> Function(String token) onToken,
  required Future<void> Function(PengumumanModel announcement) onAnnouncement,
  required void Function(String route) go,
}) async {
  // ignore: deprecated_member_use
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) await onToken(token);

  // ignore: deprecated_member_use
  FirebaseMessaging.instance.onTokenRefresh.listen(onToken);

  await FirebaseMessaging.instance.subscribeToTopic('pengumuman-kampus');

  listenForeground(onAnnouncement: onAnnouncement, go: go);
  await handleTerminated(onAnnouncement: onAnnouncement, go: go);
}
// ==========================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await requestNotificationPermission();

  runApp(const ProviderScope(child: MyApp()));
}

// Helper Class biar GoRouter peka terhadap perubahan status login
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Ref ref, StateProvider<UserModel?> provider) {
    ref.listen(provider, (_, _) => notifyListeners());
  }
}

// Inisialisasi GoRouter dengan Auth Guard yang bener
final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref, authProvider),
    redirect: (context, state) {
      final user = ref.read(authProvider);
      final goingLogin = state.matchedLocation == '/login';

      if (user == null && !goingLogin) return '/login';
      if (user != null && goingLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/', builder: (_, _) => const HomePage()),
      GoRoute(path: '/arsip', builder: (_, _) => const ArchivePage()),
      GoRoute(
        path: '/pengumuman/:id',
        builder: (_, state) => AnnouncementPage(
          id: state.pathParameters['id'] ?? '',
          announcement: state.extra is PengumumanModel
              ? state.extra! as PengumumanModel
              : null,
        ),
      ),
    ],
  );
});

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool _notificationsInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  Future<void> _initializeNotifications() async {
    if (_notificationsInitialized || !mounted) return;
    _notificationsInitialized = true;

    final router = ref.read(_routerProvider);
    final announcements = ref.read(pengumumanProvider.notifier);
    await announcements.ready;

    void openRoute(String route) {
      unawaited(_openRoute(route, router, announcements));
    }

    Future<void> onAnnouncement(PengumumanModel announcement) {
      return announcements.addOrUpdate(announcement);
    }

    await initLocalNotifications(onTap: openRoute);
    await initFcmSetup(
      onToken: (token) async {
        debugPrint('FCM Token Refresh/Init: $token');
      },
      onAnnouncement: onAnnouncement,
      go: openRoute,
    );
  }

  Future<void> _openRoute(
    String route,
    GoRouter router,
    PengumumanNotifier announcements,
  ) async {
    await announcements.reload();
    router.go(route);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(pengumumanProvider.notifier).reload());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: 'Campus Notify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}
