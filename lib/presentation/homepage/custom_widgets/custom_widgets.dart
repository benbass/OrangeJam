import 'dart:ui';

import 'package:flutter/material.dart';

/// This is the main dialog widget:
class CustomDialog extends StatelessWidget {
  final bool? scrollable;
  final Widget content;
  final List<Widget> actions;
  final bool showDropdown;
  final Widget titleWidget;
  final ThemeData themeData;

  const CustomDialog({
    super.key,
    this.scrollable,
    required this.content,
    required this.actions,
    required this.showDropdown,
    required this.titleWidget,
    required this.themeData,
  });

  @override
  Widget build(BuildContext context) {
    // BackdropFilter: creates a blur behinds the child (iOS like)
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
      child: SingleChildScrollView(
        child: AlertDialog(
          scrollable: scrollable ?? false,
          title: titleWidget,
          backgroundColor:
              themeData.dialogTheme.backgroundColor!.withOpacity(0.98),
          content: SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                content,
                if (showDropdown) const Placeholder() // DropDown?
              ],
            ),
          ),
          actions: actions,
        ),
      ),
    );
  }
}

/// This is the dialog title
class DescriptionText extends StatelessWidget {
  const DescriptionText({
    super.key,
    required this.themeData,
    required this.description,
  });

  final ThemeData themeData;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: themeData.dialogTheme.titleTextStyle,
    );
  }
}

/// just a button with style
class SimpleButton extends StatelessWidget {
  const SimpleButton({
    super.key,
    required this.themeData,
    required this.btnText,
    required this.function,
  });

  final ThemeData themeData;
  final String btnText;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: themeData.textButtonTheme.style,
      child: Text(
        btnText,
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// just a text input
class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.txtController,
    this.autoFocus,
    this.labelText,
    required this.themeData,
  });

  final TextEditingController txtController;
  final bool? autoFocus;
  final String? labelText;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4),
      child: TextFormField(
        controller: txtController,
        autofocus: autoFocus ?? true,
        cursorColor: Colors.white54,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: themeData.textTheme.bodyMedium!,
          floatingLabelStyle: themeData.textTheme.bodyLarge!.copyWith(
            color: const Color(0xFFFF8100),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusColor: Colors.white54,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
        ),
        style: themeData.textTheme.bodyMedium!.copyWith(fontSize: 14),
      ),
    );
  }
}
