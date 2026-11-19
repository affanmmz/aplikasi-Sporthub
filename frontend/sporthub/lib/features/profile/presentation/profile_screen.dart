// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PROFIL PEMAIN', style: AppTypography.displayLarge),
            const SizedBox(height: 16),
            // Kartu E-Tiket QR Aktif (F2 Langkah 7-8)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightCard,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text('E-TIKET AKTIF', style: AppTypography.displayMedium.copyWith(color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Text('Tunjukkan QR ini ke petugas venue saat check-in', style: AppTypography.bodyMedium.copyWith(color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: 'SPORTHUB-BOOKING-UUID-EXAMPLE',
                    version: QrVersions.auto,
                    size: 160.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}