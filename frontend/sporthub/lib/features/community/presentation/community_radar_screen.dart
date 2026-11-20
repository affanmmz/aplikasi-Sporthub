import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import 'create_community_screen.dart';

class CommunityRadarScreen extends StatelessWidget {
  const CommunityRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RADAR KOMUNITAS', style: AppTypography.displayLarge),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.textWhite,
                    minimumSize: const Size(44, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateCommunityScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Buat'),
                ),
              ],
            ),
            Text('Menampilkan komunitas aktif dalam radius 3 km dari posisimu', style: AppTypography.bodyMedium),
            const SizedBox(height: 20),

            // Visualisasi Radar 3 KM
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildRadarRing(300, '3 KM'),
                    _buildRadarRing(200, '2 KM'),
                    _buildRadarRing(100, '1 KM'),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      right: 55,
                      child: _buildCommunityPin('Futsal Malam SBY', '1.4 km'),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 45,
                      child: _buildCommunityPin('Tepok Bulu Gubeng', '2.1 km'),
                    ),
                  ],
                ),
              ),
            ),

            // Kartu Terang (#F6E9E2) Detail Komunitas Terpilih
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.lightCard,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FUTSAL MALAM SBY',
                        style: AppTypography.displayMedium.copyWith(color: AppColors.textDark),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Terbuka',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Rutin tiap Selasa & Jumat, 20:00 WIB · 28 Anggota',
                    style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF5E2B22)),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.textWhite,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil bergabung ke Futsal Malam SBY!')),
                        );
                      },
                      child: Text('Gabung Komunitas', style: AppTypography.labelButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarRing(double size, String label) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accentOrange.withOpacity(0.35), width: 1.5),
        color: AppColors.cardSurface.withOpacity(0.25),
      ),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 6),
      child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
    );
  }

  Widget _buildCommunityPin(String name, String distance) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentOrange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups, color: AppColors.accentOrange, size: 16),
          const SizedBox(width: 6),
          Text('$name ($distance)', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}