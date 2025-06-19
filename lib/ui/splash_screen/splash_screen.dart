import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:money_comb/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4)).then((value) =>
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SqFliteDemo())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: LottieBuilder.asset(
            'assets/lottie/lottie_splashscreen.json',
            repeat: false,
            animate: true,
          ),
        ),
      ),
    );
  }
}
