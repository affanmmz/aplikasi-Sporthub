import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Set<String> _selectedSports = {'Futsal'};
  String _selectedLevel = 'Menengah';

  final List<String> _sports = ['Futsal', 'Badminton', 'Mini Soccer', 'Basket', 'Padel'];
  final List<String> _levels = ['Pemula', 'Menengah', 'Mahir'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('SPORTHUB', style: AppTypography.statNumber.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text('ATUR GAYA MAINMU', style: AppTypography.displayLarge),
              const SizedBox(height: 6),
              Text(
                'Pilih cabang olahraga & level bermain untuk rekomendasi venue dan lawan tanding yang pas.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 28),

              // Pilih Cabang Olahraga
              Text('OLAHRAGA FAVORIT', style: AppTypography.displayMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _sports.map((sport) {
                  final isSelected = _selectedSports.contains(sport);
                  return FilterChip(
                    label: Text(sport),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedSports.add(sport);
                        } else if (_selectedSports.length > 1) {
                          _selectedSports.remove(sport);
                        }
                      });
                    },
                    backgroundColor: AppColors.cardSurface,
                    selectedColor: AppColors.primaryRed,
                    checkmarkColor: AppColors.textWhite,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Pilih Level Bermain
              Text('LEVEL BERMAIN', style: AppTypography.displayMedium),
              const SizedBox(height: 12),
              Row(
                children: _levels.map((level) {
                  final isSelected = _selectedLevel == level;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLevel = level),
                      child: Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryRed : AppColors.cardSurface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          level,
                          style: TextStyle(
                            color: isSelected ? AppColors.textWhite : AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.textWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.go('/login'),
                  child: Text('Mulai Sekarang', style: AppTypography.labelButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}