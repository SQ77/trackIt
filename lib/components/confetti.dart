import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class ConfettiEffect extends StatefulWidget {
  const ConfettiEffect({super.key});

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect> {
  @override
  void initState() {
    super.initState();
    _shootConfetti();
  }

  void _shootConfetti() {
    void shoot() {
      Confetti.launch(
        context,
        options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6),
      );
    }

    Timer(Duration.zero, shoot);
    Timer(const Duration(milliseconds: 100), shoot);
    Timer(const Duration(milliseconds: 200), shoot);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
