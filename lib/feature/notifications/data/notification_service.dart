import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/feature/auth/domain/entities/user_summary_entity.dart';
import 'package:entao_bora/feature/notifications/domain/entities/notification_activation_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  NotificationService(this._firestore, this._messaging);

  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  static const _webVapidKey = String.fromEnvironment('FCM_WEB_VAPID_KEY');

  StreamSubscription<String>? _tokenRefreshSubscription;

  Future<NotificationActivationResult> activate({
    required UserSummaryEntity user,
  }) async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final authorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (!authorized) {
        return const NotificationActivationResult(
          success: false,
          message: 'Permissão de notificação não concedida.',
        );
      }

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        return NotificationActivationResult(
          success: false,
          message: kIsWeb && _webVapidKey.isEmpty
              ? 'Informe a chave VAPID web para ativar notificações no navegador.'
              : 'Não foi possível gerar o token de notificação.',
        );
      }

      await _saveToken(
        user: user,
        token: token,
      );

      await _tokenRefreshSubscription?.cancel();

      _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
        (newToken) async {
          try {
            await _saveToken(
              user: user,
              token: newToken,
            );
          } catch (e) {
            debugPrint(
              'Erro ao atualizar token de notificação: $e',
            );
          }
        },
      );

      return const NotificationActivationResult(
        success: true,
        message: 'Notificações ativadas com sucesso.',
      );
    } catch (e, stackTrace) {
      debugPrint('Erro ao ativar notificações: $e');
      debugPrintStack(stackTrace: stackTrace);

      return const NotificationActivationResult(
        success: false,
        message: 'Não foi possível ativar as notificações.',
      );
    }
  }

  Future<String?> _getToken() async {
    if (kIsWeb) {
      if (_webVapidKey.isEmpty) {
        return null;
      }

      return _messaging.getToken(
        vapidKey: _webVapidKey,
      );
    }

    return _messaging.getToken();
  }

  Future<void> _saveToken({
    required UserSummaryEntity user,
    required String token,
  }) async {
    final encodedToken = base64Url.encode(
      utf8.encode(token),
    );

    final userRef = _firestore
        .collection('users')
        .doc(user.id);

    final tokenRef = userRef
        .collection('notification_tokens')
        .doc(encodedToken);

    final now = FieldValue.serverTimestamp();

    final batch = _firestore.batch();

    batch.set(
      userRef,
      {
        'notificationsEnabled': true,
        'notificationUpdatedAt': now,
      },
      SetOptions(merge: true),
    );

    batch.set(
      tokenRef,
      {
        'token': token,
        'platform': defaultTargetPlatform.name,
        'isWeb': kIsWeb,
        'enabled': true,
        'updatedAt': now,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<void> deactivate({
    required UserSummaryEntity user,
  }) async {
    try {
      final token = await _getToken();

      final userRef = _firestore
          .collection('users')
          .doc(user.id);

      final batch = _firestore.batch();

      batch.set(
        userRef,
        {
          'notificationsEnabled': false,
          'notificationUpdatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (token != null && token.isNotEmpty) {
        final encodedToken = base64Url.encode(
          utf8.encode(token),
        );

        final tokenRef = userRef
            .collection('notification_tokens')
            .doc(encodedToken);

        batch.set(
          tokenRef,
          {
            'enabled': false,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      }

      await batch.commit();

      await _tokenRefreshSubscription?.cancel();
      _tokenRefreshSubscription = null;
    } catch (e, stackTrace) {
      debugPrint('Erro ao desativar notificações: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }
}