import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../data/repositories/order_repository.dart';
import '../../auth/viewmodel/auth_view_model.dart';
import '../../cart/viewmodel/cart_view_model.dart';
import '../viewmodel/orders_view_model.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AuthViewModel>().currentUser;
    if (user != null && _nameController.text.isEmpty) {
      _nameController.text = user.displayName;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartViewModel = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Consumer<OrdersViewModel>(
        builder: (context, ordersViewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cash on Delivery', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    'Confirm delivery details and place your order. Payment will be collected on delivery.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _field(_nameController, 'Full name', Icons.person_outline),
                          const SizedBox(height: 14),
                          _field(_emailController, 'Email', Icons.mail_outline),
                          const SizedBox(height: 14),
                          _field(_phoneController, 'Phone number', Icons.phone_outlined),
                          const SizedBox(height: 14),
                          _field(_addressController, 'Delivery address', Icons.location_on_outlined, maxLines: 2),
                          const SizedBox(height: 14),
                          _field(_cityController, 'City', Icons.location_city_outlined),
                          const SizedBox(height: 14),
                          _field(_notesController, 'Order notes (optional)', Icons.sticky_note_2_outlined, maxLines: 3, required: false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order Summary', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 14),
                          ...cartViewModel.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('${item.product.name} x${item.quantity}'),
                                  ),
                                  Text(formatPrice(item.subtotal)),
                                ],
                              ),
                            );
                          }),
                          const Divider(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Payment method'),
                              Text(
                                'Cash on Delivery',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total'),
                              Text(
                                formatPrice(cartViewModel.totalPrice),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (ordersViewModel.errorMessage != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      ordersViewModel.errorMessage!,
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
                      onPressed: ordersViewModel.isSubmitting ? null : () => _submit(context, ordersViewModel, cartViewModel),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          ordersViewModel.isSubmitting ? 'Placing order...' : 'Place COD Order',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (!required) {
          return null;
        }
        if (value == null || value.trim().isEmpty) {
          return 'Enter $label';
        }
        return null;
      },
    );
  }

  Future<void> _submit(
    BuildContext context,
    OrdersViewModel ordersViewModel,
    CartViewModel cartViewModel,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ordersViewModel.placeCashOnDeliveryOrder(
      input: CheckoutInput(
        customerName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        notes: _notesController.text.trim(),
      ),
      items: cartViewModel.items,
    );

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully with cash on delivery.')),
    );
    Navigator.pop(context);
  }
}
