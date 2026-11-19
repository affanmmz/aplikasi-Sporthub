import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 24),
              Text('MASUK KE SPORTHUB', style: AppTypography.displayLarge),
              const SizedBox(height: 6),
              Text(
                'Pesan lapangan, cari komunitas, dan ajak sparring dalam satu aplikasi.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 32),

              Text('NOMOR WHATSAPP / HP', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textWhite, fontSize: 16),
                decoration: InputDecoration(
                  prefixText: '+62  ',
                  prefixStyle: const TextStyle(color: AppColors.accentOrange, fontWeight: FontWeight.bold, fontSize: 16),
                  hintText: '812 3456 7890',
                  hintStyle: AppTypography.bodyMedium,
                  filled: true,
                  fillColor: AppColors.cardSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Kirim OTP (POST /api/v1/auth/otp/request)
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
                    // Simulasi langsung masuk ke Beranda
                    context.go('/home');
                  },
                  child: Text('Kirim Kode OTP', style: AppTypography.labelButton),
                ),
              ),
              const SizedBox(height: 16),

              Center(child: Text('atau', style: AppTypography.bodyMedium)),
              const SizedBox(height: 16),

              // Tombol Masuk dengan Google (POST /api/v1/auth/google)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textWhite,
                    side: const BorderSide(color: AppColors.accentOrange),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: AppColors.accentOrange),
                  label: Text('Lanjut dengan Google', style: AppTypography.labelButton),
                ),
              ),
              const Spacer(),

              Center(
                child: TextButton(
                  onPressed: () => context.go('/onboarding'),
                  child: Text('Ubah Preferensi Olahraga', style: AppTypography.handwrittenNote),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}