import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String? label;
  final String hint;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;

  // ✅ THÊM
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomInput({
    super.key,
    this.label,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],

        TextField(
          controller: widget.controller, // ✅ FIX LỖI Ở ĐÂY
          keyboardType: widget.keyboardType,
          obscureText: _obscure,

          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.grey),

            prefixIcon: Icon(widget.prefixIcon, color: Colors.grey, size: 20),

            // ✅ TOGGLE PASSWORD 👁️
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : (widget.suffixIcon != null
                      ? Icon(widget.suffixIcon, color: Colors.grey, size: 20)
                      : null),

            filled: true,
            fillColor: const Color(0xFFF8F7F5),

            contentPadding: const EdgeInsets.symmetric(vertical: 16),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF7B00), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
