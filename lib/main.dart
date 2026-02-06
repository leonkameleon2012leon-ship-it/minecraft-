import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

const String kEmptyChallengeMessage =
    'Brak dostępnych wyzwań. Spróbuj ponownie później.';
const int kMinAdSeconds = 1;
const int kMaxAdSeconds = 999;

void main() {
  runApp(const MineQuestApp());
}

class MineQuestApp extends StatelessWidget {
  const MineQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4CAF50), // Brighter Minecraft green
      brightness: Brightness.dark,
      primary: const Color(0xFF4CAF50),
      secondary: const Color(0xFF8D6E63), // Brown like dirt
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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 4,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 4,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MinecraftAnimation(height: 180),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'MineQuest',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 8),
                const Text('⛏️', style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Twoja codzienna dawka minecraftowych wyzwań.',
              style: TextStyle(fontSize: 16, color: Color(0xFFB0BEC5)),
            ),
            const SizedBox(height: 32),
            AnimatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PlayerSetupScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          )),
                          child: child,
                        ),
                      );
                    },
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
                    'Animacje inspirowane światem Minecrafta wprowadzą Cię w klimat. 🧱💎🔥',
                    style: TextStyle(color: Color(0xFFCFD8DC)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final List<String> _versions = const [
    'Java 1.21',
    'Java 1.20',
    'Bedrock 1.20',
    'Snapshot',
    'Modpack',
  ];
  String? _selectedVersion;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fadeController.dispose();
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChallengeScreen(
          playerName: name,
          version: _selectedVersion!,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.2, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MinecraftAnimation(height: 140),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Twoje dane',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 8),
                const Text('🪓', style: TextStyle(fontSize: 28)),
              ],
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
            AnimatedButton(
              onPressed: _continue,
              label: const Text('Dalej'),
            ),
          ],
        ),
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

class _ChallengeScreenState extends State<ChallengeScreen>
    with TickerProviderStateMixin {
  final Random _random = Random();
  final List<String> _challenges = const [
    'Zbuduj zoo dla pand i stwórz im bambusowy wybieg. 🐼',
    'Stwórz ukryty portal do Netheru w jaskini. 🔥',
    'Zaprojektuj farmę pszczół z kwiatową łąką. 🐝',
    'Zbuduj wioskę w koronach drzew z mostami linowymi. 🌳',
    'Wykop podziemną bazę z tajnym wejściem. ⛏️',
    'Zrób fortecę z obsydianu i wodospadami lawy. 🗡️',
    'Stwórz lodowy tor wyścigowy dla łodzi. ❄️',
    'Odtwórz pixel art z ulubionego creepera. 💚',
  ];

  String? _currentChallenge;
  String? _previousChallenge;
  bool _isWatchingAd = false;
  bool _showExplosion = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _explosionController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _explosionController.dispose();
    super.dispose();
  }

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

    // Show explosion animation
    setState(() {
      _showExplosion = true;
      _isWatchingAd = false;
    });

    _explosionController.forward(from: 0);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _showExplosion = false;
      _currentChallenge = _pickChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MinecraftAnimation(height: 120),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Cześć, ${widget.playerName}!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const Text('💎', style: TextStyle(fontSize: 28)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Twoja wersja: ${widget.version}',
                  style: const TextStyle(color: Color(0xFFB0BEC5)),
                ),
                const SizedBox(height: 20),
                MinecraftCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Wymyśl mi wyzwanie',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const Text('🧱', style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _currentChallenge ??
                              'Obejrzyj reklamę, aby otrzymać kreatywne zadanie. ⛏️',
                          key: ValueKey(_currentChallenge),
                          style: const TextStyle(
                            color: Color(0xFFCFD8DC),
                            height: 1.4,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedButton(
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
                  'Po reklamie otrzymasz nowe, losowe zadanie do wykonania w świecie Minecraft. 🔥',
                  style: TextStyle(color: Color(0xFF90A4AE)),
                ),
              ],
            ),
            if (_showExplosion)
              Positioned.fill(
                child: ExplosionEffect(controller: _explosionController),
              ),
          ],
        ),
      ),
    );
  }
}

class MineQuestScaffold extends StatelessWidget {
  const MineQuestScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A1612), // Darker green-black
              Color(0xFF1A2E26), // Dark green
              Color(0xFF2A3A32), // Medium green-brown
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: ParticleBackground()),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: child,
              ),
            ),
          ],
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_controller.value);
        return SizedBox(
          height: widget.height,
          child: Stack(
            children: [
              // Grass block
              _buildTexturedBlock(
                type: BlockType.grass,
                offset: Offset(20 + 18 * t, 20 + 8 * t),
                size: 60,
                rotation: 0.1 * t,
              ),
              // Stone block
              _buildTexturedBlock(
                type: BlockType.stone,
                offset: Offset(110 - 10 * t, 40 + 12 * t),
                size: 50,
                rotation: -0.1 * t,
              ),
              // Diamond block with glow
              _buildTexturedBlock(
                type: BlockType.diamond,
                offset: Offset(60 + 15 * t, 90 - 8 * t),
                size: 45,
                rotation: 0.15 * t,
                glow: true,
              ),
              // Wood block
              _buildTexturedBlock(
                type: BlockType.wood,
                offset: Offset(170 - 20 * t, 70 - 6 * t),
                size: 40,
                rotation: -0.12 * t,
              ),
              // Dirt block
              _buildTexturedBlock(
                type: BlockType.dirt,
                offset: Offset(200 + 10 * t, 15 + 5 * t),
                size: 35,
                rotation: 0.08 * t,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Transform.scale(
                  scale: 1 + 0.15 * t,
                  child: Opacity(
                    opacity: 0.7 + 0.2 * t,
                    child: const Text(
                      '⛏️',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTexturedBlock({
    required BlockType type,
    required Offset offset,
    required double size,
    double rotation = 0,
    bool glow = false,
  }) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
              if (glow)
                BoxShadow(
                  color: _getBlockColor(type).withOpacity(0.6),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: CustomPaint(
            painter: MinecraftBlockPainter(type: type),
          ),
        ),
      ),
    );
  }

  Color _getBlockColor(BlockType type) {
    switch (type) {
      case BlockType.grass:
        return const Color(0xFF4CAF50);
      case BlockType.dirt:
        return const Color(0xFF8D6E63);
      case BlockType.stone:
        return const Color(0xFF78909C);
      case BlockType.wood:
        return const Color(0xFFBCAAA4);
      case BlockType.diamond:
        return const Color(0xFF00BCD4);
    }
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

// Animated button with hover/tap effect
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.label,
  });

  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget label;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = true);
              _controller.forward();
            }
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              _controller.reverse();
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: widget.onPressed != null
          ? () {
              setState(() => _isPressed = false);
              _controller.reverse();
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.05);
          return Transform.scale(
            scale: scale,
            child: AbsorbPointer(
              child: FilledButton.icon(
                onPressed: widget.onPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: _isPressed
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.8)
                      : null,
                ),
                icon: widget.icon ?? const SizedBox.shrink(),
                label: widget.label,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Minecraft-styled card with frame
class MinecraftCard extends StatelessWidget {
  const MinecraftCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2322),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// Particle background effect
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Create particles
    for (int i = 0; i < 20; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.01 + _random.nextDouble() * 0.02,
        size: 2 + _random.nextDouble() * 3,
        opacity: 0.1 + _random.nextDouble() * 0.3,
      ));
    }

    _controller.addListener(_updateParticles);
  }

  void _updateParticles() {
    for (var particle in _particles) {
      particle.y -= particle.speed;
      if (particle.y < 0) {
        particle.y = 1.0;
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateParticles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles: List.from(_particles)),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = const Color(0xFF4CAF50).withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    // Compare particle positions to determine if repaint is needed
    if (oldDelegate.particles.length != particles.length) {
      return true;
    }
    for (int i = 0; i < particles.length; i++) {
      if (oldDelegate.particles[i].y != particles[i].y) {
        return true;
      }
    }
    return false;
  }
}

// Explosion effect for challenge generation
class ExplosionEffect extends StatelessWidget {
  const ExplosionEffect({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ExplosionPainter(progress: controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class ExplosionPainter extends CustomPainter {
  final double progress;

  ExplosionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.8;

    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;
      final radius = progress * maxRadius;
      final opacity = (1 - progress) * 0.6;

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFF4CAF50),
          const Color(0xFFFFB300),
          i / 12,
        )!
            .withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final offset = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawCircle(offset, 20 * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(ExplosionPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

// Block types enum
enum BlockType {
  grass,
  dirt,
  stone,
  wood,
  diamond,
}

// Custom painter for Minecraft block textures
class MinecraftBlockPainter extends CustomPainter {
  final BlockType type;

  MinecraftBlockPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case BlockType.grass:
        _paintGrassBlock(canvas, size);
        break;
      case BlockType.dirt:
        _paintDirtBlock(canvas, size);
        break;
      case BlockType.stone:
        _paintStoneBlock(canvas, size);
        break;
      case BlockType.wood:
        _paintWoodBlock(canvas, size);
        break;
      case BlockType.diamond:
        _paintDiamondBlock(canvas, size);
        break;
    }
  }

  void _paintGrassBlock(Canvas canvas, Size size) {
    // Green top
    final topPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.3),
      topPaint,
    );

    // Brown side
    final sidePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.3, size.width, size.height * 0.7),
      sidePaint,
    );

    // Texture lines
    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 1;
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(
        Offset(0, size.height * i / 4),
        Offset(size.width, size.height * i / 4),
        linePaint,
      );
      canvas.drawLine(
        Offset(size.width * i / 4, 0),
        Offset(size.width * i / 4, size.height),
        linePaint,
      );
    }
  }

  void _paintDirtBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add speckles
    final random = Random(42);
    final specklePaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 30; i++) {
      specklePaint.color = Color.lerp(
        const Color(0xFF8D6E63),
        const Color(0xFF5D4037),
        random.nextDouble(),
      )!;
      canvas.drawCircle(
        Offset(
          random.nextDouble() * size.width,
          random.nextDouble() * size.height,
        ),
        random.nextDouble() * 2 + 1,
        specklePaint,
      );
    }
  }

  void _paintStoneBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF78909C)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add cracks
    final crackPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.6);
    canvas.drawPath(path, crackPaint);
  }

  void _paintWoodBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Wood rings
    final ringPaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 1; i < 4; i++) {
      canvas.drawCircle(center, size.width * 0.1 * i, ringPaint);
    }
  }

  void _paintDiamondBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Diamond pattern
    final patternPaint = Paint()
      ..color = const Color(0xFF0097A7)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    canvas.drawPath(path, patternPaint);

    // Shine effect
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.3),
      size.width * 0.15,
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(MinecraftBlockPainter oldDelegate) => false;
}
