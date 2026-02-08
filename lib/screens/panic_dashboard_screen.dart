import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/sound_helper.dart';

import '../theme/app_theme.dart';
import 'active_emergency_screen.dart';
import 'map_screen.dart'; // Import for navigation
import 'pocket_medic_screen.dart';
import '../models/emergency_type.dart';
import '../widgets/emergency_type_selector.dart';

class PanicDashboardScreen extends StatefulWidget {
  const PanicDashboardScreen({super.key});

  @override
  State<PanicDashboardScreen> createState() => _PanicDashboardScreenState();
}

class _PanicDashboardScreenState extends State<PanicDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _gridController;

  // Responder Mode
  bool _isResponderMode = false;

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  void _showEmergencyTypeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => EmergencyTypeSelector(
        onSelect: (type) {
          Navigator.pop(context); // Close sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActiveEmergencyScreen(type: type),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Animated Grid Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gridController,
              builder: (context, child) {
                return CustomPaint(
                  painter: DashboardGridPainter(offset: _gridController.value),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header (Switch + Status)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Responder Toggle
                      Row(
                        children: [
                          Switch(
                            value: _isResponderMode,
                            onChanged: (val) {
                              setState(() {
                                _isResponderMode = val;
                              });
                            },
                            activeColor: AppTheme.primaryAction,
                          ),
                          Text(
                            'Responder View',
                            style: AppTheme.textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),

                      // Status Widget
                      if (!_isResponderMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.safety.withOpacity(0.1),
                            border: Border.all(
                              color: AppTheme.safety.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.safety,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                  .animate(onPlay: (c) => c.repeat())
                                  .fadeIn(duration: 500.ms)
                                  .fadeOut(duration: 500.ms, delay: 500.ms),
                              const SizedBox(width: 8),
                              Text(
                                'MESH ACTIVE',
                                style: AppTheme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.safety,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Safe Walk Card (Dead Man's Switch)
                if (!_isResponderMode)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const SafeWalkButton(),
                  ),

                const Spacer(),

                // Main SOS Button / Beacon Toggle Centerpiece
                if (!_isResponderMode)
                  GestureDetector(
                    onTap: () {
                      // Optional: Feedback that it's a long press button
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Press and HOLD to activate SOS'),
                          duration: Duration(milliseconds: 1500),
                        ),
                      );
                    },
                    onLongPress: () {
                      SoundManager.playSiren();
                      HapticFeedback.heavyImpact();
                      _showEmergencyTypeSelector(context);
                    },
                    child:
                        Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const RadialGradient(
                                  colors: [
                                    Color(0xFFFF3B30),
                                    Color(0xFF8B0000),
                                  ],
                                  center: Alignment.center,
                                  radius: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryAction.withOpacity(
                                      0.4,
                                    ),
                                    blurRadius: 50,
                                    spreadRadius: 10,
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                    Text(
                                      'SOS',
                                      style: AppTheme.textTheme.displayLarge
                                          ?.copyWith(
                                            fontSize: 72,
                                            letterSpacing: 4,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      'PRESS & HOLD',
                                      style: AppTheme.textTheme.labelSmall
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scale(
                              duration: 2000.ms,
                              begin: const Offset(1, 1),
                              end: const Offset(1.05, 1.05),
                              curve: Curves.easeInOut,
                            ),
                  ),

                const Spacer(),

                // Action Buttons Grid (Police, Fire, Ambulance) - Bottom aligned
                if (!_isResponderMode)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ActionButton(
                          icon: Icons.local_police_outlined,
                          label: 'POLICE',
                          onTap: () async {
                            await SoundManager.playClick();
                          },
                        ),
                        _ActionButton(
                          icon: Icons.local_fire_department_outlined,
                          label: 'FIRE',
                          onTap: () async {
                            await SoundManager.playClick();
                          },
                        ),
                        _ActionButton(
                          icon: Icons.medical_services_outlined,
                          label: 'AMBULANCE',
                          onTap: () async {
                            await SoundManager.playClick();
                          },
                        ),
                        _ActionButton(
                          icon: Icons.monitor_heart_outlined,
                          label: '   POCKET    MEDIC',
                          onTap: () async {
                            await SoundManager.playClick();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PocketMedicScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Responder Mission Acceptance Overlay
          if (_isResponderMode)
            Positioned(
              left: 20,
              right: 20,
              bottom: 100, // Float above bottom nav
              child: _MissionAcceptanceCard(),
            ),
        ],
      ),
    );
  }
}

class SafeWalkButton extends StatefulWidget {
  const SafeWalkButton({super.key});

  @override
  State<SafeWalkButton> createState() => _SafeWalkButtonState();
}

class _SafeWalkButtonState extends State<SafeWalkButton> {
  bool _isSafeMode = false; // User holding button
  bool _isCountingDown = false; // Countdown active
  int _countdownValue = 5;
  Timer? _countdownTimer;

  // Visuals for Countdown Flashing
  Color _countdownColor = Colors.red;

  void _onLongPressStart(LongPressStartDetails details) {
    if (_isCountingDown) return;
    setState(() {
      _isSafeMode = true;
    });
    HapticFeedback.lightImpact();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    if (_isCountingDown) return;
    setState(() {
      _isSafeMode = false;
      _startCountdown();
    });
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdownValue = 5;
    });

    // Rapid flashing timer
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!_isCountingDown) {
        timer.cancel();
        return;
      }
      if (mounted) {
        setState(() {
          _countdownColor = _countdownColor == Colors.red
              ? Colors.grey[800]!
              : Colors.red;
        });
      }
    });

    // Seconds timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _countdownValue--;
      });

      if (_countdownValue > 0) {
        // Play tick sound (optional/placeholder)
        HapticFeedback.selectionClick();
      } else {
        // Timeout! Trigger Action
        _triggerAction();
        timer.cancel();
      }
    });
  }

  void _triggerAction() {
    setState(() {
      _isCountingDown = false;
    });

    // 1. Simulate SOS Trigger (Sound/Flash)
    SoundManager.playSiren();
    HapticFeedback.heavyImpact();

    // 2. Navigate to Map Screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );
  }

  void _cancelCountdown() {
    if (_isCountingDown) {
      _countdownTimer?.cancel();
      setState(() {
        _isCountingDown = false;
        _isSafeMode = false;
      });
      HapticFeedback.mediumImpact();
    }
  }

  // Also handle tap to cancel if user taps quickly during countdown
  void _onTap() {
    if (_isCountingDown) {
      _cancelCountdown();
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine appearance based on state
    Color background;
    if (_isCountingDown) {
      background = _countdownColor;
    } else if (_isSafeMode) {
      background = Colors.green[700]!;
    } else {
      background = Colors.transparent; // Gradient from inner container
    }

    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: background,
          gradient: (_isCountingDown || _isSafeMode)
              ? null
              : LinearGradient(
                  colors: [
                    Colors.teal.withOpacity(0.2),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isCountingDown
                ? Colors.redAccent
                : (_isSafeMode
                      ? Colors.greenAccent
                      : Colors.teal.withOpacity(0.3)),
            width: _isCountingDown ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isCountingDown
                  ? Colors.red.withOpacity(0.5)
                  : Colors.teal.withOpacity(0.1),
              blurRadius: _isCountingDown ? 20 : 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isSafeMode
                        ? Colors.white24
                        : Colors.teal.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isCountingDown
                        ? Icons.warning_amber_rounded
                        : (_isSafeMode ? Icons.shield : Icons.fingerprint),
                    color: _isSafeMode ? Colors.white : Colors.tealAccent,
                    size: 32,
                  ),
                )
                .animate(target: _isCountingDown ? 1 : 0)
                .shake(hz: 8), // Shake during countdown
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isCountingDown
                        ? 'RELEASED! TAP TO CANCEL'
                        : (_isSafeMode ? 'SAFE MODE ACTIVE' : 'SAFE WALK'),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    _isCountingDown
                        ? 'SOS in $_countdownValue seconds...'
                        : (_isSafeMode
                              ? 'Release to Trigger Alarm'
                              : 'Hold to Activate'),
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!_isCountingDown)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white24,
                size: 16,
              ),
            if (_isCountingDown)
              Text(
                '$_countdownValue',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MissionAcceptanceCard extends StatefulWidget {
  @override
  State<_MissionAcceptanceCard> createState() => _MissionAcceptanceCardState();
}

class _MissionAcceptanceCardState extends State<_MissionAcceptanceCard> {
  bool _isAccepted = false;

  Future<void> _handleAccept() async {
    await SoundManager.playSuccess();
    setState(() {
      _isAccepted = true;
    });
    // Optional: Navigate or show more details after delay
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isAccepted ? Colors.green : AppTheme.primaryAction,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isAccepted ? 'MISSION ACTIVE' : 'EMERGENCY ALERT',
                    style: GoogleFonts.inter(
                      color: _isAccepted
                          ? Colors.green
                          : AppTheme.primaryAction,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isAccepted ? 'Proceed to Location' : 'Victim Nearby (You)',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isAccepted ? Colors.green : AppTheme.primaryAction,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isAccepted ? Icons.check : Icons.near_me,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.straighten,
            label: 'Distance',
            value: '0m (It\'s you)',
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.medical_information,
            label: 'Medical',
            value: 'Diabetic',
          ),
          const SizedBox(height: 24),

          // Functional Accept Slider
          if (_isAccepted)
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.green),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'ACCEPTED',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn()
          else
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.primaryAction.withOpacity(0.2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      'SWIPE TO ACCEPT',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Dismissible(
                    key: const Key('accept_slider'),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => _handleAccept(),
                    confirmDismiss: (_) async {
                      await _handleAccept();
                      return false; // Don't actually remove the widget from tree via Dismissible
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryAction,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutBack);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 8),
        Text('$label: ', style: GoogleFonts.inter(color: Colors.white54)),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80, // Reduced width to fit 4 items
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTheme.textTheme.labelSmall?.copyWith(
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardGridPainter extends CustomPainter {
  final double offset;

  DashboardGridPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent.withOpacity(0.05)
      ..strokeWidth = 1;

    final double spacing = 40.0;
    final double move = offset * spacing;

    for (double i = -spacing; i < size.width + spacing; i += spacing) {
      canvas.drawLine(
        Offset(i + move % spacing, 0),
        Offset(i + move % spacing, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Vignette
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.2,
      colors: [
        Colors.transparent,
        AppTheme.background.withOpacity(0.8),
        AppTheme.background,
      ],
      stops: const [0.4, 0.8, 1.0],
    );

    final paintVignette = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paintVignette);
  }

  @override
  bool shouldRepaint(covariant DashboardGridPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
