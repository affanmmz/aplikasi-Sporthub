import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final _nameController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedSport = 'Futsal';

  final _sports = ['Futsal', 'Badminton', 'Mini Soccer', 'Basket', 'Padel'];

  @override
  void dispose() {
    _nameController.dispose();
    _scheduleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userLoc = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        title: Text('BUAT KOMUNITAS', style: AppTypography.displayMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Komunitas', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Contoh: Futsal Santai Darmo'),
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

            Text('Jadwal Rutin', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _scheduleController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Contoh: Tiap Rabu & Sabtu, 19:00 WIB'),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.my_location, color: AppColors.accentOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Titik radar otomatis memakai koordinat GPS kamu saat ini (${userLoc.cityName})',
                      style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                    ),
                  ),
                ],
              ),
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
                  ref.read(communityListProvider.notifier).addCommunity({
                    'name': _nameController.text.isEmpty
                        ? 'Komunitas $_selectedSport ${userLoc.cityName}'
                        : _nameController.text,
                    'sport': _selectedSport,
                    'schedule': _scheduleController.text.isEmpty
                        ? 'Tiap Sabtu, 19:00 WIB'
                        : _scheduleController.text,
                    'members': 1,
                    'lat': userLoc.latitude,
                    'lng': userLoc.longitude,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Komunitas berhasil dibuat & muncul di radar 3 km!')),
                  );
                  Navigator.pop(context);
                },
                child: Text('Terbitkan Komunitas', style: AppTypography.labelButton),
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