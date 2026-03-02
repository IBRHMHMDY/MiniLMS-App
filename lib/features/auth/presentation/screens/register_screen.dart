import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إنشاء الحساب بنجاح!')),
              );
              // TODO: Navigate to Home
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const AuthHeader(
                      title: 'حساب جديد',
                      subtitle: 'انضم إلينا وابدأ رحلة التعلم',
                    ),
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
                    CustomTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hint: '******',
                      isPassword: true,
                      validator: (value) => value!.length < 8
                          ? 'يجب أن تكون 8 أحرف على الأقل'
                          : null,
                    ),
                    CustomTextField(
                      controller: _passwordConfirmController,
                      label: 'تأكيد كلمة المرور',
                      hint: '******',
                      isPassword: true,
                      validator: (value) {
                        if (value != _passwordController.text)
                          return 'كلمات المرور غير متطابقة';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'تسجيل',
                      onPressed: _submit,
                      isLoading: state is AuthLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
