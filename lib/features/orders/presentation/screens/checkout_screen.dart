import 'package:flutter/material.dart';
import 'package:flutter_app/app/navigation/app_navigator.dart';
import 'package:flutter_app/core/state/restaurant_app_scope.dart';
import 'package:flutter_app/shared/utils/app_formatters.dart';
import 'package:flutter_app/shared/widgets/selectable_filter_chip.dart';
import 'package:flutter_app/shared/widgets/section_header.dart';
import 'package:flutter_app/shared/widgets/surface_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;
  String _selectedFulfillment = 'Express delivery';
  String _selectedPayment = 'Visa •••• 4421';

  static const List<String> _fulfillmentOptions = <String>[
    'Express delivery',
    'Pickup',
    'Table service',
  ];

  static const List<String> _paymentOptions = <String>[
    'Visa •••• 4421',
    'Dining wallet',
  ];

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = RestaurantAppScope.watch(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: <Widget>[
          const SectionHeader(
            title: 'Choose fulfillment',
            subtitle: 'Select how you want tonight’s order to be completed.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _fulfillmentOptions
                .map(
                  (String option) => SelectableFilterChip(
                    label: option,
                    selected: _selectedFulfillment == option,
                    onTap: () => setState(() => _selectedFulfillment = option),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Payment method',
            subtitle: 'Keep checkout friction low with a saved payment option.',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _paymentOptions
                .map(
                  (String option) => SelectableFilterChip(
                    label: option,
                    selected: _selectedPayment == option,
                    onTap: () => setState(() => _selectedPayment = option),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Order note',
            subtitle: 'Add delivery, pacing, or plating instructions if needed.',
          ),
          const SizedBox(height: 14),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _noteController,
                maxLines: 4,
                maxLength: 140,
                decoration: const InputDecoration(
                  labelText: 'Optional note',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                  hintText: 'Call on arrival, no cutlery needed, or hold for pickup',
                ),
                validator: (String? value) {
                  final String text = value?.trim() ?? '';
                  if (text.length > 140) {
                    return 'Keep the note under 140 characters.';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 28),
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Final summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _SummaryRow(
                  label: 'Subtotal',
                  value: AppFormatters.currencyMad(appState.subtotalMad),
                ),
                const SizedBox(height: 10),
                _SummaryRow(
                  label: 'Service fee',
                  value: AppFormatters.currencyMad(appState.serviceFeeMad),
                ),
                const SizedBox(height: 10),
                _SummaryRow(
                  label: 'Delivery',
                  value: AppFormatters.currencyMad(appState.deliveryFeeMad),
                ),
                const Divider(height: 28),
                _SummaryRow(
                  label: 'Total',
                  value: AppFormatters.currencyMad(appState.totalMad),
                  highlight: true,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final receipt = appState.placeOrder(
                      fulfillmentLabel: _selectedFulfillment,
                      paymentLabel: _selectedPayment,
                      orderNote: _noteController.text.trim(),
                    );
                    if (receipt == null) {
                      return;
                    }
                    AppNavigator.showOrderConfirmation(
                      context,
                      receipt: receipt,
                    );
                  },
                  child: const Text('Confirm order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = highlight
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: const Color(0xFFF6C56B))
        : Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFFF8F1E7),
          );

    return Row(
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
