import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_formatter.dart';

class ETicketScreen extends StatelessWidget {
  final String bookingCode;
  final String venueName;
  final String courtName;
  final String dateText;
  final String timeSlot;
  final List<String> rentedEquipments;
  final int totalPaid;

  const ETicketScreen({
    super.key,
    this.bookingCode = 'SH-20261120-8842',
    this.venueName = 'ARENA SPORT CENTER',
    this.courtName = 'Lapangan A · Vinyl Standar FIFA',
    this.dateText = 'Jumat, 20 Nov 2026',
    this.timeSlot = '20:00 - 21:00 WIB (1 Jam)',
    this.rentedEquipments = const ['1x Bola Futsal Match', '1x Rompi Tim (1 Set)'],
    this.totalPaid = 165000,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textWhite,
        title: Text('E-TIKET BOOKING', style: AppTypography.displayMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Kartu E-Tiket Utama (Latar terang #F6E9E2 agar QR mudah dipindai scanner)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightCard,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B7A3E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LUNAS · SIAP CHECK-IN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama Venue & Lapangan
                  Text(
                    venueName,
                    textAlign: TextAlign.center,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.textDark,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    courtName,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF5E2B22),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // QR Code untuk Scan Petugas Venue
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primaryRed.withOpacity(0.2), width: 2),
                    ),
                    child: QrImageView(
                      data: bookingCode,
                      version: QrVersions.auto,
                      size: 190.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.textDark,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    bookingCode,
                    style: AppTypography.displayMedium.copyWith(
                      color: AppColors.primaryRed,
                      fontSize: 22,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'Tunjukkan QR Code ini ke petugas venue maksimal 15 menit sebelum main',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF5E2B22),
                      fontSize: 12,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Color(0xFFD6C2B9), thickness: 1.5),
                  ),

                  // Detail Jadwal & Perlengkapan
                  _buildDetailRow('Tanggal', dateText),
                  const SizedBox(height: 10),
                  _buildDetailRow('Jam Main', timeSlot),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    'Perlengkapan',
                    rentedEquipments.isEmpty ? '-' : rentedEquipments.join('\n'),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow('Total Bayar', formatRupiah(totalPaid), isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Kembali ke Beranda
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textWhite,
                  side: const BorderSide(color: AppColors.accentOrange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text('Kembali', style: AppTypography.labelButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(color: const Color(0xFF6E3B31)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTypography.bodyMedium.copyWith(
              color: isBold ? AppColors.primaryRed : AppColors.textDark,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}