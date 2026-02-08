import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../utils/sound_helper.dart';

import '../models/emergency_type.dart';

class ActiveEmergencyScreen extends StatefulWidget {
  final EmergencyType type;
  const ActiveEmergencyScreen({super.key, required this.type});

  @override
  State<ActiveEmergencyScreen> createState() => _ActiveEmergencyScreenState();
}

class _ActiveEmergencyScreenState extends State<ActiveEmergencyScreen> {
  Color _getEmergencyColor() {
    switch (widget.type) {
      case EmergencyType.fire:
        return Colors.orangeAccent;
      case EmergencyType.medical:
        return Colors.blueAccent;
      case EmergencyType.security:
        return Colors.greenAccent;
      case EmergencyType.general:
        return AppTheme.primaryAction;
    }
  }

  IconData _getEmergencyIcon() {
    switch (widget.type) {
      case EmergencyType.fire:
        return Icons.local_fire_department;
      case EmergencyType.medical:
        return Icons.medical_services;
      case EmergencyType.security:
        return Icons.shield;
      case EmergencyType.general:
        return Icons.warning_amber_rounded;
    }
  }

  String _getEmergencyText() {
    switch (widget.type) {
      case EmergencyType.fire:
        return 'FIRE ALERT SENT';
      case EmergencyType.medical:
        return 'MEDICAL ALERT SENT';
      case EmergencyType.security:
        return 'SECURITY ALERT SENT';
      case EmergencyType.general:
        return 'ALERT SENT';
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergencyColor = _getEmergencyColor();
    final emergencyIcon = _getEmergencyIcon();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Mock Map Background
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: CustomPaint(painter: MockMapPainter()),
            ),
          ),

          // Top Status Card
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: emergencyColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(emergencyIcon, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      _getEmergencyText(),
                      style: AppTheme.textTheme.displayMedium?.copyWith(
                        fontSize: 24,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ).animate().shake(duration: 500.ms),
          ),

          // User Pin (Center)
          Center(
            child:
                Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: emergencyColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: emergencyColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.5, 1.5),
                    )
                    .fadeOut(),
          ),

          // Responders Moving to Center (Mock Animation)
          // Just verifying visual hierarchy, static animation for fidelity
          Positioned(
            top: 250,
            left: 80,
            child: const _ResponderDot()
                .animate()
                .move(
                  duration: 3.seconds,
                  begin: const Offset(-50, -50),
                  end: const Offset(50, 80),
                )
                .fadeIn(),
          ),
          Positioned(
            bottom: 300,
            right: 80,
            child: const _ResponderDot().animate().move(
              duration: 4.seconds,
              begin: const Offset(50, 50),
              end: const Offset(-40, -60),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2C2C2E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.people,
                              color: AppTheme.accent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3 Neighbors are on the way',
                                style: AppTheme.textTheme.bodyLarge,
                              ),
                              Text(
                                'Estimated Arrival: 2 mins',
                                style: AppTheme.textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.safety,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // I AM SAFE Slider/Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.safety,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async {
                            // Cancel Alarm
                            await SoundManager.stop();
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'I AM SAFE (CANCEL ALARM)',
                            style: AppTheme.textTheme.labelLarge?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _ResponderDot extends StatelessWidget {
  const _ResponderDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: AppTheme.primaryAction,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryAction,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

class MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw random grid lines to simulate streets
    final path = Path();
    for (double i = 0; i < size.width; i += 60) {
      path.moveTo(i, 0);
      path.lineTo(i, size.height);
    }
    for (double i = 0; i < size.height; i += 60) {
      path.moveTo(0, i);
      path.lineTo(size.width, i);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
