import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GuardianHubScreen extends StatelessWidget {
  const GuardianHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Guardian Hub',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Your Rank
            const _YourRankHeader(),
            const SizedBox(height: 30),

            // Leaderboard Section
            Text(
              'LEADERBOARD',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Leaderboard List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                // Mock data for demonstration
                return _LeaderboardTile(
                  rank: index + 1,
                  name: ['Rahul', 'Sarah', 'Mike', 'Priya', 'Arjun'][index],
                  points: [1250, 1100, 950, 800, 750][index],
                  avatarUrl:
                      'https://i.pravatar.cc/150?img=${index + 10}', // Placeholder logic
                  isVerified: index == 0 || index == 3, // Mock verification
                  isResponder: index < 2, // Mock responder status
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _YourRankHeader extends StatelessWidget {
  const _YourRankHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Glassmorphism effect
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT RANK',
                    style: GoogleFonts.inter(
                      color: Colors.white54,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.shield,
                        color: Color(0xFFFFD700),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Guardian Lvl 5',
                        style: GoogleFonts.orbitron(
                          // Gamified font
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  '1,250 PTS',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Level: Ranger',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '250 pts to go',
                    style: GoogleFonts.inter(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.8,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.tealAccent,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

class _LeaderboardTile extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String avatarUrl;
  final bool isVerified;
  final bool isResponder;

  const _LeaderboardTile({
    required this.rank,
    required this.name,
    required this.points,
    required this.avatarUrl,
    required this.isVerified,
    required this.isResponder,
  });

  Color _getRankColor() {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.white24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Glassmorphism container
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: rank <= 3 ? _getRankColor().withOpacity(0.3) : Colors.white10,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left: Rank & Avatar
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white12,
                    child: Text(
                      name[0],
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // In a real app, use NetworkImage(avatarUrl)
                  ),
                ),
                if (rank <= 3)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: _getRankColor(), width: 1.5),
                      ),
                      child: Text(
                        '#$rank',
                        style: GoogleFonts.inter(
                          color: _getRankColor(),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Middle: Name & Points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Colors.tealAccent,
                        size: 14,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$points pts',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: Skill Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isVerified)
                _SkillIcon(
                  icon: Icons.medical_services,
                  color: Colors.tealAccent,
                  tooltip: 'CPR Certified',
                ),
              if (isResponder)
                _SkillIcon(
                  icon: Icons.local_police, // Or similar responder icon
                  color: Colors.orangeAccent,
                  tooltip: 'First Responder',
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (50 * rank).ms).slideX();
  }
}

class _SkillIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;

  const _SkillIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 14),
      ),
    );
  }
}
