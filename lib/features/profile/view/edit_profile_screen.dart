import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/constant/app_text_style.dart';
import 'package:velo_toulose/core/widgets/botton.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthViewModel>().currentUser;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final vm = context.read<AuthViewModel>();
    final user = vm.currentUser;
    if (user == null) return;

    // update user with new values
    final updated = user.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    await vm.updateUser(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated!'),
          backgroundColor: AppColor.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: AppTextStyle.cardTitle.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // avatar with edit button
              Center(
                child: Stack(
                  children: [
                    Consumer<AuthViewModel>(
                      builder: (context, vm, _) {
                        final user = vm.currentUser;
                        return CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColor.textSecondary,
                          backgroundImage: user?.hasImage == true
                              ? NetworkImage(user!.image.toString())
                              : null,
                          child: user?.hasImage != true
                              ? Icon(
                                  Icons.person,
                                  color: AppColor.background,
                                  size: 50,
                                )
                              : null,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          // TODO: image picker
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColor.primary,
                          radius: 18,
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColor.background,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Tap camera to change photo',
                style: TextStyle(color: AppColor.textSecondary, fontSize: 12),
              ),

              const SizedBox(height: 32),

              // input fields
              _buildInputSection([
                _InputField(
                  label: 'First Name',
                  controller: _firstNameController,
                  icon: Icons.person_outline,
                ),
                _InputField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  icon: Icons.person_outline,
                ),
                _InputField(
                  label: 'Phone',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
              ]),

              const SizedBox(height: 12),

              // email — read only
              Consumer<AuthViewModel>(
                builder: (context, vm, _) => _buildInputSection([
                  _InputField(
                    label: 'Email',
                    controller: TextEditingController(
                      text: vm.currentUser?.email,
                    ),
                    icon: Icons.email_outlined,
                    readOnly: true, // email cannot be changed
                  ),
                ]),
              ),

              const SizedBox(height: 32),

              AppButton(
                label: _isSaving ? 'Saving...' : 'Save Changes',
                isprimaryColor: true,
                onPressed: _isSaving ? () {} : _save,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection(List<_InputField> fields) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(29, 107, 114, 128),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: fields.map((field) {
          final isLast = fields.last == field;
          return Column(
            children: [
              _buildField(field),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildField(_InputField field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(field.icon, color: AppColor.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: field.controller,
              readOnly: field.readOnly,
              keyboardType: field.keyboardType,
              decoration: InputDecoration(
                labelText: field.label,
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: AppColor.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    required this.icon,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });
}
