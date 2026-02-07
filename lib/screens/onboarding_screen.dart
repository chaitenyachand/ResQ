import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'WELCOME TO RESQ',
      'description':
          'The decentralized emergency response system powered by your community.',
      'icon': Icons.shield_outlined,
      'color': AppTheme.accent,
    },
    {
      'title': 'ONE-TAP SOS',
      'description':
          'Instantly alert nearby responders and guardians when you are in danger.',
      'icon': Icons.touch_app_outlined,
      'color': AppTheme.primaryAction,
    },
    {
      'title': 'COMMUNITY MESH',
      'description':
          'Join the neighborhood watch. Connect even when internet is down via Bluetooth mesh.',
      'icon': Icons.hub_outlined,
      'color': AppTheme.safety,
    },
    {
      'title': 'BE PREPARED',
      'description':
          'Access offline medical guides and keep your emergency info ready.',
      'icon': Icons.medical_services_outlined,
      'color': Colors.orange,
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: (page['color'] as Color).withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: (page['color'] as Color).withValues(
                                alpha: 0.5,
                              ),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 80,
                            color: page['color'] as Color,
                          ),
                        )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.easeOutBack)
                        .then()
                        .shimmer(duration: 1200.ms, color: Colors.white),

                    const SizedBox(height: 48),

                    Text(
                          page['title'] as String,
                          style: AppTheme.textTheme.displayMedium?.copyWith(
                            color: page['color'] as Color,
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .moveY(begin: 20, end: 0),

                    const SizedBox(height: 16),

                    Text(
                          page['description'] as String,
                          style: AppTheme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 400.ms)
                        .moveY(begin: 20, end: 0),
                  ],
                ),
              );
            },
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicators
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppTheme.accent
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Next/Skip Button
                Row(
                  children: [
                    if (_currentPage < _pages.length - 1)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'SKIP',
                          style: AppTheme.textTheme.labelLarge?.copyWith(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
