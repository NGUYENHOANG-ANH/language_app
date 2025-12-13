import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_progress_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  static const String _progressBoxName = 'user_progress';
  static const String _settingsBoxName = 'app_settings';
  static const String _progressKey = 'progress_data';

  Future<void> initialize() async {
    // Hive đã được khởi tạo trong main.dart
  }

  /// Lưu tiến độ người dùng
  Future<void> saveProgress(UserProgress progress) async {
    try {
      final box = await Hive.openBox<String>(_progressBoxName);
      await box.put(_progressKey, jsonEncode(progress.toJson()));
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  /// Lấy tiến độ người dùng
  Future<UserProgress?> getProgress() async {
    try {
      final box = await Hive.openBox<String>(_progressBoxName);
      final data = box.get(_progressKey);
      if (data != null) {
        return UserProgress.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print('Error loading progress: $e');
    }
    return null;
  }

  /// Lưu cài đặt
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      final box = await Hive.openBox<dynamic>(_settingsBoxName);
      await box.put(key, value);
    } catch (e) {
      print('Error saving setting: $e');
    }
  }

  /// Lấy cài đặt
  Future<dynamic> getSetting(String key, {dynamic defaultValue}) async {
    try {
      final box = await Hive.openBox<dynamic>(_settingsBoxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      print('Error loading setting: $e');
      return defaultValue;
    }
  }

  /// Xóa dữ liệu
  Future<void> clearAll() async {
    try {
      await Hive.deleteBoxFromDisk(_progressBoxName);
      await Hive.deleteBoxFromDisk(_settingsBoxName);
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }
}
