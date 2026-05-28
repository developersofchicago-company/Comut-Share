import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _homeController = TextEditingController();
  final _officeController = TextEditingController();
  final _authService = AuthService();
  String _gender = 'male';
  String _workingHours = '09:00 AM - 05:00 PM';
  bool _isLoading = false;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final List<String> _workingHoursOptions = [
    '08:00 AM - 04:00 PM',
    '08:30 AM - 04:30 PM',
    '09:00 AM - 05:00 PM',
    '09:30 AM - 05:30 PM',
    '10:00 AM - 06:00 PM',
  ];

  bool get _isValid {
    return _nameController.text.trim().isNotEmpty &&
        _homeController.text.trim().isNotEmpty &&
        _officeController.text.trim().isNotEmpty;
  }

  Future<void> _saveProfile() async {
    if (!_isValid) return;
    setState(() => _isLoading = true);

    try {
      await _authService.updateProfile(
        fullName: _nameController.text.trim(),
        homeArea: _homeController.text.trim(),
        officeArea: _officeController.text.trim(),
        gender: _gender,
        workingHours: _workingHours,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.cnicUpload);
    } catch (e) {
      _showError('Could not save profile: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _homeController.dispose();
    _officeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile Setup'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us about yourself',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete your profile to build trust in our secure community.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Full Name
              const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Usman Imran',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textMuted),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Gender selection
              const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Male'),
                      selected: _gender == 'male',
                      onSelected: (selected) {
                        if (selected) setState(() => _gender = 'male');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Female'),
                      selected: _gender == 'female',
                      onSelected: (selected) {
                        if (selected) setState(() => _gender = 'female');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Other'),
                      selected: _gender == 'other',
                      onSelected: (selected) {
                        if (selected) setState(() => _gender = 'other');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Home Area
              const Text('Home Area (Karachi)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _homeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'DHA Phase 6 / Gulshan-e-Iqbal',
                  prefixIcon: Icon(Icons.home_outlined, color: AppColors.textMuted),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Office Area
              const Text('Office Area (Karachi)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              TextField(
                controller: _officeController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Shahrah-e-Faisal / I.I. Chundrigar Road',
                  prefixIcon: Icon(Icons.business_outlined, color: AppColors.textMuted),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Working Hours
              const Text('Working Hours', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  color: AppColors.surfaceDim,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _workingHours,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    isExpanded: true,
                    items: _workingHoursOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _workingHours = newValue);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              CustomButton(
                label: 'Save & Continue',
                onPressed: _saveProfile,
                isLoading: _isLoading,
                enabled: _isValid,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
