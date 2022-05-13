import 'package:cuidapet_mobile/app/core/ui/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CuidapetTextformField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final ValueNotifier<bool> _obscureTextVN;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  CuidapetTextformField({
    Key? key,
    required this.label,
    this.obscureText = false,
    this.controller,
    this.validator
  })  : _obscureTextVN = ValueNotifier<bool>(obscureText),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureTextVN,
      builder: (_, obscureTextVNValue, child) {
        return TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureTextVNValue,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                // gapPadding: 0,
              ),
              //! quando tiver com o foco
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                gapPadding: 0,
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                gapPadding: 0,
                borderSide: const BorderSide(color: Colors.red),
                
              ),
              //hintText: 'Nome'
              suffixIcon: obscureText
                  ? IconButton(
                      onPressed: () {
                        _obscureTextVN.value = !obscureTextVNValue;
                      },
                      icon: Icon(
                        obscureTextVNValue ? Icons.lock : Icons.lock_open,
                        color: context.primaryColor,
                      ),
                    )
                  : null),
        );
      },
    );
  }
}
