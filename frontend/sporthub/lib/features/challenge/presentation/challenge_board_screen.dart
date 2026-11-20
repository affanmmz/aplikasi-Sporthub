import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';
import 'create_challenge_screen.dart';

class ChallengeBoardScreen extends ConsumerStatefulWidget {
  const ChallengeBoardScreen({super.key});

  @override
  ConsumerState<ChallengeBoardScreen> createState() => _ChallengeBoardScreenState();
}

class _ChallengeBoardScreenState extends ConsumerState<ChallengeBoardScreen> {
  bool _isOpponentTab = true;

  @override
  Widget build(BuildContext context) {
    final allChallenges = ref.watch(challengeListProvider);
    final filteredChallenges = allChallenges
        .where((item) => (item['isOpponent'] as bool) == _isOpponentTab)
        .toList();

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateChallengeScreen()),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Posting'),
                ),
              ],
            ),
            const SizedBox(height: 16),

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

            Expanded(
              child: filteredChallenges.isEmpty
                  ? Center(
                      child: Text('Belum ada postingan pada kategori ini', style: AppTypography.bodyMedium),
                    )
                  : ListView.separated(
                      itemCount: filteredChallenges.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = filteredChallenges[index];
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
                                  Expanded(
                                    child: Text(
                                      item['schedule'] as String,
                                      style: AppTypography.displayMedium.copyWith(fontSize: 20, color: AppColors.accentOrange),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      item['level'] as String,
                                      style: const TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['title'] as String,
                                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['sport']} · ${item['venue']}',
                                style: AppTypography.bodyMedium,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '"${item['note']}"',
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          _isOpponentTab
                                              ? 'Tantangan sparring terkirim!'
                                              : 'Permintaan ajak main terkirim!',
                                        ),
                                      ),
                                    );
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