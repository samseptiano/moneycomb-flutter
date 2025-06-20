import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:money_comb/ui/page/home_screen.dart';

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
            MaterialPageRoute(builder: (context) => HomeScreen())));
    super.initState();
  }

 Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(32), // Add margin here
        child: SizedBox(
          child: LottieBuilder.asset(
            'assets/lottie/lottie_splashscreen.json',
            repeat: false,
            animate: true,
          ),
        ),
      ),
    ),
  );
}
}
