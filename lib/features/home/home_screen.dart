import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/ar_capability_service.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/export_service.dart';
import '../ar/native_ar_view.dart';
import '../ar/web_ar_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _noteController = TextEditingController();
  String _aiResponse = "";
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final capabilityAsync = ref.watch(arCapabilityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Export',
            onPressed: () => _showExportDialog(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- AR Section ---
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.view_in_ar, size: 48, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text(
                        'AR Room Scan',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      capabilityAsync.when(
                        data: (capability) => Column(
                          children: [
                            Text('Device: ${capability.name}'),
                            const SizedBox(height: 10),
                            ElevatedButton(
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
                              child: const Text('Start Scan'),
                            ),
                          ],
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (err, stack) => Text('Error: $err'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- AI Assistant Section ---
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            'Gemini AI Assistant',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _noteController,
                        decoration: const InputDecoration(
                          labelText: 'Quick Note (e.g., "mold under sink")',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_isProcessing)
                         const Center(child: CircularProgressIndicator())
                      else
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.edit_note),
                                label: const Text('Refine Note'),
                                onPressed: () async {
                                  if (_noteController.text.isEmpty) return;
                                  setState(() => _isProcessing = true);

                                  final result = await ref.read(geminiServiceProvider).refineNote(_noteController.text);

                                  setState(() {
                                    _aiResponse = result;
                                    _isProcessing = false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.analytics),
                                label: const Text('Check Measurements'),
                                onPressed: () async {
                                  // Mock data for demo
                                  setState(() => _isProcessing = true);
                                  final result = await ref.read(geminiServiceProvider).validateMeasurements({
                                    'length': 12.0,
                                    'width': 10.0,
                                    'height': 50.0 // Intentionally unrealistic
                                  });

                                  setState(() {
                                    _aiResponse = result;
                                    _isProcessing = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      if (_aiResponse.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.deepPurple.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("AI Response:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              const SizedBox(height: 5),
                              Text(_aiResponse),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Export to Xactimate (.ESX)'),
            onTap: () {
              Navigator.pop(context);
              // Mock data export
              ref.read(exportServiceProvider).exportToXactimate({
                'name': 'Living Room',
                'length': 15.0,
                'width': 12.0,
                'height': 8.0,
                'notes': [_noteController.text.isNotEmpty ? _noteController.text : 'Water damage visible']
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Export to MICA (.XML)'),
            onTap: () {
              Navigator.pop(context);
               ref.read(exportServiceProvider).exportToMica({
                'name': 'Living Room',
                'length': 15.0,
                'width': 12.0,
              });
            },
          ),
        ],
      ),
    );
  }
}
