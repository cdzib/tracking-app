import 'package:flutter/material.dart';

class LiveBadge extends StatelessWidget {
  final bool isConnected;
  final void Function()? onTap;
  final Animation<double>? pulseAnim;
  const LiveBadge({this.isConnected = false, this.onTap, this.pulseAnim, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isConnected
              ? const Color(0xFF4CD964).withOpacity(0.14)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF4CD964).withOpacity(0.24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (pulseAnim != null)
              AnimatedBuilder(
                animation: pulseAnim!,
                builder: (_, __) => Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (isConnected ? const Color(0xFF4CD964) : Colors.redAccent ).withOpacity(pulseAnim!.value),
                    boxShadow: [
                      BoxShadow(
                        color: (isConnected ? const Color(0xFF4CD964) : Colors.redAccent ).withOpacity(pulseAnim!.value * 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              )
            else
              Icon(
                Icons.circle,
                color: isConnected ? const Color(0xFF4CD964) : Colors.redAccent,
                size: 9,
              ),
            const SizedBox(width: 6),
            Text(
              isConnected ? 'EN VIVO' : 'DESCONECTADO',
              style: TextStyle(
                color: isConnected ? const Color(0xFF4CD964) : Colors.redAccent,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
