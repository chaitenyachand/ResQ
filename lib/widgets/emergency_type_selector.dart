import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/emergency_type.dart';

class EmergencyTypeSelector extends StatelessWidget {
  final ValueChanged<EmergencyType> onSelect;

  const EmergencyTypeSelector({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'WHAT’S THE EMERGENCY?',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _EmergencyButton(
            label: 'FIRE',
            color: const Color(0xFFFF3B30), // Red/Orange
            icon: Icons.local_fire_department,
            onTap: () => onSelect(EmergencyType.fire),
          ),
          const SizedBox(height: 16),
          _EmergencyButton(
            label: 'MEDICAL',
            color: const Color(0xFF007AFF), // Blue
            icon: Icons.medical_services,
            onTap: () => onSelect(EmergencyType.medical),
          ),
          const SizedBox(height: 16),
          _EmergencyButton(
            label: 'SECURITY',
            color: const Color(0xFF34C759), // Green
            icon: Icons.shield,
            onTap: () => onSelect(EmergencyType.security),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => onSelect(EmergencyType.general),
            child: Text(
              'Other / Not Sure',
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _EmergencyButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80, // Large height for easy tapping
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
