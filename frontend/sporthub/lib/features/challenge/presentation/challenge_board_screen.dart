import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class ChallengeBoardScreen extends StatefulWidget {
  const ChallengeBoardScreen({super.key});

  @override
  State<ChallengeBoardScreen> createState() => _ChallengeBoardScreenState();
}

class _ChallengeBoardScreenState extends State<ChallengeBoardScreen> {
  bool _isOpponentTab = true; // true = opponent (lawan), false = teammate (rekan)

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
                Text('PAPAN TANTANGAN', style: AppTypography.displayLarge),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.textWhite,
                    minimumSize: const Size(44, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    // POST /api/v1/challenges
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Posting'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Switcher Tab: Cari Lawan vs Cari Rekan
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isOpponentTab = true),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _isOpponentTab ? AppColors.primaryRed : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Cari Lawan', style: AppTypography.labelButton),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isOpponentTab = false),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: !_isOpponentTab ? AppColors.primaryRed : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Cari Rekan', style: AppTypography.labelButton),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Daftar Tantangan (GET /api/v1/challenges)
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'KAMIS, 20 NOV · 20:00 WIB',
                              style: AppTypography.displayMedium.copyWith(fontSize: 20, color: AppColors.accentOrange),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Menengah', // enum: intermediate -> Menengah
                                style: TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isOpponentTab ? 'Garuda Futsal FC' : 'Butuh 2 Pemain Badminton Ganda',
                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text('Futsal · Arena Sport Center (1.5 km)', style: AppTypography.bodyMedium),
                        const SizedBox(height: 6),
                        Text(
                          '"Main santai tapi serius, patungan lapangan di lokasi"',
                          style: AppTypography.handwrittenNote,
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
                              // POST /api/v1/challenges/:id/responses
                            },
                            child: Text(
                              _isOpponentTab ? 'Tantang' : 'Ajak Main',
                              style: AppTypography.labelButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}