import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/providers.dart';

/// AR Scan Screen with automatic fallback
/// 
/// This screen implements a smart AR scanning experience:
/// 1. Checks if device supports native ARCore/ARKit
/// 2. If supported, uses native AR implementation (arcore_flutter_plugin)
/// 3. If not supported, falls back to WebAR using WebView
/// 
/// This ensures the app works on all devices, even those without AR capabilities.
class ARScanScreen extends ConsumerWidget {
  const ARScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch AR capability provider
    final arCapabilityAsync = ref.watch(arCapabilityProvider);
    
    return arCapabilityAsync.when(
      data: (hasAR) {
        // Show appropriate view based on AR capability
        // The arModeProvider will be updated by other components if needed
        return hasAR ? const NativeARView() : const WebARFallbackView();
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AR Scanner'),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Checking AR capability...'),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AR Scanner'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Error checking AR capability: $error\nFalling back to WebAR mode.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Invalidate the provider to retry
                      ref.invalidate(arCapabilityProvider);
                    },
                    child: const Text('Retry'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Native ARCore/ARKit View
/// 
/// Uses arcore_flutter_plugin for native AR experience on supported devices
class NativeARView extends StatefulWidget {
  const NativeARView({super.key});

  @override
  State<NativeARView> createState() => _NativeARViewState();
}

class _NativeARViewState extends State<NativeARView> {
  // TODO: Implement ARCore session management
  // arcore_flutter_plugin integration will go here
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Scanner - Native'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Stack(
        children: [
          // TODO: ARCore camera view will be displayed here
          // Example:
          // ARCoreView(
          //   onARCoreViewCreated: _onARCoreViewCreated,
          //   enableTapRecognizer: true,
          // ),
          
          // Placeholder for native AR view
          Container(
            color: Colors.black,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.view_in_ar, size: 100, color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Native ARCore View',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'ARCore integration pending',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          // AR Controls Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildARButton(
                    icon: Icons.camera_alt,
                    label: 'Capture',
                    onPressed: () {
                      // TODO: Capture point cloud
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Capture functionality pending'),
                        ),
                      );
                    },
                  ),
                  _buildARButton(
                    icon: Icons.straighten,
                    label: 'Measure',
                    onPressed: () {
                      // TODO: Start measurement mode
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Measurement functionality pending'),
                        ),
                      );
                    },
                  ),
                  _buildARButton(
                    icon: Icons.place,
                    label: 'Anchor',
                    onPressed: () {
                      // TODO: Place AR anchor
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Anchor placement pending'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // AR Mode Indicator
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    'Native ARCore',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white, size: 32),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}

/// WebAR Fallback View
/// 
/// Uses WebView to display WebAR experience for devices without ARCore/ARKit
/// Provides basic measurement and scanning capabilities through web technologies
class WebARFallbackView extends StatefulWidget {
  const WebARFallbackView({super.key});

  @override
  State<WebARFallbackView> createState() => _WebARFallbackViewState();
}

class _WebARFallbackViewState extends State<WebARFallbackView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _errorMessage = '';
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to load WebAR: ${error.description}';
            });
          },
        ),
      );

    // TODO: Replace with actual WebAR implementation
    // Options for WebAR implementation:
    // 1. Create custom HTML with model-viewer or AR.js and serve locally:
    //    _controller.loadFlutterAsset('assets/webar/index.html');
    // 2. Use 8th Wall WebAR platform (requires account):
    //    Uri.parse('https://your-8thwall-project.8thwall.app/');
    // 3. Use Three.js with WebXR for custom AR experiences
    // 4. Integrate Google's model-viewer web component
    
    // Load placeholder HTML explaining WebAR setup
    _controller.loadHtmlString('''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body { 
            font-family: system-ui; 
            padding: 20px; 
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
          }
          .container {
            max-width: 400px;
          }
          h1 { font-size: 24px; margin-bottom: 16px; }
          p { font-size: 14px; line-height: 1.6; margin-bottom: 20px; }
          .icon { font-size: 64px; margin-bottom: 20px; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="icon">🌐</div>
          <h1>WebAR Mode</h1>
          <p>This device does not support native ARCore.</p>
          <p>WebAR functionality will be implemented here using:</p>
          <ul style="text-align: left;">
            <li>Model Viewer for 3D objects</li>
            <li>WebXR Device API for AR experiences</li>
            <li>Camera access for measurement tools</li>
          </ul>
          <p style="margin-top: 20px; font-size: 12px; opacity: 0.8;">
            To implement: Create WebAR HTML app and load it here.
          </p>
        </div>
      </body>
      </html>
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Scanner - WebAR'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView for WebAR
          if (_errorMessage.isEmpty)
            WebViewWidget(controller: _controller),
          
          // Error message
          if (_errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = '';
                        });
                        _controller.reload();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          
          // Loading indicator
          if (_isLoading && _errorMessage.isEmpty)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading WebAR...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          
          // WebAR Mode Indicator
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 16, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'WebAR Mode',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          
          // Info banner about WebAR mode
          if (!_isLoading && _errorMessage.isEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Card(
                color: Colors.blue.shade800,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Using WebAR fallback mode. Native AR not available on this device.',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
