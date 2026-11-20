import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';

class CreateChallengeScreen extends ConsumerStatefulWidget {
  const CreateChallengeScreen({super.key});

  @override
  ConsumerState<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends ConsumerState<CreateChallengeScreen> {
  bool _isOpponent = true;
  String _selectedSport = 'Futsal';
  String _selectedLevel = 'Menengah';

  final _scheduleController = TextEditingController();
  final _venueController = TextEditingController();
  final _noteController = TextEditingController();

  final _sports = ['Futsal', 'Badminton', 'Mini Soccer', 'Basket', 'Padel'];
  final _levels = ['Pemula', 'Menengah', 'Mahir'];

  @override
  void dispose() {
    _scheduleController.dispose();
    _venueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        title: Text('POSTING TANTANGAN', style: AppTypography.displayMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipe Pencarian', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isOpponent = true),
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isOpponent ? AppColors.primaryRed : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text('Cari Lawan', style: AppTypography.labelButton),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isOpponent = false),
                    child: Container(
                      height: 46,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: !_isOpponent ? AppColors.primaryRed : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text('Cari Rekan', style: AppTypography.labelButton),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text('Cabang Olahraga', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sports.map((sport) {
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
              }).toList(),
            ),
            const SizedBox(height: 20),

            Text('Level Permainan', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            Row(
              children: _levels.map((level) {
                final isSelected = _selectedLevel == level;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLevel = level),
                    child: Container(
                      height: 44,
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            Text('Waktu Main (WIB)', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _scheduleController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Contoh: Sabtu, 21 Nov · 20:00 WIB'),
            ),
            const SizedBox(height: 20),

            Text('Lokasi / Venue', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _venueController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Contoh: Arena Sport Center, Surabaya'),
            ),
            const SizedBox(height: 20),

            Text('Catatan Tambahan', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 2,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Contoh: Patungan sewa lapangan 50:50'),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.textWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  ref.read(challengeListProvider.notifier).addChallenge({
                    'isOpponent': _isOpponent,
                    'schedule': (_scheduleController.text.isEmpty
                            ? 'SABTU, 21 NOV · 20:00 WIB'
                            : _scheduleController.text)
                        .toUpperCase(),
                    'title': _isOpponent ? '${user.name} FC' : 'Butuh Pemain $_selectedSport (${user.name})',
                    'sport': _selectedSport,
                    'venue': _venueController.text.isEmpty
                        ? 'Arena Sport Center, Surabaya'
                        : _venueController.text,
                    'level': _selectedLevel,
                    'note': _noteController.text.isEmpty
                        ? 'Yuk main bareng!'
                        : _noteController.text,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tantangan berhasil diposting ke papan!')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Posting ke Papan', style: AppTypography.labelButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium,
      filled: true,
      fillColor: AppColors.cardSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}