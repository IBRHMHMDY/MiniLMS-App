import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/core/widgets/custom_button.dart';
import 'package:mini_lms_app/core/widgets/custom_text_field.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:mini_lms_app/features/auth/presentation/widgets/auth_header.dart';


class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        ResetPasswordRequested(
          email: widget.email,
          token: _tokenController.text,
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعيين كلمة مرور جديدة')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              context.go('/login'); // العودة لشاشة تسجيل الدخول
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
                      title: 'كلمة مرور جديدة',
                      subtitle: 'أدخل الرمز المرسل وكلمة المرور الجديدة',
                    ),
                    CustomTextField(
                      controller: _tokenController,
                      label: 'رمز الاستعادة (OTP)',
                      hint: '123456',
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور الجديدة',
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
                        if (value != _passwordController.text){
                          return 'كلمات المرور غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'حفظ وتغيير',
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
