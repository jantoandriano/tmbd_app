import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BottomNavTab { discover, watchlist, none }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.active,
    required this.onDiscoverTap,
    required this.onScanTap,
    required this.onWatchlistTap,
    super.key,
  });

  final BottomNavTab active;
  final VoidCallback onDiscoverTap;
  final VoidCallback onScanTap;
  final VoidCallback onWatchlistTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xffeae9e9),
          border: Border(top: BorderSide(color: AppTheme.divider, width: 2)),
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.explore_outlined,
                  label: 'Discover',
                  active: active == BottomNavTab.discover,
                  onTap: onDiscoverTap,
                ),
              ),
              Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -14),
                    child: _ScanButton(onTap: onScanTap),
                  ),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.bookmark_outline,
                  label: 'Watchlist',
                  active: active == BottomNavTab.watchlist,
                  onTap: onWatchlistTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.accentDark : const Color(0xff7d7979);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.archivo(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accent,
          boxShadow: kElevationToShadow[4],
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}
