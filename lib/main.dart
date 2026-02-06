import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String kEmptyChallengeMessage =
    'Brak dostępnych wyzwań. Spróbuj ponownie później.';
const int kMinAdSeconds = 1;
const int kMaxAdSeconds = 999;

// Minecraft Color Palette
class MinecraftColors {
  // Background gradients
  static const skyBlue = Color(0xFF87CEEB);
  static const grassGreen = Color(0xFF7EC850);
  static const dirtBrown = Color(0xFF8B4513);

  // Block colors
  static const grassTop = Color(0xFF7EC850);
  static const grassSide = Color(0xFF5C9C3B);
  static const dirt = Color(0xFF8B4513);
  static const stone = Color(0xFF7F7F7F);
  static const wood = Color(0xFF8B6914);
  static const diamond = Color(0xFF5DADE2);
  static const gold = Color(0xFFFFD700);

  // UI colors
  static const buttonGreen = Color(0xFF4CAF50);
  static const buttonHover = Color(0xFF66BB6A);
  static const cardBackground = Color(0xFFFFFFFF);
  static const borderDark = Color(0xFF2C2C2C);
  static const textWhite = Color(0xFFFFFFFF);
  static const textStroke = Color(0xFF000000);
}

void main() {
  runApp(const MineQuestApp());
}

class MineQuestApp extends StatelessWidget {
  const MineQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MineQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MinecraftColors.grassGreen,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: MinecraftColors.skyBlue,
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().copyWith(
          headlineMedium: GoogleFonts.pressStart2p(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: MinecraftColors.textWhite,
          ),
          titleLarge: GoogleFonts.pressStart2p(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: MinecraftColors.textWhite,
          ),
          bodyMedium: GoogleFonts.pressStart2p(
            fontSize: 10,
            color: MinecraftColors.textWhite,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// 3D Grass Block Widget
class GrassBlock3D extends StatefulWidget {
  const GrassBlock3D({super.key, this.size = 120, this.animate = true});

  final double size;
  final bool animate;

  @override
  State<GrassBlock3D> createState() => _GrassBlock3DState();
}

class _GrassBlock3DState extends State<GrassBlock3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
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
        final bounceOffset = widget.animate ? sin(_controller.value * pi * 2) * 8 : 0.0;
        
        return Transform.translate(
          offset: Offset(0, bounceOffset),
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-0.5)
              ..rotateY(0.8),
            alignment: Alignment.center,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                children: [
                  // Top face (grass)
                  Positioned(
                    left: widget.size * 0.25,
                    top: 0,
                    child: Transform(
                      transform: Matrix4.identity()..rotateX(-1.3),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: widget.size * 0.7,
                        height: widget.size * 0.7,
                        decoration: BoxDecoration(
                          color: MinecraftColors.grassTop,
                          border: Border.all(
                            color: MinecraftColors.borderDark,
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: GrassTexturePainter(),
                        ),
                      ),
                    ),
                  ),
                  // Front face (dirt)
                  Positioned(
                    left: widget.size * 0.25,
                    bottom: 0,
                    child: Container(
                      width: widget.size * 0.7,
                      height: widget.size * 0.7,
                      decoration: BoxDecoration(
                        color: MinecraftColors.dirt,
                        border: Border.all(
                          color: MinecraftColors.borderDark,
                          width: 2,
                        ),
                      ),
                      child: CustomPaint(
                        painter: DirtTexturePainter(),
                      ),
                    ),
                  ),
                  // Side face (gradient)
                  Positioned(
                    right: 0,
                    bottom: widget.size * 0.15,
                    child: Transform(
                      transform: Matrix4.identity()..rotateY(-1.3),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: widget.size * 0.7,
                        height: widget.size * 0.7,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [MinecraftColors.grassSide, MinecraftColors.dirt],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          border: Border.all(
                            color: MinecraftColors.borderDark,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
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

// Grass Texture Painter
class GrassTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = Random(42);
    
    for (int i = 0; i < 30; i++) {
      paint.color = random.nextBool() 
          ? const Color(0xFF6BA83E) 
          : const Color(0xFF8FD85C);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawRect(
        Rect.fromLTWH(x, y, size.width / 15, size.height / 15),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dirt Texture Painter
class DirtTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = Random(24);
    
    for (int i = 0; i < 25; i++) {
      paint.color = random.nextBool() 
          ? const Color(0xFF6B3410) 
          : const Color(0xFFA0522D);
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawRect(
        Rect.fromLTWH(x, y, size.width / 12, size.height / 12),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Particle System
class ParticleSystem extends StatefulWidget {
  const ParticleSystem({super.key});

  @override
  State<ParticleSystem> createState() => _ParticleSystemState();
}

class _ParticleSystemState extends State<ParticleSystem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Create particles
    for (int i = 0; i < 12; i++) {
      _particles.add(Particle(
        color: _getRandomBlockColor(),
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 15 + _random.nextDouble() * 10,
        speed: 0.0002 + _random.nextDouble() * 0.0003,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    )..repeat();
  }

  Color _getRandomBlockColor() {
    final colors = [
      MinecraftColors.grassTop,
      MinecraftColors.dirt,
      MinecraftColors.stone,
      MinecraftColors.wood,
      MinecraftColors.diamond,
      MinecraftColors.gold,
    ];
    return colors[_random.nextInt(colors.length)];
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
        return CustomPaint(
          painter: ParticlePainter(_particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  final Color color;
  final double x;
  double y;
  final double size;
  final double speed;

  Particle({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update position
      var y = (particle.y - particle.speed * animationValue * 100) % 1.2;
      if (y < -0.2) y += 1.2;

      final paint = Paint()
        ..color = particle.color.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final yPos = y * size.height;

      // Draw a small cube
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, yPos, particle.size, particle.size),
          const Radius.circular(2),
        ),
        paint,
      );

      // Add border
      paint
        ..color = MinecraftColors.borderDark.withOpacity(0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, yPos, particle.size, particle.size),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Minecraft-style Button
class MinecraftButton extends StatefulWidget {
  const MinecraftButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.color = MinecraftColors.buttonGreen,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final IconData? icon;
  final Color color;

  @override
  State<MinecraftButton> createState() => _MinecraftButtonState();
}

class _MinecraftButtonState extends State<MinecraftButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final scale = 1.0 + (_isHovered ? 0.05 : 0.0) - _bounceController.value * 0.05;
          
          return Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: widget.onPressed != null ? _handleTap : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: widget.onPressed != null
                      ? widget.color
                      : widget.color.withOpacity(0.5),
                  border: Border.all(
                    color: MinecraftColors.borderDark,
                    width: 4,
                  ),
                  boxShadow: widget.onPressed != null
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(4, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        color: MinecraftColors.textWhite,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                    ],
                    DefaultTextStyle(
                      style: GoogleFonts.pressStart2p(
                        fontSize: 12,
                        color: MinecraftColors.textWhite,
                        shadows: [
                          const Shadow(
                            color: MinecraftColors.textStroke,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Confetti Effect
class ConfettiEffect extends StatefulWidget {
  const ConfettiEffect({super.key});

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Create confetti particles
    for (int i = 0; i < 30; i++) {
      _particles.add(ConfettiParticle(
        color: _getRandomColor(),
        x: 0.5,
        y: 0.5,
        vx: (_random.nextDouble() - 0.5) * 0.02,
        vy: -_random.nextDouble() * 0.015,
        size: 8 + _random.nextDouble() * 8,
        rotation: _random.nextDouble() * pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.2,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..forward().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  Color _getRandomColor() {
    final colors = [
      MinecraftColors.gold,
      MinecraftColors.diamond,
      MinecraftColors.grassTop,
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFE66D),
    ];
    return colors[_random.nextInt(colors.length)];
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
        return CustomPaint(
          painter: ConfettiPainter(_particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class ConfettiParticle {
  final Color color;
  double x;
  double y;
  final double vx;
  double vy;
  final double size;
  double rotation;
  final double rotationSpeed;

  ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double animationValue;

  ConfettiPainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.vy += 0.0005; // gravity
      particle.rotation += particle.rotationSpeed;

      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - animationValue * 0.5);

      canvas.save();
      canvas.translate(
        particle.x * size.width,
        particle.y * size.height,
      );
      canvas.rotate(particle.rotation);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Large animated 3D grass block
          const GrassBlock3D(size: 200),
          const SizedBox(height: 32),
          // MineQuest title with stroke effect
          Text(
            '🟩 MINEQUEST 🟩',
            style: GoogleFonts.pressStart2p(
              fontSize: 28,
              color: MinecraftColors.grassGreen,
              shadows: [
                const Shadow(
                  color: MinecraftColors.textStroke,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Subtitle
          Text(
            'Twoja codzienna dawka\nminecraftowych wyzwań',
            style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: MinecraftColors.textWhite,
              shadows: const [
                Shadow(
                  color: MinecraftColors.textStroke,
                  offset: Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // Start button
          MinecraftButton(
            onPressed: () {
              Navigator.of(context).push(
                _createSlideTransition(const PlayerSetupScreen()),
              );
            },
            icon: Icons.play_arrow,
            child: const Text('ROZPOCZNIJ\nPRZYGODĘ'),
          ),
          const SizedBox(height: 32),
          // Footer text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💎', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Animacje inspirowane\nświatem Minecrafta',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 10,
                    color: MinecraftColors.textWhite,
                    shadows: const [
                      Shadow(
                        color: MinecraftColors.textStroke,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              const Text('💎', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
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
        SnackBar(
          content: Text(
            'Podaj imię i wersję, aby ruszyć dalej.',
            style: GoogleFonts.pressStart2p(fontSize: 8),
          ),
          backgroundColor: MinecraftColors.dirt,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      _createSlideTransition(
        ChallengeScreen(
          playerName: name,
          version: _selectedVersion!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Small animated blocks at the top
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                GrassBlock3D(size: 60, animate: false),
                GrassBlock3D(size: 60, animate: false),
                GrassBlock3D(size: 60, animate: false),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '📝 TWOJE DANE',
            style: GoogleFonts.pressStart2p(
              fontSize: 20,
              color: MinecraftColors.textWhite,
              shadows: const [
                Shadow(
                  color: MinecraftColors.textStroke,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Name input with Minecraft style
          Container(
            decoration: BoxDecoration(
              color: MinecraftColors.cardBackground.withOpacity(0.95),
              border: Border.all(
                color: MinecraftColors.borderDark,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _nameController,
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: '👤 Twoje imię',
                labelStyle: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(height: 20),
          // Version dropdown with Minecraft style
          Container(
            decoration: BoxDecoration(
              color: MinecraftColors.cardBackground.withOpacity(0.95),
              border: Border.all(
                color: MinecraftColors.borderDark,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedVersion,
              items: _versions
                  .map(
                    (version) => DropdownMenuItem(
                      value: version,
                      child: Text(
                        version,
                        style: GoogleFonts.pressStart2p(fontSize: 10),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _selectedVersion = value),
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: '🎮 Wersja',
                labelStyle: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 32),
          MinecraftButton(
            onPressed: _continue,
            icon: Icons.check,
            child: const Text('DALEJ'),
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

    // Show confetti effect
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => const ConfettiEffect(),
    );

    setState(() {
      _isWatchingAd = false;
      _currentChallenge = _pickChallenge();
    });
  }

  String _getChallengeIcon() {
    if (_currentChallenge == null) return '🎮';
    if (_currentChallenge!.contains('zoo') || _currentChallenge!.contains('pand')) return '🐼';
    if (_currentChallenge!.contains('portal') || _currentChallenge!.contains('Nether')) return '🔥';
    if (_currentChallenge!.contains('pszcz') || _currentChallenge!.contains('kwiat')) return '🌸';
    if (_currentChallenge!.contains('wiosk') || _currentChallenge!.contains('drze')) return '🌳';
    if (_currentChallenge!.contains('podziemn') || _currentChallenge!.contains('bazę')) return '⛏️';
    if (_currentChallenge!.contains('fortec') || _currentChallenge!.contains('obsydian')) return '🗡️';
    if (_currentChallenge!.contains('lod') || _currentChallenge!.contains('łodzi')) return '🧊';
    if (_currentChallenge!.contains('pixel') || _currentChallenge!.contains('creeper')) return '💚';
    return '💎';
  }

  @override
  Widget build(BuildContext context) {
    return MineQuestScaffold(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Small animated blocks at the top
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                GrassBlock3D(size: 50, animate: true),
                GrassBlock3D(size: 50, animate: true),
                GrassBlock3D(size: 50, animate: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '👋 Cześć, ${widget.playerName}!',
            style: GoogleFonts.pressStart2p(
              fontSize: 16,
              color: MinecraftColors.textWhite,
              shadows: const [
                Shadow(
                  color: MinecraftColors.textStroke,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '🎮 Wersja: ${widget.version}',
            style: GoogleFonts.pressStart2p(
              fontSize: 10,
              color: MinecraftColors.textWhite,
              shadows: const [
                Shadow(
                  color: MinecraftColors.textStroke,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Challenge card with thick border
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: MinecraftColors.cardBackground.withOpacity(0.95),
              border: Border.all(
                color: MinecraftColors.borderDark,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(6, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getChallengeIcon(),
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'TWOJE WYZWANIE',
                        style: GoogleFonts.pressStart2p(
                          fontSize: 14,
                          color: MinecraftColors.grassGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: MinecraftColors.borderDark,
                ),
                const SizedBox(height: 16),
                Text(
                  _currentChallenge ??
                      'Obejrzyj reklamę, aby otrzymać kreatywne zadanie.',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 11,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          MinecraftButton(
            onPressed: _isWatchingAd ? null : _watchAdAndGetChallenge,
            icon: Icons.smart_display,
            color: const Color(0xFF9C27B0), // Purple for ad button
            child: Text(
              _currentChallenge == null
                  ? '📺 OBEJRZYJ\nREKLAMĘ'
                  : '📺 NOWE\nWYZWANIE',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MinecraftColors.cardBackground.withOpacity(0.8),
              border: Border.all(
                color: MinecraftColors.borderDark,
                width: 3,
              ),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Po reklamie otrzymasz nowe, losowe zadanie',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 8,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MinecraftColors.skyBlue,
              MinecraftColors.grassGreen,
              MinecraftColors.dirtBrown,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Particle system in background
            const Positioned.fill(
              child: ParticleSystem(),
            ),
            // Content
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

// Custom Page Transition
PageRouteBuilder _createSlideTransition(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      var fadeTween = Tween<double>(begin: 0.0, end: 1.0);
      var fadeAnimation = animation.drive(fadeTween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
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
    final progressPercent = (progress * 100).toInt();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: MinecraftColors.cardBackground,
          border: Border.all(
            color: MinecraftColors.borderDark,
            width: 5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(8, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📺 Reklama MineQuest',
              style: GoogleFonts.pressStart2p(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // XP Bar style progress
            Stack(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(
                      color: MinecraftColors.borderDark,
                      width: 3,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 30,
                  width: MediaQuery.of(context).size.width * 0.6 * progress,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7EC850), // Grass green
                        Color(0xFF5C9C3B),
                      ],
                    ),
                    border: Border.all(
                      color: MinecraftColors.borderDark,
                      width: 3,
                    ),
                  ),
                ),
                Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(
                    '$progressPercent%',
                    style: GoogleFonts.pressStart2p(
                      fontSize: 10,
                      color: MinecraftColors.textWhite,
                      shadows: const [
                        Shadow(
                          color: MinecraftColors.textStroke,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⏱️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  'Oglądasz reklamę... $_secondsLeft s',
                  style: GoogleFonts.pressStart2p(
                    fontSize: 10,
                    color: Colors.black87,
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
