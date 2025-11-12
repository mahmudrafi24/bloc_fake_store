import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for checking network connectivity
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation of NetworkInfo using connectivity_plus package
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();

    // Check if any connection type is available (mobile, wifi, ethernet, etc.)
    // Returns false only if there's no connection at all
    // connectivity_plus returns ConnectivityResult (single value)
    return result != ConnectivityResult.none;
  }
}
