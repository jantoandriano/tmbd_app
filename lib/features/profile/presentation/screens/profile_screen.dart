import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/core/widgets/app_bottom_nav_bar.dart';
import 'package:cinetrack/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This feature isn't available yet.")),
    );
  }

  void _signOut(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Signed out')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(name: profile.name, email: profile.email),
            const Divider(height: 2),
            _StatsRow(
              watchedCount: profile.watchedCount,
              watchlistCount: profile.watchlistCount,
              reviewsCount: profile.reviewsCount,
            ),
            const Divider(height: 2),
            const _MenuList(),
            _SignOutButton(onTap: () => _signOut(context)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        active: BottomNavTab.none,
        onDiscoverTap: () => context.push('/'),
        onScanTap: () => _showComingSoon(context),
        onTicketsTap: () => _showComingSoon(context),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        children: [
          const ColorFiltered(
            colorFilter: ColorFilter.matrix(<double>[
              0.2126, 0.7152, 0.0722, 0, 0, //
              0.2126, 0.7152, 0.0722, 0, 0, //
              0.2126, 0.7152, 0.0722, 0, 0, //
              0, 0, 0, 1, 0, //
            ]),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xffe3e1e0),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: GoogleFonts.archivo(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: GoogleFonts.archivo(
              fontSize: 12,
              color: AppTheme.textPrimary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accent,
              side: const BorderSide(color: AppTheme.accent),
              shape: const RoundedRectangleBorder(),
            ),
            onPressed: () => context.push('/edit-profile'),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({
    required this.watchedCount,
    required this.watchlistCount,
    required this.reviewsCount,
  });

  final int watchedCount;
  final int watchlistCount;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(value: watchedCount, label: 'Watched'),
        ),
        Expanded(
          child: _StatItem(
            value: watchlistCount,
            label: 'Watchlist',
            showLeftBorder: true,
          ),
        ),
        Expanded(
          child: _StatItem(
            value: reviewsCount,
            label: 'Reviews',
            showLeftBorder: true,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.showLeftBorder = false,
  });

  final int value;
  final String label;
  final bool showLeftBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: showLeftBorder
          ? const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppTheme.divider, width: 2),
              ),
            )
          : null,
      child: Column(
        children: [
          Text(
            '$value',
            style: GoogleFonts.archivo(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.archivo(
              fontSize: 11,
              color: AppTheme.textPrimary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MenuRow(label: 'Account', route: '/account'),
        _MenuRow(label: 'Notifications', route: '/notifications'),
        _MenuRow(label: 'Payment Methods', route: '/payment-methods'),
        _MenuRow(label: 'Help & Support', route: '/help-support'),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                Text(
                  label,
                  style: GoogleFonts.archivo(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppTheme.textPrimary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
          const Divider(height: 2),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.accentDark,
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: onTap,
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
