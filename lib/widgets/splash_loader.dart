import 'package:flutter/material.dart';

import 'custom_loader.dart';

class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CustomLoader(),
      ),
    );
  }
}
