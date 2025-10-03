import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Stream provider for real-time connectivity status
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectivityStream;
});

/// Provider for current connectivity status
final isOnlineProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(connectivityStreamProvider);
  return asyncValue.when(
    data: (isOnline) => isOnline,
    loading: () => true, // Assume online while loading
    error: (_, __) => false,
  );
});

/// Service for monitoring network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Timer? _retryTimer;

  bool _isOnline = true;

  /// Current connectivity status (synchronous)
  bool get isOnline => _isOnline;

  /// Stream of connectivity changes
  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    _initialize();
  }

  /// Initialize connectivity monitoring
  void _initialize() async {
    // Check initial connectivity
    await _checkConnectivity();

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> results) {
        _handleConnectivityChange(results);
      },
    );
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    } catch (e) {
      print('Error checking connectivity: $e');
      _updateStatus(false);
    }
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    final hasConnection = results.any((result) =>
    result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet
    );

    _updateStatus(hasConnection);

    // If offline, start retry timer
    if (!hasConnection) {
      _startRetryTimer();
    } else {
      _cancelRetryTimer();
    }
  }

  /// Update connectivity status and notify listeners
  void _updateStatus(bool isOnline) {
    if (_isOnline != isOnline) {
      _isOnline = isOnline;
      _controller.add(_isOnline);
      print('Connectivity changed: ${_isOnline ? "ONLINE" : "OFFLINE"}');
    }
  }

  /// Start retry timer (check every 10 seconds when offline)
  void _startRetryTimer() {
    _cancelRetryTimer();
    _retryTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      print('Retrying connectivity check...');
      _checkConnectivity();
    });
  }

  /// Cancel retry timer
  void _cancelRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  /// Clean up resources
  void dispose() {
    _cancelRetryTimer();
    _subscription?.cancel();
    _controller.close();
  }
}