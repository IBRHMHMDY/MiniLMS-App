import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_lms_app/core/widgets/custom_button.dart';
import 'package:mini_lms_app/core/widgets/custom_text_field.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_lms_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:mini_lms_app/features/auth/presentation/widgets/auth_header.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess || state is AuthAuthenticated) {
              context.go('/home');
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
                      title: 'مرحباً بك مجدداً',
                      subtitle: 'قم بتسجيل الدخول لمتابعة تعلمك',
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
                      isPassword: true, // ستظهر أيقونة الإظهار/الإخفاء تلقائياً
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                    // إضافة رابط نسيت كلمة المرور هنا
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'تسجيل الدخول',
                      onPressed: _submit,
                      isLoading: state is AuthLoading,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('ليس لديك حساب؟ إنشاء حساب جديد'),
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
