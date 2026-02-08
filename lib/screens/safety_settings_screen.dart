import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/sound_helper.dart';

class SafetySettingsScreen extends StatefulWidget {
  const SafetySettingsScreen({super.key});

  @override
  State<SafetySettingsScreen> createState() => _SafetySettingsScreenState();
}

class _SafetySettingsScreenState extends State<SafetySettingsScreen> {
  bool _ghostModeEnabled = false;
  bool _isSafeWalkActive = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGhostMode();
  }

  Future<void> _loadGhostMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ghostModeEnabled = prefs.getBool('ghost_mode_enabled') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleGhostMode(bool value) async {
    setState(() {
      _ghostModeEnabled = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ghost_mode_enabled', value);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Safety & Privacy',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Privacy Shield (Ghost Mode)
            Text(
              'PRIVACY SHIELD',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _ghostModeEnabled ? AppTheme.safety : Colors.white10,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ghost Mode',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Hide my exact home location until I accept a mission.',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _ghostModeEnabled,
                          onChanged: _toggleGhostMode,
                          activeColor: AppTheme.safety,
                          activeTrackColor: AppTheme.safety.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                  // Visual: Map Preview
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Pseudo-Map Background
                        Positioned.fill(
                          child: CustomPaint(painter: _MapGridPainter()),
                        ),
                        // Location Indicator
                        Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: _ghostModeEnabled ? 80 : 20,
                            height: _ghostModeEnabled ? 80 : 20,
                            decoration: BoxDecoration(
                              color: _ghostModeEnabled
                                  ? AppTheme.safety.withOpacity(0.2)
                                  : AppTheme.accent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _ghostModeEnabled
                                    ? AppTheme.safety.withOpacity(0.5)
                                    : Colors.white,
                                width: 2,
                              ),
                              boxShadow: _ghostModeEnabled
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppTheme.accent.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                            ),
                            child: _ghostModeEnabled
                                ? Center(
                                    child: Icon(
                                      Icons.security,
                                      color: AppTheme.safety.withOpacity(0.8),
                                      size: 32,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Section 2: Dead Man's Switch (Safe Walk Mode)
            Text(
              "DEAD MAN'S SWITCH",
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.warning.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_walk,
                          color: AppTheme.warning,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Safe Walk Mode',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Release triggers alarm in 5s',
                              style: GoogleFonts.inter(
                                color: AppTheme.warning, // Caution Yellow
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Large Pill Button
                  GestureDetector(
                        onTapDown: (_) =>
                            setState(() => _isSafeWalkActive = true),
                        onTapUp: (_) =>
                            setState(() => _isSafeWalkActive = false),
                        onTapCancel: () =>
                            setState(() => _isSafeWalkActive = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            color: _isSafeWalkActive
                                ? AppTheme.warning
                                : AppTheme.warning.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppTheme.warning,
                              width: 2,
                            ),
                            boxShadow: _isSafeWalkActive
                                ? [
                                    BoxShadow(
                                      color: AppTheme.warning.withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              _isSafeWalkActive ? 'ARMED' : 'HOLD UNTIL SAFE',
                              style: GoogleFonts.inter(
                                color: _isSafeWalkActive
                                    ? Colors.black
                                    : AppTheme.warning,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      )
                      .animate(target: _isSafeWalkActive ? 1 : 0)
                      .shake(hz: 8, curve: Curves.easeInOut),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Section 3: Developer / Testing
            Text(
              'DEVELOPER OPTIONS',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                await SoundManager.playClick();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('seen_onboarding');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Onboarding Reset. Restart app to see it.'),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.restart_alt, color: Colors.white),
                    const SizedBox(width: 16),
                    Text(
                      'Reset Onboarding',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const gridSize = 20.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
