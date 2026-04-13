import 'dart:convert';
import 'dart:io';

class AtomicJsonFileStore {
  AtomicJsonFileStore({
    required File file,
    required Map<String, dynamic> defaultValue,
  }) : _file = file,
       _backupFile = File('${file.path}.bak'),
       _tempFile = File('${file.path}.tmp'),
       _defaultValue = Map<String, dynamic>.from(defaultValue);

  final File _file;
  final File _backupFile;
  final File _tempFile;
  final Map<String, dynamic> _defaultValue;

  Future<Map<String, dynamic>> load() async {
    await _ensureDirectory();
    final Map<String, dynamic>? primary = await _readIfValid(_file);
    if (primary != null) {
      return primary;
    }

    final Map<String, dynamic>? backup = await _readIfValid(_backupFile);
    if (backup != null) {
      await write(backup);
      return backup;
    }

    await write(_defaultValue);
    return _clone(_defaultValue);
  }

  Future<void> write(Map<String, dynamic> payload) async {
    await _ensureDirectory();
    final String encoded = const JsonEncoder.withIndent('  ').convert(payload);
    await _tempFile.writeAsString(encoded);

    if (await _file.exists()) {
      await _file.copy(_backupFile.path);
      await _file.delete();
    }

    await _tempFile.rename(_file.path);
  }

  Future<void> _ensureDirectory() async {
    final Directory directory = _file.parent;
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  Future<Map<String, dynamic>?> _readIfValid(File file) async {
    if (!await file.exists()) {
      return null;
    }
    try {
      final Object? decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, dynamic>) {
        return _clone(decoded);
      }
    } catch (_) {}
    return null;
  }

  Map<String, dynamic> _clone(Map<String, dynamic> source) {
    return Map<String, dynamic>.from(source);
  }
}
