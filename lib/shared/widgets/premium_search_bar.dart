import 'package:flutter/material.dart';

class PremiumSearchBar extends StatelessWidget {
  const PremiumSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final bool hasText = controller?.text.isNotEmpty ?? false;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: hasText ? const Color(0xFF2B313C) : const Color(0xFF222833),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: hasText ? onClear : null,
              icon: Icon(
                hasText ? Icons.close_rounded : Icons.tune_rounded,
                size: 18,
              ),
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 52,
          minWidth: 56,
        ),
      ),
    );
  }
}
