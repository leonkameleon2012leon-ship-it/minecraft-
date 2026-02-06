import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String kEmptyChallengeMessage =
    'Brak dostępnych wyzwań. Spróbuj ponownie później.';
const int kMinAdSeconds = 1;
const int kMaxAdSeconds = 999;

void main() {
  // Add comprehensive error handling
  FlutterError.onError = (details) {
    if (kDebugMode) {
      print('🔴 Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    }
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () {
      if (kDebugMode) {
        print('🚀 Starting MineQuest app...');
      }
      runApp(const MineQuestApp());
    },
    (error, stack) {
      if (kDebugMode) {
        print('🔴 Uncaught error: $error');
        print('Stack trace: $stack');
      }
    },
  );
}

class MineQuestApp extends StatelessWidget {
  const MineQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('✅ Building MineQuestApp');
    }
    
    try {
      final colorScheme = ColorScheme.fromSeed(
        seedColor: const Color(0xFF2E7D32),
        brightness: Brightness.dark,
      );

      return MaterialApp(
        title: 'MineQuest',
        theme: ThemeData(
          colorScheme: colorScheme,
          scaffoldBackgroundColor: const Color(0xFF101615),
          useMaterial3: true,
          textTheme: const TextTheme(
            headlineMedium: TextStyle(fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        home: const WelcomeScreen(),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('🔴 Error building MineQuestApp: $e');
        print('Stack trace: $stackTrace');
      }
      // Return a minimal error screen
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error loading app: $e'),
          ),
        ),
      );
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('✅ Building WelcomeScreen');
    }
    
    try {
      return MineQuestScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MinecraftAnimation(height: 180),
            const SizedBox(height: 24),
            Text(
              'MineQuest',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Twoja codzienna dawka minecraftowych wyzwań.',
              style: TextStyle(fontSize: 16, color: Color(0xFFB0BEC5)),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlayerSetupScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Rozpocznij przygodę'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFFFFD54F)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Animacje inspirowane światem Minecrafta wprowadzą Cię w klimat.',
                    style: TextStyle(color: Color(0xFFCFD8DC)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('🔴 Error building WelcomeScreen: $e');
        print('Stack trace: $stackTrace');
      }
      return Scaffold(
        body: Center(
          child: Text('Error: $e'),
        ),
      );
    }
  }
}

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _versions = const [
    'Java 1.21',
    'Java 1.20',
    'Bedrock 1.20',
    'Snapshot',
    'Modpack',
  ];
  String? _selectedVersion;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continue() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _selectedVersion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Podaj imię i wersję, aby ruszyć dalej.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChallengeScreen(
          playerName: name,
          version: _selectedVersion!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('✅ Building PlayerSetupScreen');
    }
    
    return MineQuestScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MinecraftAnimation(height: 140),
          const SizedBox(height: 24),
          Text(
            'Twoje dane',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'Powiedz nam jak się nazywasz i w co grasz.',
            style: TextStyle(fontSize: 16, color: Color(0xFFB0BEC5)),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Twoje imię',
              filled: true,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedVersion,
            items: _versions
                .map(
                  (version) => DropdownMenuItem(
                    value: version,
                    child: Text(version),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedVersion = value),
            decoration: const InputDecoration(
              labelText: 'Wersja Minecrafta',
              filled: true,
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: _continue,
            child: const Text('Dalej'),
          ),
        ],
      ),
    );
  }
}

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    super.key,
    required this.playerName,
    required this.version,
  });

  final String playerName;
  final String version;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final Random _random = Random();
  final List<String> _challenges = const [
    'Zbuduj zoo dla pand i stwórz im bambusowy wybieg.',
    'Stwórz ukryty portal do Netheru w jaskini.',
    'Zaprojektuj farmę pszczół z kwiatową łąką.',
    'Zbuduj wioskę w koronach drzew z mostami linowymi.',
    'Wykop podziemną bazę z tajnym wejściem.',
    'Zrób fortecę z obsydianu i wodospadami lawy.',
    'Stwórz lodowy tor wyścigowy dla łodzi.',
    'Odtwórz pixel art z ulubionego creepera.',
  ];

  String? _currentChallenge;
  String? _previousChallenge;
  bool _isWatchingAd = false;

  String _pickChallenge() {
    if (_challenges.isEmpty) {
      return kEmptyChallengeMessage;
    }
    if (_challenges.length == 1) {
      _previousChallenge = null;
      return _challenges.first;
    }
    String candidate;
    do {
      candidate = _challenges[_random.nextInt(_challenges.length)];
    } while (candidate == _previousChallenge);
    _previousChallenge = candidate;
    return candidate;
  }

  Future<void> _watchAdAndGetChallenge() async {
    if (_isWatchingAd) {
      return;
    }

    setState(() => _isWatchingAd = true);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AdDialog(seconds: 5),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isWatchingAd = false;
      _currentChallenge = _pickChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('✅ Building ChallengeScreen for ${widget.playerName}');
    }
    
    return MineQuestScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MinecraftAnimation(height: 120),
          const SizedBox(height: 16),
          Text(
            'Cześć, ${widget.playerName}!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Twoja wersja: ${widget.version}',
            style: const TextStyle(color: Color(0xFFB0BEC5)),
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF1B2322),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wymyśl mi wyzwanie',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _currentChallenge ??
                        'Obejrzyj reklamę, aby otrzymać kreatywne zadanie.',
                    style: const TextStyle(
                      color: Color(0xFFCFD8DC),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isWatchingAd ? null : _watchAdAndGetChallenge,
            icon: const Icon(Icons.smart_display),
            label: Text(
              _currentChallenge == null
                  ? 'Obejrzyj reklamę i odbierz wyzwanie'
                  : 'Obejrzyj reklamę i wymyśl nowe',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Po reklamie otrzymasz nowe, losowe zadanie do wykonania w świecie Minecraft.',
            style: TextStyle(color: Color(0xFF90A4AE)),
          ),
        ],
      ),
    );
  }
}

class MineQuestScaffold extends StatelessWidget {
  const MineQuestScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('✅ Building MineQuestScaffold');
    }
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1B18), Color(0xFF1D2B28)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class MinecraftAnimation extends StatefulWidget {
  const MinecraftAnimation({super.key, this.height = 160});

  final double height;

  @override
  State<MinecraftAnimation> createState() => _MinecraftAnimationState();
}

class _MinecraftAnimationState extends State<MinecraftAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('✅ Initializing MinecraftAnimation');
    }
    
    try {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat(reverse: true);
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ MinecraftAnimation controller created successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('🔴 Error initializing MinecraftAnimation: $e');
        print('Stack trace: $stackTrace');
      }
      _isInitialized = false;
    }
  }

  @override
  void dispose() {
    if (_isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If animation controller failed to initialize, show static version
    if (!_isInitialized) {
      return _buildStaticAnimation();
    }
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        try {
          final t = Curves.easeInOut.transform(_controller.value);
          return SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                _buildBlock(
                  color: const Color(0xFF6D4C41),
                  offset: Offset(20 + 18 * t, 20 + 8 * t),
                  size: 60,
                ),
                _buildBlock(
                  color: const Color(0xFF2E7D32),
                  offset: Offset(110 - 10 * t, 40 + 12 * t),
                  size: 50,
                ),
                _buildBlock(
                  color: const Color(0xFF0277BD),
                  offset: Offset(60 + 15 * t, 90 - 8 * t),
                  size: 45,
                ),
                _buildBlock(
                  color: const Color(0xFFFFB300),
                  offset: Offset(170 - 20 * t, 70 - 6 * t),
                  size: 40,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.7,
                    child: Text(
                      '⛏️',
                      style: TextStyle(fontSize: 32 + 6 * t),
                    ),
                  ),
                ),
              ],
            ),
          );
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print('🔴 Error rendering MinecraftAnimation: $e');
            print('Stack trace: $stackTrace');
          }
          return _buildStaticAnimation();
        }
      },
    );
  }

  Widget _buildStaticAnimation() {
    // Fallback static version without animation
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          _buildBlock(
            color: const Color(0xFF6D4C41),
            offset: const Offset(20, 20),
            size: 60,
          ),
          _buildBlock(
            color: const Color(0xFF2E7D32),
            offset: const Offset(110, 40),
            size: 50,
          ),
          _buildBlock(
            color: const Color(0xFF0277BD),
            offset: const Offset(60, 90),
            size: 45,
          ),
          _buildBlock(
            color: const Color(0xFFFFB300),
            offset: const Offset(170, 70),
            size: 40,
          ),
          const Positioned(
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.7,
              child: Text(
                '⛏️',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock({
    required Color color,
    required Offset offset,
    required double size,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
      ),
    );
  }
}

class AdDialog extends StatefulWidget {
  const AdDialog({super.key, required this.seconds});

  final int seconds;

  @override
  State<AdDialog> createState() => _AdDialogState();
}

class _AdDialogState extends State<AdDialog> {
  late int _secondsLeft;
  late int _totalSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _totalSeconds =
        max(kMinAdSeconds, min(widget.seconds, kMaxAdSeconds));
    _secondsLeft = _totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        setState(() => _secondsLeft = 0);
        timer.cancel();
        Navigator.of(context).pop();
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(_totalSeconds >= kMinAdSeconds);
    final progress = (_totalSeconds - _secondsLeft) / _totalSeconds;

    return AlertDialog(
      backgroundColor: const Color(0xFF1B2322),
      title: const Text('Reklama MineQuest'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 16),
          Text('Oglądasz reklamę... $_secondsLeft s'),
        ],
      ),
    );
  }
}
