import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';
import 'create_community_screen.dart';

class CommunityRadarScreen extends ConsumerStatefulWidget {
  const CommunityRadarScreen({super.key});

  @override
  ConsumerState<CommunityRadarScreen> createState() => _CommunityRadarScreenState();
}

class _CommunityRadarScreenState extends ConsumerState<CommunityRadarScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userLoc = ref.watch(locationProvider);
    final communities = ref.watch(nearbyCommunitiesProvider);

    final activeCommunity = communities.isNotEmpty
        ? communities[_selectedIndex < communities.length ? _selectedIndex : 0]
        : null;

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
            Text(
              'Menampilkan ${communities.length} komunitas dalam radius 3 km dari ${userLoc.cityName}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Visualisasi Radar 3 KM Dinamis
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildRadarRing(280, '3 KM'),
                    _buildRadarRing(190, '2 KM'),
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
                    if (communities.isNotEmpty)
                      Positioned(
                        top: 35,
                        right: 30,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = 0),
                          child: _buildCommunityPin(
                            communities[0]['name'] as String,
                            '${communities[0]['distanceKm']} km',
                            _selectedIndex == 0,
                          ),
                        ),
                      ),
                    if (communities.length > 1)
                      Positioned(
                        bottom: 45,
                        left: 25,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = 1),
                          child: _buildCommunityPin(
                            communities[1]['name'] as String,
                            '${communities[1]['distanceKm']} km',
                            _selectedIndex == 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (activeCommunity == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  'Belum ada komunitas dalam radius 3 km dari lokasimu. Jadilah yang pertama membuatnya!',
                  style: AppTypography.bodyMedium,
                ),
              )
            else
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
                        Expanded(
                          child: Text(
                            (activeCommunity['name'] as String).toUpperCase(),
                            style: AppTypography.displayMedium.copyWith(color: AppColors.textDark),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${activeCommunity['distanceKm']} km',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${activeCommunity['sport']} · ${activeCommunity['schedule']} · ${activeCommunity['members']} Anggota',
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
                            SnackBar(content: Text('Berhasil bergabung ke ${activeCommunity['name']}!')),
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

  Widget _buildCommunityPin(String name, String distance, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryRed : AppColors.cardSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentOrange),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text('$name ($distance)', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}