import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection_wrapper.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';

class NativeARView extends StatefulWidget {
  const NativeARView({super.key});

  @override
  State<NativeARView> createState() => _NativeARViewState();
}

class _NativeARViewState extends State<NativeARView> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  @override
  void dispose() {
    super.dispose();
    arSessionManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Scanner (Native)')),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          // Overlay UI for scanning controls
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Capture action
                },
                child: const Text('Capture Scan'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;
    arAnchorManager = anchorManager;

    arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      showWorldOrigin: true,
      handleTaps: false,
    );
    arObjectManager!.onInitialize();
  }
}
