import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../booking/presentation/eticket_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final bookings = ref.watch(bookingListProvider);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PROFIL PEMAIN', style: AppTypography.displayLarge),
            const SizedBox(height: 16),

            // Kartu Identitas Pemain (Dinamis dari Onboarding)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primaryRed,
                    child: Text('SH', style: AppTypography.displayMedium),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          '${user.favoriteSports.join(', ')} · Level ${user.level}',
                          style: AppTypography.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Daftar E-Tiket Dinamis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('E-TIKET & BOOKING SAYA', style: AppTypography.displayMedium),
                Text('${bookings.length} Tiket', style: AppTypography.handwrittenNote),
              ],
            ),
            const SizedBox(height: 12),

            ...bookings.map((item) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ETicketScreen(
                        bookingCode: item['bookingCode'] as String,
                        venueName: item['venueName'] as String,
                        courtName: item['courtName'] as String,
                        dateText: item['dateText'] as String,
                        timeSlot: item['timeSlot'] as String,
                        rentedEquipments: List<String>.from(item['rentedEquipments'] as List),
                        totalPaid: item['totalPaid'] as int,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.lightCard,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['venueName'] as String,
                              style: AppTypography.displayMedium.copyWith(color: AppColors.textDark, fontSize: 20),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['dateText']} · ${item['timeSlot']}',
                              style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF5E2B22)),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Ketuk untuk buka QR Check-In →',
                              style: TextStyle(color: AppColors.primaryRed, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentOrange,
                  side: const BorderSide(color: AppColors.accentOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded),
                label: Text('Keluar Akun', style: AppTypography.labelButton.copyWith(color: AppColors.accentOrange)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}