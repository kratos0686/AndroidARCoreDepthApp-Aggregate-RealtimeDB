import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ar_capability_service.g.dart';

enum ARCapability {
  native,
  webFallback,
  unsupported
}

class ARCapabilityService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<ARCapability> checkCapability() async {
    try {
      if (Platform.isAndroid) {
        return await _checkAndroidCapability();
      } else if (Platform.isIOS) {
        return await _checkIOSCapability();
      }
      return ARCapability.webFallback; // Default for others for now
    } catch (e) {
      // Log error
      return ARCapability.webFallback;
    }
  }

  Future<ARCapability> _checkAndroidCapability() async {
    final androidInfo = await _deviceInfo.androidInfo;

    // Check if the device is ARCore supported.
    // The ar_flutter_plugin also has a check mechanism, but we can do a quick check here.
    // Usually, this involves checking if "com.google.ar.core" is installable or supported.

    // For simplicity in this check build, we will assume true if SDK >= 24 (Nougat)
    // In a real app, use ArCoreApk.getInstance().checkAvailability() via MethodChannel if needed.
    bool supportsARCore = androidInfo.version.sdkInt >= 24;

    return supportsARCore ? ARCapability.native : ARCapability.webFallback;
  }

  Future<ARCapability> _checkIOSCapability() async {
    final iosInfo = await _deviceInfo.iosInfo;
    // ARKit requires A9 processor or newer (iPhone 6s and up)
    // Most modern iOS devices support it.
    return ARCapability.native;
  }
}

@riverpod
ARCapabilityService arCapabilityService(ArCapabilityServiceRef ref) {
  return ARCapabilityService();
}

@riverpod
Future<ARCapability> arCapability(ArCapabilityRef ref) {
  return ref.watch(arCapabilityServiceProvider).checkCapability();
}
