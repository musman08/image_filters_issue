import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:image_filters/src/widgets/filter_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ShaderConfiguration configuration;
  late TextureSource textureSource;
  bool isLoading = true;

  @override
  void dispose() {
    configuration.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    prepare();
  }

  Future<void> prepare() async {
    configuration = BrightnessContrastShaderConfiguration();
    await configuration.prepare();
    textureSource = await TextureSource.fromAsset('assets/images/example.jpg');
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        if (isLoading) return Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 220,
                child: ImageShaderPreview(
                  texture: textureSource,
                  configuration: configuration,
                ),
              ),
              SizedBox(height: 30),
              ...configuration.children((cv) {
                cv.update(configuration);
                setState(() {});
              }),
            ],
          ),
        );
      }(),
    );
  }
}

class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
    : super([
        WhiteBalanceShaderConfiguration()
          ..tint = 50
          ..temperature = 0,
        ExposureShaderConfiguration(),
        ContrastShaderConfiguration(),
        SaturationShaderConfiguration(),
      ]);
}
