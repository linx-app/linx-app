import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/notifications/data/subscribe_to_notifications_service.dart';
import 'package:linx/features/notifications/domain/fetch_notifications_permissions.dart';
import 'package:linx/features/notifications/domain/models/fcm_notification.dart';
import 'package:linx/features/notifications/domain/models/fcm_types.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final appBottomNavScreenControllerProvider = StateNotifierProvider.autoDispose<
    AppBottomNavScreenController, AppBottomNavScreenUiState>((ref) {
  return AppBottomNavScreenController(
    ref.read(UserService.provider),
    ref.read(FetchNotificationPermissionsService.provider),
    ref.read(SubscribeToNotificationsService.provider),
  );
});

class AppBottomNavScreenController
    extends StateNotifier<AppBottomNavScreenUiState> {
  AppBottomNavScreenController(
    this._userService,
    this._fetchNotificationPermissionsService,
    this._subscribeToNotificationsService,
  ) : super(AppBottomNavScreenUiState()) {
    initialize();
  }

  final UserService _userService;
  final FetchNotificationPermissionsService
      _fetchNotificationPermissionsService;
  final SubscribeToNotificationsService _subscribeToNotificationsService;

  Future<void> initialize() async {
    var status = await _fetchNotificationPermissionsService.execute();

    if (status == AuthorizationStatus.authorized) {
      _subscribeToNotificationsService.execute(_foregroundNotificationsHandler);
    }

    var user = await _userService.fetchUserProfile();
    state = AppBottomNavScreenUiState(currentUser: user);
  }

  void _foregroundNotificationsHandler(FCMNotification notification) {
    if (notification.type == FCMType.new_pitch) {

    } else if (notification.type == FCMType.new_match) {

    }
  }
}

class AppBottomNavScreenUiState {
  final LinxUser? currentUser;

  AppBottomNavScreenUiState({this.currentUser});
}
