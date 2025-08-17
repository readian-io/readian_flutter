import 'package:flutter/material.dart';

class ReadianTextField extends StatefulWidget {
  const ReadianTextField({
    super.key,
    required this.labelText,
    this.hasError = false,
    this.obscureText = false,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final String labelText;
  final bool hasError;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;
  final EdgeInsetsGeometry padding;

  @override
  State<ReadianTextField> createState() => _ReadianTextFieldState();
}

class _ReadianTextFieldState extends State<ReadianTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  void didUpdateWidget(ReadianTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _isObscured = widget.obscureText;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: widget.padding,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          labelText: widget.labelText,
          errorText: widget.hasError ? '' : null,
          floatingLabelStyle: widget.hasError
              ? TextStyle(color: theme.colorScheme.error)
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: widget.hasError ? theme.colorScheme.error : null,
                  ),
                  onPressed: _togglePasswordVisibility,
                  color: theme.colorScheme.outline,
                )
              : null,
        ),
      ),
    );
  }
}
