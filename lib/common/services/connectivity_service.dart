import 'package:connectivity_plus/connectivity_plus.dart';

abstract class IConnectivityService {
  Future<bool> get isConnected;
}

class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    
    return !result.contains(ConnectivityResult.none);
  }
}