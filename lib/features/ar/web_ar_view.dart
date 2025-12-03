import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebARView extends StatefulWidget {
  const WebARView({super.key});

  @override
  State<WebARView> createState() => _WebARViewState();
}

class _WebARViewState extends State<WebARView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // This would be your hosted WebAR URL (e.g., 8th Wall, ModelViewer)
  final String _webArUrl = 'https://modelviewer.dev/examples/augmentedreality/index.html';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(_webArUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Room Scanner (WebAR)')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
