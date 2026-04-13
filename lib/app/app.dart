import 'package:flutter/material.dart';
import 'package:flutter_app/app/app_root.dart';
import 'package:flutter_app/app/theme/app_theme.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key, this.remoteConfig});

  final RemoteBackendConfig? remoteConfig;

  @override
  Widget build(BuildContext context) {
    return RestaurantAppScope(
      remoteConfig: remoteConfig,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aurum Table',
        theme: AppTheme.dark(),
        home: const AppRoot(),
      ),
    );
  }
}
