import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/app/app.dart';
import 'package:flutter_app/core/remote/remote_backend_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Aurum Table shell renders premium restaurant navigation', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});

    await tester.pumpWidget(
      const MomentumApp(
        remoteConfig: RemoteBackendConfig(
          provider: RemoteBackendProvider.disabled,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aurum Table'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Discover'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);

    await tester.tap(find.text('Discover').last);
    await tester.pumpAndSettle();
    expect(find.text('Find the room that matches tonight.'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Sign out on this device'), findsOneWidget);
  });
}
