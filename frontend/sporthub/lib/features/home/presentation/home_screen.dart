import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../booking/presentation/eticket_screen.dart';
import '../../booking/presentation/venue_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLoc = ref.watch(locationProvider);
    final user = ref.watch(userProfileProvider);
    final bookings = ref.watch(bookingListProvider);
    final nearbyVenues = ref.watch(nearbyVenuesProvider);

    final nextBooking = bookings.isNotEmpty ? bookings.first : null;
    final topVenue = nearbyVenues.isNotEmpty ? nearbyVenues.first : null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Lokasi Dinamis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, ${user.name}', style: AppTypography.bodyMedium),
                    InkWell(
                      onTap: () => ref.read(locationProvider.notifier).refreshLocation(),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.accentOrange, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${userLoc.cityName}, Indonesia',
                            style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: AppColors.cardSurface,
                  child: const Icon(Icons.notifications_none, color: AppColors.textWhite),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Kartu Hero Jadwal Terdekat (Dinamis dari bookingListProvider)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.maroonGradient, AppColors.cardSurface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: nextBooking == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BELUM ADA JADWAL MAIN', style: AppTypography.displayMedium),
                        const SizedBox(height: 6),
                        Text('Yuk cari lapangan terdekat di ${userLoc.cityName}!', style: AppTypography.bodyMedium),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('JADWAL TERDEKAT', style: AppTypography.handwrittenNote),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Terkonfirmasi',
                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(nextBooking['venueName'] as String, style: AppTypography.displayLarge),
                        const SizedBox(height: 4),
                        Text(
                          '${nextBooking['dateText']} · ${nextBooking['timeSlot']}',
                          style: AppTypography.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: AppColors.textWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ETicketScreen(
                                    bookingCode: nextBooking['bookingCode'] as String,
                                    venueName: nextBooking['venueName'] as String,
                                    courtName: nextBooking['courtName'] as String,
                                    dateText: nextBooking['dateText'] as String,
                                    timeSlot: nextBooking['timeSlot'] as String,
                                    rentedEquipments: (nextBooking['rentedEquipments'] as List)
                                        .map((e) => e.toString())
                                        .toList(),
                                    totalPaid: nextBooking['totalPaid'] as int,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.qr_code_2),
                            label: Text('Buka E-Tiket QR', style: AppTypography.labelButton),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),

            // Rekomendasi Lapangan Terdekat Berdasarkan GPS
            Text('TERDEKAT DARI LOKASIMU', style: AppTypography.displayMedium),
            const SizedBox(height: 12),
            if (topVenue != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VenueDetailScreen(venue: topVenue),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.maroonGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.sports_soccer, color: AppColors.accentOrange, size: 36),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              topVenue['name'] as String,
                              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${topVenue['sport']} · ${topVenue['distanceKm']} km · ${topVenue['city']}',
                              style: AppTypography.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Mulai ${formatRupiah(topVenue['price'] as int)}/jam',
                              style: AppTypography.statNumber.copyWith(fontSize: 20),
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
    );
  }
}