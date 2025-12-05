import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/service/iicrc_assistant_service.dart';

/// IICRC Certified Master Water Restorer AI Assistant Screen
/// 
/// Provides expert guidance for field technicians on:
/// - Water mitigation categorization
/// - Mold remediation protocols
/// - Fire damage restoration
/// - PPE recommendations
/// - Psychrometric analysis
/// - Damage assessment
class IICRCAssistantScreen extends ConsumerStatefulWidget {
  const IICRCAssistantScreen({super.key});

  @override
  ConsumerState<IICRCAssistantScreen> createState() => _IICRCAssistantScreenState();
}

class _IICRCAssistantScreenState extends ConsumerState<IICRCAssistantScreen> {
  int _selectedCategoryIndex = 0;

  final List<AssistantCategory> _categories = [
    AssistantCategory(
      title: 'Water Mitigation',
      icon: Icons.water_damage,
      color: Colors.blue,
      description: 'Categorize water damage (Class 1-4)',
    ),
    AssistantCategory(
      title: 'Mold Remediation',
      icon: Icons.coronavirus,
      color: Colors.green,
      description: 'S520 protocols and safety',
    ),
    AssistantCategory(
      title: 'Fire Damage',
      icon: Icons.local_fire_department,
      color: Colors.orange,
      description: 'Initial assessment support',
    ),
    AssistantCategory(
      title: 'PPE Recommendations',
      icon: Icons.shield,
      color: Colors.purple,
      description: 'Safety compliance guidance',
    ),
    AssistantCategory(
      title: 'Psychrometric Analysis',
      icon: Icons.thermostat,
      color: Colors.teal,
      description: 'GPP, RH, Dew Point analysis',
    ),
    AssistantCategory(
      title: 'Damage Assessment',
      icon: Icons.photo_camera,
      color: Colors.red,
      description: 'Photo/video analysis',
    ),
    AssistantCategory(
      title: 'Ask a Question',
      icon: Icons.question_answer,
      color: Colors.indigo,
      description: 'General restoration questions',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IICRC AI Assistant'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // Header with certification badge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IICRC Certified',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Master Water Restorer AI Assistant',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Professional, safety-focused guidance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Category selection
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => _navigateToCategory(context, category),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: category.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(BuildContext context, AssistantCategory category) {
    Widget screen;
    
    switch (category.title) {
      case 'Water Mitigation':
        screen = const WaterMitigationScreen();
        break;
      case 'Mold Remediation':
        screen = const MoldRemediationScreen();
        break;
      case 'Fire Damage':
        screen = const FireDamageScreen();
        break;
      case 'PPE Recommendations':
        screen = const PPERecommendationScreen();
        break;
      case 'Psychrometric Analysis':
        screen = const PsychrometricScreen();
        break;
      case 'Damage Assessment':
        screen = const DamageAssessmentScreen();
        break;
      case 'Ask a Question':
        screen = const AskQuestionScreen();
        break;
      default:
        return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

/// Assistant category data model
class AssistantCategory {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  AssistantCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });
}

// ============================================================================
// WATER MITIGATION SCREEN
// ============================================================================

class WaterMitigationScreen extends ConsumerStatefulWidget {
  const WaterMitigationScreen({super.key});

  @override
  ConsumerState<WaterMitigationScreen> createState() => _WaterMitigationScreenState();
}

class _WaterMitigationScreenState extends ConsumerState<WaterMitigationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  WaterDamageAssessment? _assessment;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _assessWaterDamage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _assessment = null;
    });

    try {
      final service = IICRCAssistantService();
      await service.initialize();
      
      final assessment = await service.assessWaterDamage(
        description: _descriptionController.text,
      );
      
      setState(() {
        _assessment = assessment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Mitigation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water Damage Classification',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Describe the water damage situation for AI assessment',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Damage Description',
                  hintText: 'e.g., Burst pipe in kitchen, water spread to living room...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the water damage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _assessWaterDamage,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.analytics),
                label: Text(_isLoading ? 'Analyzing...' : 'Assess Damage'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              
              if (_assessment != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assessment Results',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Divider(),
                        _buildAssessmentResult('Water Class', _assessment!.waterClass),
                        _buildAssessmentResult('Water Category', _assessment!.waterCategory),
                        _buildAssessmentResult('Estimated Drying Time', _assessment!.estimatedDryingDays),
                        _buildAssessmentResult('PPE Level', _assessment!.ppeLevel),
                        const SizedBox(height: 16),
                        Text(
                          'Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(_assessment!.summary),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentResult(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// ============================================================================
// MOLD REMEDIATION SCREEN
// ============================================================================

class MoldRemediationScreen extends ConsumerWidget {
  const MoldRemediationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mold Remediation (S520)'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.coronavirus,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Mold Remediation Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Following IICRC S520 standards',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Implementation coming soon...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FIRE DAMAGE SCREEN
// ============================================================================

class FireDamageScreen extends ConsumerWidget {
  const FireDamageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Damage Assessment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Fire Damage Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Initial assessment and restoration guidance',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Implementation coming soon...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PPE RECOMMENDATION SCREEN
// ============================================================================

class PPERecommendationScreen extends ConsumerWidget {
  const PPERecommendationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPE Recommendations'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'PPE Recommendation Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Ensuring safety compliance',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Implementation coming soon...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PSYCHROMETRIC ANALYSIS SCREEN
// ============================================================================

class PsychrometricScreen extends ConsumerWidget {
  const PsychrometricScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychrometric Analysis'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.thermostat,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Psychrometric Analysis Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'GPP, RH, and Dew Point analysis for drying strategies',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Implementation coming soon...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DAMAGE ASSESSMENT SCREEN
// ============================================================================

class DamageAssessmentScreen extends ConsumerWidget {
  const DamageAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Damage Assessment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Damage Assessment Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Analyze photos/videos to identify materials and damage',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text(
                'Implementation coming soon...',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ASK A QUESTION SCREEN
// ============================================================================

class AskQuestionScreen extends ConsumerStatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  ConsumerState<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends ConsumerState<AskQuestionScreen> {
  final _questionController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  final List<ChatMessage> _messages = [];

  @override
  void dispose() {
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _askQuestion() async {
    if (_questionController.text.trim().isEmpty) return;

    final question = _questionController.text.trim();
    _questionController.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: question,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final service = IICRCAssistantService();
      await service.initialize();
      
      final answer = await service.askQuestion(question: question);
      
      setState(() {
        _messages.add(ChatMessage(
          text: answer,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Error: $e',
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
        _isLoading = false;
      });
      
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask IICRC Assistant'),
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ask any restoration-related question to get expert IICRC guidance',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          
          // Chat messages
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.question_answer,
                          size: 80,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        const Text('Ask me anything about restoration!'),
                        const SizedBox(height: 8),
                        const Text(
                          'Water damage, mold, fire, PPE, equipment...',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildChatMessage(message);
                    },
                  ),
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI Assistant is thinking...',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          
          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Type your question...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _askQuestion(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading ? null : _askQuestion,
                  icon: const Icon(Icons.send),
                  iconSize: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isError
              ? Colors.red.withOpacity(0.2)
              : message.isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'IICRC Assistant',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Text(message.text),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Chat message data model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}
