import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/core/widgets/custom_button.dart';
import 'package:mini_lms_app/core/widgets/custom_text_field.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:mini_lms_app/features/profile/presentation/bloc/profile_state.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
        UpdateProfileEvent(
          name: _nameController.text,
          email: _emailController.text,
        ),
      );
    }
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.go('/login');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              _nameController.text = state.user.name;
              _emailController.text = state.user.email;
            } else if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('الملف الشخصي'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
              tooltip: 'تسجيل الخروج',
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileInitial ||
                  (state is ProfileLoading && _nameController.text.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF2563EB),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextField(
                        controller: _nameController,
                        label: 'الاسم بالكامل',
                        hint: 'أحمد محمد',
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      CustomTextField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        hint: 'example@domain.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'حفظ التعديلات',
                        onPressed: _updateProfile,
                        isLoading: state is ProfileLoading,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
