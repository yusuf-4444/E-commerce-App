import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.suffix,
    this.obscureText,
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final Widget? suffix;
  final bool? obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          obscureText: widget.obscureText ?? false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${widget.title} can't be empty";
            }
            return null;
          },
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(widget.icon),
            suffixIcon: widget.suffix,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
