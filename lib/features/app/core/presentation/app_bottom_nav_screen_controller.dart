import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/chat/presentation/chat_screen_controller.dart';
import 'package:linx/features/app/core/presentation/model/in_app_state.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/notifications/domain/fetch_cached_notifications_service.dart';
import 'package:linx/features/notifications/domain/fetch_notifications_permissions.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/features/notifications/domain/subscribe_to_background_notifications_service.dart';
import 'package:linx/features/notifications/domain/subscribe_to_foreground_notifications_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final appBottomNavScreenControllerProvider = StateNotifierProvider.autoDispose<
    AppBottomNavScreenController, AppBottomNavScreenUiState>((ref) {
  return AppBottomNavScreenController(
    ref.read(FetchNotificationPermissionsService.provider),
    ref.read(SubscribeToForegroundNotificationsService.provider),
    ref.read(SubscribeToBackgroundNotificationsService.provider),
    ref.read(FetchCachedNotificationsService.provider),
    ref.read(LogOutService.provider),
    ref.read(selectedChatIdUpdater),
    ref.read(SubscribeToCurrentUserService.provider)
  );
});

class AppBottomNavScreenController
    extends StateNotifier<AppBottomNavScreenUiState> {
  final Function(String) _updateSelectedChatId;
  final FetchNotificationPermissionsService
      _fetchNotificationPermissionsService;
  final SubscribeToForegroundNotificationsService
      _subscribeToForegroundNotificationsService;
  final SubscribeToBackgroundNotificationsService
      _subscribeToBackgroundNotificationsService;
  final FetchCachedNotificationsService _fetchCachedNotificationsService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;
  final LogOutService _logOutService;

  late LinxUser _currentUser;

  AppBottomNavScreenController(
    this._fetchNotificationPermissionsService,
    this._subscribeToForegroundNotificationsService,
    this._subscribeToBackgroundNotificationsService,
    this._fetchCachedNotificationsService,
    this._logOutService,
    this._updateSelectedChatId,
    this._subscribeToCurrentUserService,
  ) : super(AppBottomNavScreenUiState()) {
    initialize();
  }

  Future<void> initialize() async {
    final status = await _fetchNotificationPermissionsService.execute();

    if (status == AuthorizationStatus.authorized) {
      _subscribeToForegroundNotificationsService
          .execute()
          .listen(_handleNotifications);
      _subscribeToBackgroundNotificationsService
          .execute()
          .listen(_handleNotifications);
      _handleNotifications(await _fetchCachedNotificationsService.execute());
    }

    _subscribeToCurrentUserService.execute().listen((event) {
      _currentUser = event;
      state = AppBottomNavScreenUiState(
        state: InAppState.loaded,
        currentUser: _currentUser,
      );
    });
  }


  void logOut() async {
    _logOutService.execute();
  }

  void _handleNotifications(FCMNotification? notification) {
    if (notification == null) return;
    if (notification is NewMessageNotification) {
      _updateSelectedChatId.call(notification.chatId);
    } else if (notification is NewMatchNotification) {
    } else if (notification is NewPitchNotification) {}

    state = AppBottomNavScreenUiState(
      state: state.state,
      currentUser: state.currentUser,
      notification: notification,
    );
  }
}

class AppBottomNavScreenUiState {
  final InAppState state;
  final LinxUser? currentUser;
  final FCMNotification? notification;

  AppBottomNavScreenUiState({
    this.state = InAppState.loading,
    this.currentUser,
    this.notification,
  });
}
