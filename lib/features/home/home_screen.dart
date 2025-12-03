import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ar_capability_service.dart';
import '../ar/native_ar_view.dart';
import '../ar/web_ar_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capabilityAsync = ref.watch(arCapabilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Scanner'),
      ),
      body: Center(
        child: capabilityAsync.when(
          data: (capability) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Device Capability: ${capability.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Start Scan'),
                onPressed: () {
                  if (capability == ARCapability.native) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const NativeARView()),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const WebARView()),
                    );
                  }
                },
              ),
              if (capability == ARCapability.webFallback)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Note: Native AR is not supported on this device. Using WebAR fallback.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ),
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
        ),
      ),
    );
  }
}
