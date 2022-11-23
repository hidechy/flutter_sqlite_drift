import 'package:flutter/material.dart';

class CustomDatePickerFormField extends StatelessWidget {
  const CustomDatePickerFormField({
    super.key,
    required this.controller,
    required this.txtLabel,
    required this.callback,
  });

  final TextEditingController controller;
  final String txtLabel;
  final VoidCallback callback;

  ///
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: TextFormField(
        enabled: false,
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(txtLabel),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$txtLabel required';
          }
          return null;
        },
      ),
    );
  }
}
