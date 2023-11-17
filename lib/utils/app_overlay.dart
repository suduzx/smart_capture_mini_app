import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AppOverlay {

  factory AppOverlay() {
    return _overlay;
  }

  AppOverlay._internal(this.cachedOnClose, this.cachedOnAction, this._channel) {
    _channel.setMethodCallHandler((call) async {
      final method = call.method;
      final uniqueId = call.arguments['uniqueId'];
      if(uniqueId == null) return;
      switch (method) {
        case 'onClose':
          cachedOnClose[uniqueId]?.call();
          cachedOnClose.remove(uniqueId);
          break;
        case 'onAction':
          cachedOnAction[uniqueId]?.call();
          cachedOnAction.remove(uniqueId);
          break;
        default:
      }
    });
  }

  static final AppOverlay _overlay = AppOverlay._internal({}, {}, MethodChannel('app_overlay_method_channel'));

  final MethodChannel _channel;

  final Map<String, VoidCallback?> cachedOnClose;

  final Map<String, VoidCallback?> cachedOnAction;



  /// Show success alert
  void showSuccessAlert({
    String? title,
    String? content,
    VoidCallback? onClose,
  }) {
    final uniqueId = Uuid().v4();
    cachedOnClose[uniqueId] = onClose;
    _channel.invokeMethod('showSuccessAlert',
        {'title': title, 'content': content, 'uniqueId': uniqueId});
  }

  /// Show error alert
  void showErrorAlert({
    String? title,
    String? content,
    VoidCallback? onClose,
  }) {
    final uniqueId = Uuid().v4();
    cachedOnClose[uniqueId] = onClose;
    _channel.invokeMethod('showErrorAlert',
        {'title': title, 'content': content, 'uniqueId': uniqueId});
  }

  /// Show error alert
  void showWarningAlert({
    String? title,
    String? content,
    VoidCallback? onClose,
  }) {
    final uniqueId = Uuid().v4();
    cachedOnClose[uniqueId] = onClose;
    _channel.invokeMethod('showWarningAlert',
        {'title': title, 'content': content, 'uniqueId': uniqueId});
  }

  /// Show notification
  void showNotification({
    String? title,
    String? content,
    String? action,
    VoidCallback? onAction,
    VoidCallback? onClose,
  }) {
    final uniqueId = Uuid().v4();
    cachedOnClose[uniqueId] = onClose;
    cachedOnAction[uniqueId] = onAction;
    _channel.invokeMethod('showNotification', {
      'title': title,
      'content': content,
      'action': action,
      'uniqueId': uniqueId
    });
  }

  /// Show loading
  void showLoading() {
    final uniqueId = Uuid().v4();
    _channel.invokeMethod('showLoading', {'uniqueId': uniqueId});
  }

  /// Hide loading
  void hideLoading() {
    final uniqueId = Uuid().v4();
    _channel.invokeMethod('hideLoading', {'uniqueId': uniqueId});
  }
}