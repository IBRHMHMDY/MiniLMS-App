import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';

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
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الدخول بنجاح!')),
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
                      isPassword: true,
                      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 24),
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
