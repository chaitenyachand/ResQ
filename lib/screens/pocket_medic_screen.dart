import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class PocketMedicScreen extends StatefulWidget {
  const PocketMedicScreen({super.key});

  @override
  State<PocketMedicScreen> createState() => _PocketMedicScreenState();
}

class _PocketMedicScreenState extends State<PocketMedicScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  final List<Map<String, dynamic>> _guides = [
    {
      'title': 'CPR: Chest Compressions',
      'headline': 'Push Hard & Fast',
      'steps': [
        '1. Place hands in center of chest.',
        '2. Push down 2 inches deep.',
        '3. 100-120 compressions/min.',
        '4. Allow chest to recoil fully.',
      ],
      'icon': Icons.monitor_heart,
      'color': AppTheme.primaryAction,
    },
    {
      'title': 'Severe Bleeding',
      'headline': 'Apply Direct Pressure',
      'steps': [
        '1. Cover wound with clean cloth.',
        '2. Apply firm, steady pressure.',
        '3. Elevate injury if possible.',
        '4. Do not remove soaked cloth.',
      ],
      'icon': Icons.water_drop,
      'color': AppTheme.primaryAction, // Maintaining emergency red
    },
    {
      'title': 'Choking (Adult)',
      'headline': 'Heimlich Maneuver',
      'steps': [
        '1. Stand behind person.',
        '2. Wrap arms around waist.',
        '3. Make fist above navel.',
        '4. Thrust in and up rapidly.',
      ],
      'icon': Icons.accessibility_new,
      'color': Colors.orange,
    },
    {
      'title': 'Burn Treatment',
      'headline': 'Cool & Cover',
      'steps': [
        '1. Cool with running water (10m).',
        '2. Remove tight items/jewelry.',
        '3. Cover with sterile gauze.',
        '4. Do NOT use ice or butter.',
      ],
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          'Pocket Medic',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _guides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? _guides[index]['color']
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Carousel
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _guides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final guide = _guides[index];
                final isCurrent = index == _currentPage;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isCurrent
                          ? (guide['color'] as Color).withOpacity(0.5)
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: (guide['color'] as Color).withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: (guide['color'] as Color).withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child:
                              Icon(
                                    guide['icon'] as IconData,
                                    size: 80,
                                    color: guide['color'] as Color,
                                  )
                                  .animate(target: isCurrent ? 1 : 0)
                                  .scale(
                                    duration: 600.ms,
                                    curve: Curves.elasticOut,
                                  ),
                        ),
                      ),
                      // Content Section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (guide['title'] as String).toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: guide['color'] as Color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                guide['headline'] as String,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: (guide['steps'] as List).length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, stepIndex) {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 4),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white54,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            (guide['steps'] as List)[stepIndex]
                                                as String,
                                            style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontSize: 18,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Navigation Hints
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: _currentPage > 0 ? Colors.white54 : Colors.transparent,
                ),
                const SizedBox(width: 32),
                Text(
                  'SWIPE FOR MORE',
                  style: GoogleFonts.inter(
                    color: Colors.white24,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 32),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: _currentPage < _guides.length - 1
                      ? Colors.white54
                      : Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
