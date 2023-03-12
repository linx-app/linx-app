import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/presentation/model/in_app_state.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/notifications/data/subscribe_to_notifications_service.dart';
import 'package:linx/features/notifications/domain/fetch_notifications_permissions.dart';
import 'package:linx/features/notifications/domain/models/fcm_notification.dart';
import 'package:linx/features/notifications/domain/models/fcm_types.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final appBottomNavScreenControllerProvider = StateNotifierProvider.autoDispose<
    AppBottomNavScreenController, AppBottomNavScreenUiState>((ref) {
  return AppBottomNavScreenController(
    ref.watch(currentUserProvider),
    ref.read(FetchNotificationPermissionsService.provider),
    ref.read(SubscribeToNotificationsService.provider),
    ref.read(LogOutService.provider),
    ref.read(updateCurrentUserProvider),
  );
});

final currentUserProvider = StateProvider.autoDispose<LinxUser?>((ref) => null);

final updateCurrentUserProvider = Provider<Function()>((ref) {
  return (() async {
    final userNotifier = ref.read(currentUserProvider.notifier);
    userNotifier.state = await ref.read(UserService.provider).fetchUser();
  });
});

class AppBottomNavScreenController
    extends StateNotifier<AppBottomNavScreenUiState> {
  final LinxUser? _currentUser;
  final Function() _updateCurrentUser;
  final FetchNotificationPermissionsService
      _fetchNotificationPermissionsService;
  final SubscribeToNotificationsService _subscribeToNotificationsService;
  final LogOutService _logOutService;

  AppBottomNavScreenController(
    this._currentUser,
    this._fetchNotificationPermissionsService,
    this._subscribeToNotificationsService,
    this._logOutService,
    this._updateCurrentUser,
  ) : super(AppBottomNavScreenUiState()) {
    initialize();
  }

  Future<void> initialize() async {
    final status = await _fetchNotificationPermissionsService.execute();

    if (status == AuthorizationStatus.authorized) {
      _subscribeToNotificationsService.execute(_foregroundNotificationsHandler);
    }

    if (_currentUser != null) {
      state = AppBottomNavScreenUiState(
        state: InAppState.loaded,
        currentUser: _currentUser!,
      );
    } else {
      _updateCurrentUser.call();
    }
  }

  void _foregroundNotificationsHandler(FCMNotification notification) {
    if (notification.type == FCMType.new_pitch) {
    } else if (notification.type == FCMType.new_match) {}
  }

  void logOut() async {
    _logOutService.execute();
  }
}

class AppBottomNavScreenUiState {
  final InAppState state;
  final LinxUser? currentUser;

  AppBottomNavScreenUiState({
    this.state = InAppState.loading,
    this.currentUser,
  });
}
