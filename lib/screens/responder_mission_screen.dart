import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'active_emergency_screen.dart'; // Reuse mock map

class ResponderMissionScreen extends StatefulWidget {
  const ResponderMissionScreen({super.key});

  @override
  State<ResponderMissionScreen> createState() => _ResponderMissionScreenState();
}

class _ResponderMissionScreenState extends State<ResponderMissionScreen> {
  bool isFlashlightOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Map Background (Reusable or similar to ActiveEmergency)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1A1A1A),
              child: CustomPaint(
                painter: MockMapPainter(), // Reuse from ActiveEmergencyScreen
              ),
            ),
          ),

          // Route Line (Mock)
          Positioned.fill(child: CustomPaint(painter: RoutePainter())),

          // Top Warning Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: const BoxDecoration(color: AppTheme.warning),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'En Route to Medical Emergency',
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '1:00',
                      style: AppTheme.textTheme.displayMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // User Location Pin (Moving) - Static for UI
          Positioned(
            bottom: 300,
            left: 150,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // Flashlight FAB
          Positioned(
            right: 20,
            bottom: 300, // Above drawer
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isFlashlightOn = !isFlashlightOn;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFlashlightOn ? 'Flashlight ON' : 'Flashlight OFF',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              backgroundColor: isFlashlightOn
                  ? Colors.white
                  : const Color(0xFF2C2C2E),
              child: Icon(
                isFlashlightOn ? Icons.flashlight_on : Icons.flashlight_off,
                color: isFlashlightOn ? Colors.black : Colors.white,
              ),
            ),
          ),

          // Bottom Drawer (DraggableScrollableSheet usually, but using fixed for simplicity)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black54)],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            indicatorColor: AppTheme.accent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: "Team (3)"),
                              Tab(text: "Checklist"),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // Tab 1: Team
                                ListView(
                                  padding: const EdgeInsets.all(16),
                                  children: const [
                                    _ResponderTile(
                                      name: 'Rahul (CPR Certified)',
                                      distance: '50m away',
                                      color: Colors.green,
                                    ),
                                    _ResponderTile(
                                      name: 'Sarah (First Aid)',
                                      distance: '120m away',
                                      color: Colors.blue,
                                    ),
                                    _ResponderTile(
                                      name: 'Mike',
                                      distance: 'En route',
                                      color: Colors.orange,
                                    ),
                                  ],
                                ),
                                // Tab 2: Checklist
                                ListView(
                                  padding: const EdgeInsets.all(16),
                                  children: const [
                                    _ChecklistItem(label: 'Check Scene Safety'),
                                    _ChecklistItem(
                                      label: 'Check Pulse / Breathing',
                                    ),
                                    _ChecklistItem(
                                      label: 'Call Ambulance (108)',
                                    ),
                                    _ChecklistItem(label: 'Clear Crowd'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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

class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.5); // Center
    // Draw a path to the user/destination
    // Mock path
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.4,
      size.width * 0.5 + 20, // Destination approx
      size.height * 0.5 - 150,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResponderTile extends StatelessWidget {
  final String name;
  final String distance;
  final Color color;

  const _ResponderTile({
    required this.name,
    required this.distance,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Text(
          name[0],
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(distance, style: const TextStyle(color: Colors.grey)),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.phone, size: 16, color: color),
      ),
    );
  }
}

class _ChecklistItem extends StatefulWidget {
  final String label;
  const _ChecklistItem({required this.label});

  @override
  State<_ChecklistItem> createState() => _ChecklistItemState();
}

class _ChecklistItemState extends State<_ChecklistItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.white54),
      child: CheckboxListTile(
        title: Text(
          widget.label,
          style: TextStyle(
            color: isChecked ? Colors.white30 : Colors.white,
            decoration: isChecked ? TextDecoration.lineThrough : null,
          ),
        ),
        value: isChecked,
        onChanged: (val) {
          setState(() {
            isChecked = val ?? false;
          });
        },
        activeColor: AppTheme.safety,
        checkColor: Colors.black,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
