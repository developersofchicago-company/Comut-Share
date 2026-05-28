import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _authService = AuthService();
  final _nameController = TextEditingController();
  final _homeController = TextEditingController();
  final _officeController = TextEditingController();
  String _gender = 'male';
  String _workingHours = '09:00 AM - 05:00 PM';
  bool _isLoading = true;
  bool _isSaving = false;

  final _workingHoursOptions = const [
    '08:00 AM - 04:00 PM',
    '08:30 AM - 04:30 PM',
    '09:00 AM - 05:00 PM',
    '09:30 AM - 05:30 PM',
    '10:00 AM - 06:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _hydrate();
  }

  Future<void> _hydrate() async {
    try {
      final user = await _authService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _nameController.text = user?.fullName ?? '';
        _homeController.text = user?.homeArea ?? '';
        _officeController.text = user?.officeArea ?? '';
        _gender = user?.gender ?? 'male';
        _workingHours = user?.workingHours ?? '09:00 AM - 05:00 PM';
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name is required')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await _authService.updateProfile(
        fullName: _nameController.text.trim(),
        homeArea: _homeController.text.trim(),
        officeArea: _officeController.text.trim(),
        gender: _gender,
        workingHours: _workingHours,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Full Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(controller: _nameController, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),

                  const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 8),
                  Row(
                    children: ['male', 'female', 'other'].map((g) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(g[0].toUpperCase() + g.substring(1)),
                            selected: _gender == g,
                            onSelected: (s) {
                              if (s) setState(() => _gender = g);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  const Text('Home Area', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(controller: _homeController, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),

                  const Text('Office Area', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(controller: _officeController, style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),

                  const Text('Working Hours', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
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
                        items: _workingHoursOptions
                            .map((v) => DropdownMenuItem<String>(value: v, child: Text(v)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) setState(() => _workingHours = v);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(label: 'Save Changes', isLoading: _isSaving, onPressed: _save),
                ],
              ),
            ),
    );
  }
}
