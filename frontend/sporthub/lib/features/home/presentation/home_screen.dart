import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../booking/presentation/venue_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedSport = 'Semua';
  final List<String> _sports = ['Semua', 'Futsal', 'Badminton', 'Mini Soccer', 'Basket', 'Padel'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Lokasi & Notifikasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LOKASI SAAT INI', style: AppTypography.bodyMedium.copyWith(fontSize: 11)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: AppColors.accentOrange, size: 16),
                        const SizedBox(width: 4),
                        Text('Surabaya, Jawa Timur', style: AppTypography.bodyLarge),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.cardSurface,
                    minimumSize: const Size(44, 44), // Aksesibilitas min 44px
                  ),
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textWhite),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hero Headline + Catatan Caveat
            Text('GAS MAIN', style: AppTypography.displayLarge),
            Row(
              children: [
                Text('HARI INI!', style: AppTypography.displayLarge.copyWith(color: AppColors.accentOrange)),
                const SizedBox(width: 12),
                Transform.rotate(
                  angle: -0.05,
                  child: Text('tanpa ribet chat admin~', style: AppTypography.handwrittenNote),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              style: const TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'Cari venue atau lapangan terdekat...',
                hintStyle: AppTypography.bodyMedium,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Filter Olahraga
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sports.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final sport = _sports[index];
                  final isSelected = _selectedSport == sport;
                  return ChoiceChip(
                    label: Text(sport),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedSport = sport),
                    backgroundColor: AppColors.cardSurface,
                    selectedColor: AppColors.primaryRed,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Banner Aksi Cepat (Cari Lawan & Radar Komunitas)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryRed, AppColors.maroonGradient],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BUTUH LAWAN SPARRING?', style: AppTypography.displayMedium),
                        const SizedBox(height: 4),
                        Text(
                          '12 tim siap tanding di sekitar kamu malam ini.',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textWhite),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textWhite),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section Venue Terdekat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VENUE TERDEKAT', style: AppTypography.displayMedium),
                Text('Radius 5 km', style: AppTypography.handwrittenNote),
              ],
            ),
            const SizedBox(height: 12),

            // Kartu Venue (Contoh data placeholder sesuai aturan PRD)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VenueDetailScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.maroonGradient,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Icon(Icons.sports_soccer, size: 48, color: AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Arena Sport Center (Contoh)', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: AppColors.accentOrange, size: 14),
                              SizedBox(width: 4),
                              Text('4.8', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('1.2 km · Futsal, Badminton · Buka 07:00 - 23:00 WIB', style: AppTypography.bodyMedium),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mulai ${formatRupiah(120000)}/jam', style: AppTypography.statNumber.copyWith(fontSize: 20)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text('Pesan', style: AppTypography.labelButton),
                        ),
                      ],
                    )
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