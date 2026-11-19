// lib/features/booking/presentation/venue_list_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class VenueListScreen extends StatelessWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DAFTAR LAPANGAN', style: AppTypography.displayLarge),
            const SizedBox(height: 8),
            Text('Filter berdasarkan cabang olahraga & jarak terdekat', style: AppTypography.bodyMedium),
            // Integrasi GET /api/v1/venues?sport=&lat=&lng=&radius=&q=
          ],
        ),
      ),
    );
  }
}