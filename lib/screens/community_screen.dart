import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Data Model
class CommunityPost {
  final String userName;
  final String content;
  final String timeAgo;
  final bool isVerifiedNeighbor;
  final bool isResponder;
  final int verificationCount;
  final String category; // Added category

  CommunityPost({
    required this.userName,
    required this.content,
    required this.timeAgo,
    this.isVerifiedNeighbor = false,
    this.isResponder = false,
    this.verificationCount = 0,
    required this.category,
  });
}

class CommunityDashboardScreen extends StatefulWidget {
  const CommunityDashboardScreen({super.key});

  @override
  State<CommunityDashboardScreen> createState() =>
      _CommunityDashboardScreenState();
}

class _CommunityDashboardScreenState extends State<CommunityDashboardScreen> {
  // Initial Mock Data
  final List<CommunityPost> _posts = [
    CommunityPost(
      userName: 'Alice Smith',
      content:
          'Street light down on 5th Avenue. It\'s completely dark near the playground.',
      timeAgo: '1h ago',
      isVerifiedNeighbor: true,
      category: 'Infrastructure',
      verificationCount: 5,
    ),
    CommunityPost(
      userName: 'Bob Johnson',
      content: 'Has anyone seen a golden retriever? Lost near Main St.',
      timeAgo: '2h ago',
      category: 'Lost Pet',
      verificationCount: 10,
    ),
    CommunityPost(
      userName: 'Officer Davis',
      content:
          'Patrol update: Suspicious activity reported near the park. We are investigating.',
      timeAgo: '3h ago',
      isResponder: true,
      category: 'Suspicious Activity',
      verificationCount: 15,
    ),
    CommunityPost(
      userName: 'Carol White',
      content: 'Large pothole on Elm Street, caused a flat tire. Be careful!',
      timeAgo: '4h ago',
      isVerifiedNeighbor: true,
      category: 'Infrastructure',
      verificationCount: 20,
    ),
    CommunityPost(
      userName: 'Dave Brown',
      content:
          'Community meeting this Saturday at the community center. Topics: safety & improvements.',
      timeAgo: '5h ago',
      category: 'General',
      verificationCount: 25,
    ),
  ];

  void _addPost(String category, String content) {
    setState(() {
      _posts.insert(
        0,
        CommunityPost(
          userName: 'You', // User's post
          content: content,
          timeAgo: 'Just now',
          isVerifiedNeighbor: true,
          category: category,
          verificationCount: 0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Neighborhood Watch',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _CommunityPostCard(post: post),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReportDialog(context),
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.report_problem, color: Colors.white),
        label: Text(
          'Report Hazard',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Hazard',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _ReportCategoryTile(
                icon: Icons.visibility,
                color: Colors.orange,
                title: 'Suspicious Activity',
                onTap: () {
                  Navigator.pop(context);
                  _showDetailsDialog(context, 'Suspicious Activity');
                },
              ),
              _ReportCategoryTile(
                icon: Icons.traffic,
                color: Colors.blue,
                title: 'Infrastructure',
                onTap: () {
                  Navigator.pop(context);
                  _showDetailsDialog(context, 'Infrastructure');
                },
              ),
              _ReportCategoryTile(
                icon: Icons.pets,
                color: Colors.green,
                title: 'Lost Pet',
                onTap: () {
                  Navigator.pop(context);
                  _showDetailsDialog(context, 'Lost Pet');
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context, String category) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Report $category',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Describe the issue...',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addPost(category, controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Report submitted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  final CommunityPost post;

  const _CommunityPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: post.isResponder
            ? Border.all(
                color: const Color(0xFFFFD700),
                width: 1.5,
              ) // Gold border for responder
            : null,
        boxShadow: post.isResponder
            ? [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  child: Text(
                    post.userName[0],
                    style: GoogleFonts.inter(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.userName,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (post.isVerifiedNeighbor) ...[
                            const SizedBox(width: 4),
                            // Blue/Green verification checkmark
                            const Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                              size: 14,
                            ),
                          ],
                          if (post.isResponder) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.shield,
                              color: Color(0xFFFFD700),
                              size: 14,
                            ),
                          ],
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            post.timeAgo,
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (post.category.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                post.category,
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (post.isResponder)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OFFICIAL',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFD700),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.white10),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              post.content,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                _ActionButton(
                  icon: Icons.check_circle_outline,
                  label: 'Verify (${post.verificationCount})',
                  color: Colors.greenAccent,
                  onTap: () {},
                ),
                _ActionButton(
                  icon: Icons.cancel_outlined,
                  label: 'Not Real',
                  color: Colors.redAccent,
                  onTap: () {},
                ),
                const Spacer(),
                _ActionButton(
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                  color: Colors.blueAccent,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: GoogleFonts.inter(color: color, fontSize: 12)),
    );
  }
}

class _ReportCategoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _ReportCategoryTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: GoogleFonts.inter(color: Colors.white)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: Colors.white10,
    );
  }
}
