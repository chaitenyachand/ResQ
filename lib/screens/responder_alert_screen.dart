import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'responder_mission_screen.dart'; // Forward reference for next screen

class ResponderAlertScreen extends StatelessWidget {
  const ResponderAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Blurred Background (Simulated)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1E1E1E),
              // We could use ImageFiltered for blur if we had an image,
              // but solid color with overlay is fine for high-contrast safety look.
            ),
          ),
          Positioned.fill(
            child: Container(color: AppTheme.primaryAction.withOpacity(0.15)),
          ),

          // Alert Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Center Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.primaryAction,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryAction.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryAction,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.medical_services,
                                color: Colors.white,
                                size: 48,
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat())
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.1, 1.1),
                              duration: 800.ms,
                            )
                            .then()
                            .scale(
                              begin: const Offset(1.1, 1.1),
                              end: const Offset(1, 1),
                              duration: 800.ms,
                            ),

                        const SizedBox(height: 24),

                        Text(
                          'CRITICAL MEDICAL ALERT',
                          style: AppTheme.textTheme.displayMedium?.copyWith(
                            color: AppTheme.primaryAction,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '200 meters away',
                          style: AppTheme.textTheme.displayMedium?.copyWith(
                            fontSize: 28,
                          ),
                        ),
                        Text(
                          '(Approx 1 min run)',
                          style: AppTheme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppTheme.accent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tower 4, Apt 302',
                              style: AppTheme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

                  const Spacer(),

                  // Slide to Accept (Simulated with Button for now)
                  // Implementing a real slider takes more code, but design system asked for slider bar.
                  // I'll make it look like a slider.
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResponderMissionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppTheme.safety),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              'SLIDE TO ACCEPT',
                              style: AppTheme.textTheme.labelLarge?.copyWith(
                                color: AppTheme.safety,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 4,
                            top: 4,
                            bottom: 4,
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                color: AppTheme.safety,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Decline / Cannot Help',
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white54,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
