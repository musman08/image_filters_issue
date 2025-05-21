import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_filters/src/filters_page.dart';

void main() {
  FlutterImageFilters.register<BrightnessContrastShaderConfiguration>(
    () => FragmentProgram.fromAsset(
      'shaders/white_balance_exposure_contrast_saturation.frag',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
