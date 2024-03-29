import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mentos_flutter/src/config/config.dart';
import 'package:mentos_flutter/src/domain/service/deep_linking_service.dart';
import 'package:mentos_flutter/src/domain/service/notification_service.dart';
import 'package:mentos_flutter/src/presentation/page/app/view/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      // Flutter가 초기화 될때까지 기다림
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      // Splash 상태에서 대기
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      await dotenv.load(fileName: 'assets/config/.env');
      setupDIConfig();
      setupBlocConfig();
      await setupFirebaseConfig();
      await setupNotificationConfig(
        getIt.get<NotificationService>(),
        getIt.get<DeepLinkingService>()
      );
      setupRetrofitConfig();
      setupKakaoSDK();

      // 앱 실행
      runApp(const App());
      // Splash 종료
      FlutterNativeSplash.remove();
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack, fatal: true)
  );
}