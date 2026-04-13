import 'package:flutter/material.dart';
import 'package:flutter_app/core/state/restaurant_app_state.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/widgets/status_chip.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Nadia Toumi');
    _emailController = TextEditingController(text: 'nadia@aurumtable.app');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: SurfaceCard(
                radius: 36,
                padding: const EdgeInsets.all(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color(0xFF1B202A), Color(0xFF11141B)],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const StatusChip(
                        label: 'Member access',
                        icon: Icons.workspace_premium_rounded,
                        backgroundColor: Color(0xFF241B12),
                        foregroundColor: Color(0xFFF6C56B),
                        borderColor: Color(0xFF4A3320),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome back to Aurum Table',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sign in to restore your saved rooms, active order, and reservation history on this device.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (String? value) {
                          final String trimmed = value?.trim() ?? '';
                          if (trimmed.length < 2) {
                            return 'Enter the name used for reservations.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                        validator: (String? value) {
                          final String email = value?.trim() ?? '';
                          final RegExp emailPattern = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (!emailPattern.hasMatch(email)) {
                            return 'Enter a valid email address.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(appState),
                      ),
                      const SizedBox(height: 22),
                      FilledButton(
                        onPressed: () => _submit(appState),
                        child: const Text('Sign in'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(RestaurantAppState appState) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    appState.signIn(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
  }
}
