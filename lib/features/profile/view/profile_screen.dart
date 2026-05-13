import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../orders/viewmodel/orders_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoginMode = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.isLoading) {
          return const SafeArea(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: authViewModel.isAuthenticated
                ? _SignedInView(authViewModel: authViewModel)
                : _buildAuthForm(context, authViewModel),
          ),
        );
      },
    );
  }

  Widget _buildAuthForm(BuildContext context, AuthViewModel authViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Sign in or create an account to sync your shopping data with Firebase.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoginMode ? 'Welcome back' : 'Create your account',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (!isLoginMode) ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (!isLoginMode) {
                          if (value == null || value.trim().length < 3) {
                            return 'Enter your name';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  if (authViewModel.errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      authViewModel.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: authViewModel.isSubmitting ? null : () => _submit(authViewModel),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          authViewModel.isSubmitting
                              ? 'Please wait...'
                              : isLoginMode
                                  ? 'Sign In'
                                  : 'Create Account',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: authViewModel.isSubmitting
                          ? null
                          : () {
                              setState(() {
                                isLoginMode = !isLoginMode;
                              });
                            },
                      child: Text(
                        isLoginMode
                            ? 'Need an account? Sign up'
                            : 'Already have an account? Sign in',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(AuthViewModel authViewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = isLoginMode
        ? await authViewModel.signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          )
        : await authViewModel.signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLoginMode ? 'Signed in successfully.' : 'Account created successfully.',
        ),
      ),
    );
  }
}

class _SignedInView extends StatelessWidget {
  const _SignedInView({
    required this.authViewModel,
  });

  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    final user = authViewModel.currentUser!;
    final ordersViewModel = context.watch<OrdersViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Your account is now connected with Firebase Authentication.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  child: Text(
                    user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : 'G',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                Text(user.displayName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 18),
                Text(
                  'Your cart and orders are now connected to Firebase.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: authViewModel.isSubmitting ? null : authViewModel.signOut,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        authViewModel.isSubmitting ? 'Signing out...' : 'Sign Out',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text('Recent Orders', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (ordersViewModel.orders.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'No orders yet. Place a cash on delivery order from the cart to see it here.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ...ordersViewModel.orders.map((order) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Order #${order.id.substring(0, 6).toUpperCase()}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(order.status),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('${order.items.length} items • ${formatPrice(order.totalAmount)}'),
                      const SizedBox(height: 6),
                      Text('Payment: ${order.paymentMethod}'),
                      const SizedBox(height: 6),
                      Text('Deliver to: ${order.address}, ${order.city}'),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
