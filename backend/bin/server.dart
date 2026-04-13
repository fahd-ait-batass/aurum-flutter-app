import 'package:aurum_backend/src/config/backend_runtime_config.dart';
import 'package:aurum_backend/src/aurum_backend_server.dart';

Future<void> main(List<String> args) async {
  final BackendRuntimeConfig config = BackendRuntimeConfig.fromPlatform(
    args: args,
  );
  final AurumBackendServer server = AurumBackendServer(config: config);
  await server.start();
}
