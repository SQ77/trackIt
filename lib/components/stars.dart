import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';

class StarsEffect extends StatefulWidget {
  const StarsEffect({super.key});

  @override
  State<StarsEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<StarsEffect> {
  @override
  void initState() {
    super.initState();
    _shootStars();
  }

  void _shootStars() {
    const options = ConfettiOptions(
      spread: 360,
      ticks: 50,
      gravity: 0,
      decay: 0.94,
      startVelocity: 30,
      colors: [
        Color(0xffFFE400),
        Color(0xffFFBD00),
        Color(0xffE89400),
        Color(0xffFFCA6C),
        Color(0xffFDFFB8),
      ],
    );

    void shoot() {
      Confetti.launch(
        context,
        options: options.copyWith(particleCount: 40, scalar: 1.2),
        particleBuilder: (index) => Star(),
      );
      Confetti.launch(
        context,
        options: options.copyWith(particleCount: 10, scalar: 0.75),
        particleBuilder: (index) => Star(),
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
