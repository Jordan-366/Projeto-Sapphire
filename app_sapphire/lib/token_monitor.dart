import 'dart:async';
import 'package:flutter/material.dart';
import 'token_storage.dart';

class TokenMonitorService {
  static final TokenMonitorService _instance = TokenMonitorService._internal();
  Timer? _monitorTimer;
  final List<VoidCallback> _expiredCallbacks = [];
  final List<void Function(int)> _expiringCallbacks = [];

  factory TokenMonitorService() {
    return _instance;
  }

  TokenMonitorService._internal();

  /// Inicia o monitoramento do token a cada 1 minuto
  void startMonitoring() {
    if (_monitorTimer != null) return;

    _monitorTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkTokenStatus(),
    );

    // Verifica imediatamente ao iniciar
    _checkTokenStatus();
  }

  /// Para o monitoramento
  void stopMonitoring() {
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  /// Verifica o status do token
  Future<void> _checkTokenStatus() async {
    final token = await TokenStorage().get();

    if (token == null) {
      // Token expirou ou foi removido
      _notifyExpired();
      return;
    }

    // Verifica a data de expiração
    final expiryMillis = await TokenStorage().getTokenExpiry();
    if (expiryMillis != null) {
      final timeRemaining = DateTime.fromMillisecondsSinceEpoch(
        expiryMillis,
      ).difference(DateTime.now()).inMinutes;

      if (timeRemaining <= 0) {
        _notifyExpired();
      } else if (timeRemaining <= 30 && timeRemaining > 0) {
        _notifyExpiring(timeRemaining);
      }
    }
  }

  /// Registra callback quando token expirar
  void onTokenExpired(VoidCallback callback) {
    _expiredCallbacks.add(callback);
  }

  /// Registra callback quando token estiver próximo de expirar (recebe minutos restantes)
  void onTokenExpiring(void Function(int) callback) {
    _expiringCallbacks.add(callback);
  }

  void _notifyExpired() {
    for (var callback in _expiredCallbacks) {
      callback();
    }
  }

  void _notifyExpiring(int minutesRemaining) {
    for (var callback in _expiringCallbacks) {
      callback(minutesRemaining);
    }
  }

  void dispose() {
    stopMonitoring();
    _expiredCallbacks.clear();
    _expiringCallbacks.clear();
  }
}
