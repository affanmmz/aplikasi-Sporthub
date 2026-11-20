import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
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

            Text('Deskripsi Singkat', style: AppTypography.bodyMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: _inputDecoration('Info patungan lapangan, level pemain, dll.'),
            ),
            const SizedBox(height: 20),

            // Info Titik Lokasi Radar
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
                      'Titik radar komunitas menggunakan lokasi GPS saat ini (Surabaya)',
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