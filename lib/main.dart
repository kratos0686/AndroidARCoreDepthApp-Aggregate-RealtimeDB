import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'domain/service/gemini_service.dart';
import 'domain/service/iicrc_assistant_service.dart';
import 'presentation/screens/ar_scan_screen.dart';
import 'presentation/screens/iicrc_assistant_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables (.env.local if exists, else .env)
    // Note: To use .env.local, uncomment it in pubspec.yaml assets and create the file locally
    try {
      await dotenv.load(fileName: '.env.local');
    } catch (_) {
      await dotenv.load(fileName: '.env');
    }
    
    // Initialize Firebase
    // Note: Add google-services.json to android/app/ before running
    await Firebase.initializeApp();
    
    // Initialize Gemini AI service
    final geminiService = GeminiService();
    try {
      await geminiService.initialize();
      debugPrint('✓ Gemini AI service initialized successfully');
    } catch (e) {
      debugPrint('⚠ Gemini AI service initialization failed: $e');
      debugPrint('  The app will run but AI features will be unavailable.');
    }
    
    // Initialize IICRC Assistant service
    final iicrcAssistant = IICRCAssistantService();
    try {
      await iicrcAssistant.initialize();
      debugPrint('✓ IICRC Assistant service initialized successfully');
    } catch (e) {
      debugPrint('⚠ IICRC Assistant service initialization failed: $e');
      debugPrint('  The app will run but IICRC Assistant features will be unavailable.');
    }
    
    // Run the app with Riverpod provider scope
    runApp(const ProviderScope(child: MyApp()));
  } catch (e, stackTrace) {
    debugPrint('❌ App initialization failed: $e');
    debugPrint(stackTrace.toString());
    
    // Show error screen if critical initialization fails
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Initialization Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Failed to initialize the app:\n$e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'AR Scan Export',
      debugShowCheckedModeBanner: false,
      
      // Material Design 3 Theme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        
        // Card and surface styling
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // AppBar styling
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        
        // Button styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      
      // Dark theme (Material 3)
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      
      themeMode: ThemeMode.system, // Follow system theme
      
      home: const MyHomePage(title: 'AR Scan Export'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScansListScreen(),
    const IICRCAssistantScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list),
            label: 'Scans',
          ),
          NavigationDestination(
            icon: Icon(Icons.verified_outlined),
            selectedIcon: Icon(Icons.verified),
            label: 'IICRC AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Navigate to AR scan screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ARScanScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('New Scan'),
            )
          : null,
    );
  }
}

// Home Screen - Dashboard
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.view_in_ar,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'AR Room Scanner',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Water damage restoration with AI analysis',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.check_circle, color: Colors.green),
                      title: const Text('Firebase Initialized'),
                      subtitle: const Text('Cloud sync ready'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.auto_awesome, color: Colors.blue),
                      title: const Text('Gemini AI Ready'),
                      subtitle: const Text('Image analysis available'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified, color: Colors.purple),
                      title: const Text('IICRC AI Assistant'),
                      subtitle: const Text('Certified restoration guidance'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.download, color: Colors.orange),
                      title: const Text('Export Formats'),
                      subtitle: const Text('Xactimate (.ESX) & MICA (XML)'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap "New Scan" to start scanning',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

// Scans List Screen - Shows saved scans
class ScansListScreen extends StatelessWidget {
  const ScansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'No scans yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Create your first scan to see it here'),
        ],
      ),
    );
  }
}

// Settings Screen - App configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text('General Settings'),
          subtitle: Text('App preferences and configuration'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.cloud_sync),
          title: const Text('Cloud Sync'),
          subtitle: const Text('Auto-sync to Firebase'),
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Implement sync toggle
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.wifi),
          title: const Text('WiFi Only Sync'),
          subtitle: const Text('Sync only when connected to WiFi'),
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Implement WiFi-only toggle
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
          subtitle: const Text('Version 1.0.0'),
          onTap: () {
            showAboutDialog(
              context: context,
              applicationName: 'AR Scan Export',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2025 AR Scan Export',
            );
          },
        ),
      ],
    );
  }
}

