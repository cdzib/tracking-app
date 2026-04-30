import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Center(
        child: GestureDetector(
          onTap: () => onTap != null ? onTap!() : Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: colorScheme.onSurface.withOpacity(0.12)),
            ),
            child: BackButtonIcon()
          ),
        ),
      ),
    );
  }
}
