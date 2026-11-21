import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/currency_formatter.dart';
import 'eticket_screen.dart';

class VenueDetailScreen extends ConsumerStatefulWidget {
  final DataMap venue;

  const VenueDetailScreen({super.key, required this.venue});

  @override
  ConsumerState<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends ConsumerState<VenueDetailScreen> {
  final _timeSlots = ['18:00', '19:00', '20:00', '21:00', '22:00'];
  final _selectedSlots = <String>{};
  late DataMapList _equipments;

  @override
  void initState() {
    super.initState();
    final rawEq = widget.venue['equipments'] as List;
    _equipments = rawEq.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  int get _pricePerHour => widget.venue['price'] as int;

  int get _totalAmount {
    final courtTotal = _selectedSlots.length * _pricePerHour;
    final eqTotal = _equipments.fold<int>(
      0,
      (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)),
    );
    return courtTotal + eqTotal;
  }

  @override
  Widget build(BuildContext context) {
    final bookedList = (widget.venue['bookedSlots'] as List).map((e) => e.toString()).toSet();
    final venueName = widget.venue['name'] as String;
    final courtName = widget.venue['courtName'] as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        title: Text('DETAIL VENUE', style: AppTypography.displayMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(venueName.toUpperCase(), style: AppTypography.displayLarge),
            const SizedBox(height: 4),
            Text(
              '${widget.venue['address']} · ${widget.venue['distanceKm']} km · ${widget.venue['hours']}',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 24),

            Text('PILIH LAPANGAN', style: AppTypography.displayMedium),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryRed, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(courtName, style: AppTypography.bodyLarge),
                        const SizedBox(height: 4),
                        Text('${formatRupiah(_pricePerHour)} / jam', style: AppTypography.bodyMedium),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle, color: AppColors.primaryRed),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PILIH JAM (WIB)', style: AppTypography.displayMedium),
                Text('1 slot = 1 jam', style: AppTypography.handwrittenNote),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _timeSlots.map((slot) {
                final isBooked = bookedList.contains(slot);
                final isSelected = _selectedSlots.contains(slot);

                return GestureDetector(
                  onTap: isBooked
                      ? null
                      : () {
                          setState(() {
                            if (isSelected) {
                              _selectedSlots.remove(slot);
                            } else {
                              _selectedSlots.add(slot);
                            }
                          });
                        },
                  child: Container(
                    width: 96,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isBooked
                          ? const Color(0xFF1E0603)
                          : isSelected
                              ? AppColors.primaryRed
                              : AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      isBooked ? '$slot\nPenuh' : slot,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isBooked ? Colors.white38 : AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: isBooked ? 11 : 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Text('SEWA PERLENGKAPAN (OPSIONAL)', style: AppTypography.displayMedium),
            const SizedBox(height: 4),
            Text('Tersedia selama jam pemesanan lapangan', style: AppTypography.bodyMedium),
            const SizedBox(height: 12),
            ..._equipments.map((eq) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(eq['name'] as String, style: AppTypography.bodyLarge),
                          Text('${formatRupiah(eq['price'] as int)} · Stok: ${eq['stock']}', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: (eq['qty'] as int) > 0
                              ? () => setState(() => eq['qty'] = (eq['qty'] as int) - 1)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.textWhite),
                        ),
                        Text('${eq['qty']}', style: AppTypography.bodyLarge),
                        IconButton(
                          onPressed: (eq['qty'] as int) < (eq['stock'] as int)
                              ? () => setState(() => eq['qty'] = (eq['qty'] as int) + 1)
                              : null,
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.accentOrange),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total (${_selectedSlots.length} jam)', style: AppTypography.bodyMedium),
                  Text(formatRupiah(_totalAmount), style: AppTypography.statNumber),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  foregroundColor: AppColors.textWhite,
                  minimumSize: const Size(160, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _selectedSlots.isEmpty
                    ? null
                    : () {
                        final selectedItems = _equipments
                            .where((e) => (e['qty'] as int) > 0)
                            .map((e) => '${e['qty']}x ${e['name']}')
                            .toList();
                        final timeText = '${_selectedSlots.join(', ')} WIB (${_selectedSlots.length} Jam)';
                        final code = 'SH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

                        ref.read(bookingListProvider.notifier).addBooking({
                          'bookingCode': code,
                          'venueName': venueName.toUpperCase(),
                          'courtName': courtName,
                          'dateText': 'Hari Ini, 20 Nov 2026',
                          'timeSlot': timeText,
                          'rentedEquipments': selectedItems,
                          'totalPaid': _totalAmount,
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ETicketScreen(
                              bookingCode: code,
                              venueName: venueName.toUpperCase(),
                              courtName: courtName,
                              timeSlot: timeText,
                              rentedEquipments: selectedItems,
                              totalPaid: _totalAmount,
                            ),
                          ),
                        );
                      },
                child: Text('Lanjut Bayar', style: AppTypography.labelButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}