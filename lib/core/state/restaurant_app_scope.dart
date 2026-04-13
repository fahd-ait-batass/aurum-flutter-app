import 'package:flutter/material.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';
import 'package:flutter_app/core/state/restaurant_app_state.dart';

class RestaurantAppScope extends StatefulWidget {
  const RestaurantAppScope({
    super.key,
    required this.child,
    this.remoteConfig,
  });

  final Widget child;
  final RemoteBackendConfig? remoteConfig;

  static RestaurantAppState watch(BuildContext context) {
    final _RestaurantAppInherited? inherited =
        context.dependOnInheritedWidgetOfExactType<_RestaurantAppInherited>();
    assert(inherited != null, 'RestaurantAppScope.watch() called without scope');
    return inherited!.notifier!;
  }

  static RestaurantAppState read(BuildContext context) {
    final _RestaurantAppInherited? inherited = context
            .getElementForInheritedWidgetOfExactType<_RestaurantAppInherited>()
            ?.widget
        as _RestaurantAppInherited?;
    assert(inherited != null, 'RestaurantAppScope.read() called without scope');
    return inherited!.notifier!;
  }

  @override
  State<RestaurantAppScope> createState() => _RestaurantAppScopeState();
}

class _RestaurantAppScopeState extends State<RestaurantAppScope> {
  late final RestaurantAppState _state = RestaurantAppState.seeded(
    remoteConfig: widget.remoteConfig,
  );

  @override
  void initState() {
    super.initState();
    _state.hydrate();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _RestaurantAppInherited(notifier: _state, child: widget.child);
  }
}

class _RestaurantAppInherited extends InheritedNotifier<RestaurantAppState> {
  const _RestaurantAppInherited({required super.notifier, required super.child});
}
