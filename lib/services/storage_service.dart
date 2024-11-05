// lib/services/storage_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<StorageService> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      return this;
    } catch (e) {
      print('Error initializing StorageService: $e');
      rethrow;
    }
  }

  void _checkInitialization() {
    if (!_initialized) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> items) async {
    _checkInitialization();
    try {
      final String jsonString = json.encode(items);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving list to storage: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> getList(String key) async {
    _checkInitialization();
    try {
      final String? jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error getting list from storage: $e');
      rethrow;
    }
  }

  Future<void> saveString(String key, String value) async {
    _checkInitialization();
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      print('Error saving string to storage: $e');
      rethrow;
    }
  }

  String? getString(String key) {
    _checkInitialization();
    try {
      return _prefs.getString(key);
    } catch (e) {
      print('Error getting string from storage: $e');
      rethrow;
    }
  }

  Future<void> remove(String key) async {
    _checkInitialization();
    try {
      await _prefs.remove(key);
    } catch (e) {
      print('Error removing key from storage: $e');
      rethrow;
    }
  }

  Future<void> clear() async {
    _checkInitialization();
    try {
      await _prefs.clear();
    } catch (e) {
      print('Error clearing storage: $e');
      rethrow;
    }
  }

  bool hasKey(String key) {
    _checkInitialization();
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      print('Error checking key existence: $e');
      rethrow;
    }
  }
}
