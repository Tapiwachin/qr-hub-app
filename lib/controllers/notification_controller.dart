import 'package:get/get.dart';
import 'package:toyota_accessory_app/models/notification.dart';
import 'package:toyota_accessory_app/services/api_service.dart';
import 'package:toyota_accessory_app/services/storage_service.dart';

class NotificationController extends GetxController {
  final ApiService _apiService = Get.find();
  final StorageService _storageService = Get.find();
  final notifications = <Notification>[].obs;
  final unreadCount = 0.obs;
  final isLoading = false.obs;

  static const String lastReadKey = 'last_read_notification';

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final notificationsList = await _apiService.getNotifications();
      notifications.value = notificationsList;
      updateUnreadCount();
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUnreadCount() async {
    try {
      final lastReadTime = _storageService.getString(lastReadKey);
      if (lastReadTime != null) {
        final lastRead = DateTime.parse(lastReadTime);
        unreadCount.value =
            notifications.where((n) => n.scheduleTime.isAfter(lastRead)).length;
      } else {
        unreadCount.value = notifications.length;
      }
    } catch (e) {
      print('Error updating unread count: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _storageService.saveString(
        lastReadKey,
        DateTime.now().toIso8601String(),
      );
      unreadCount.value = 0;
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }
}
