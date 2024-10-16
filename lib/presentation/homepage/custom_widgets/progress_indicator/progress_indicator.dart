import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    super.key,
    required this.progressText,
  });

  final String progressText;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 38.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Text(
                progressText,
                style: themeData.textTheme.bodyLarge!,
              ),
            ),
            LinearProgressIndicator(
              color: themeData.colorScheme.primary,
              backgroundColor: themeData.colorScheme.secondary,
              borderRadius: BorderRadius.circular(3),
            ),
            /* CircularProgressIndicator(
              color: themeData.colorScheme.secondary,
            ),*/
          ],
        ),
      ),
    );
  }
}