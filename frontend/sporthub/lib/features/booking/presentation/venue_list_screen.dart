import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';
import 'venue_detail_screen.dart';

class VenueListScreen extends StatefulWidget {
  const VenueListScreen({super.key});

  @override
  State<VenueListScreen> createState() => _VenueListScreenState();
}

class _VenueListScreenState extends State<VenueListScreen> {
  String _selectedSport = 'Semua';
  String _searchQuery = '';

  final _sports = ['Semua', 'Futsal', 'Badminton', 'Mini Soccer', 'Basket', 'Padel'];

  final _venues = [
    {
      'name': 'Arena Sport Center',
      'sport': 'Futsal',
      'distance': '1.2 km',
      'rating': '4.8',
      'hours': '07:00 - 23:00 WIB',
      'price': 120000,
    },
    {
      'name': 'GOR Bintang Timur',
      'sport': 'Badminton',
      'distance': '2.0 km',
      'rating': '4.7',
      'hours': '08:00 - 22:00 WIB',
      'price': 65000,
    },
    {
      'name': 'Darmo Mini Soccer Park',
      'sport': 'Mini Soccer',
      'distance': '3.4 km',
      'rating': '4.9',
      'hours': '06:00 - 24:00 WIB',
      'price': 450000,
    },
    {
      'name': 'Surabaya Padel Club',
      'sport': 'Padel',
      'distance': '4.1 km',
      'rating': '4.9',
      'hours': '07:00 - 23:00 WIB',
      'price': 280000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredVenues = _venues.where((v) {
      final matchesSport = _selectedSport == 'Semua' || v['sport'] == _selectedSport;
      final name = (v['name'] as String).toLowerCase();
      final matchesQuery = name.contains(_searchQuery.toLowerCase());
      return matchesSport && matchesQuery;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DAFTAR LAPANGAN', style: AppTypography.displayLarge),
            const SizedBox(height: 4),
            Text('Temukan venue & lapangan terdekat di sekitarmu', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),

            // Search Bar
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'Cari nama GOR atau lapangan...',
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
            const SizedBox(height: 14),

            // Filter Olahraga
            SizedBox(
              height: 42,
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
            const SizedBox(height: 16),

            // List Venue
            Expanded(
              child: filteredVenues.isEmpty
                  ? Center(
                      child: Text('Venue tidak ditemukan', style: AppTypography.bodyMedium),
                    )
                  : ListView.separated(
                      itemCount: filteredVenues.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final venue = filteredVenues[index];
                        return GestureDetector(
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
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 76,
                                  height: 76,
                                  decoration: BoxDecoration(
                                    color: AppColors.maroonGradient,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.stadium_rounded, color: AppColors.accentOrange, size: 34),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              venue['name'] as String,
                                              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: AppColors.accentOrange, size: 14),
                                              const SizedBox(width: 3),
                                              Text(
                                                venue['rating'] as String,
                                                style: const TextStyle(color: AppColors.textWhite, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${venue['sport']} · ${venue['distance']} · ${venue['hours']}',
                                        style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Mulai ${formatRupiah(venue['price'] as int)}/jam',
                                        style: AppTypography.statNumber.copyWith(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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