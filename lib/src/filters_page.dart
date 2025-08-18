import 'dart:io';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_filters/flutter_image_filters.dart';
import 'package:gal/gal.dart';
import 'package:image_filters/src/widgets/filter_widgets.dart';
import 'package:image_filters/src/widgets/preset_dropdown_widget.dart';
import 'package:image_filters/src/widgets/saved_file_preview.dart';
import 'package:path_provider/path_provider.dart';

import '../main.config.dart';
import 'package:image/image.dart' as img;
import 'Utils/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ShaderConfiguration configuration;
  late TextureSource textureSource;
  bool isLoading = false;
  String? filePath;

  ImageFilter? filter;

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
    print('lane 1 executed');
    log('lane 1 executed');
    isLoading = true;
    setState(() {});
    filePath = 'assets/images/example2.jpg';
    textureSource = await TextureSource.fromAsset(
      filePath ?? 'assets/images/example.jpg',
    );
    configuration =
        ExposureContrastSaturationWhiteBalanceHALDLookupShaderConfiguration();
    // configuration = BrightnessContrastShaderConfiguration();
    // await configuration.prepare();
    // textureSource = await TextureSource.fromAsset(filePath);
    isLoading = false;
    setState(() {});
  }

  Future<void> applyLut(String? lookupPath) async {
    final lookUpImageConfig =
        ((configuration.parameters.where(
          (e) => e.displayName == 'HALD LUT',
        ))).first;
    final intensityConfig =
        ((configuration.parameters.where(
          (e) => e.displayName == 'intensity',
        ))).first;

    if (lookUpImageConfig is ShaderTextureParameter) {
      if (lookupPath == null) {
        lookUpImageConfig.textureSource = null;
      } else {
        lookUpImageConfig.textureSource = await TextureSource.fromAsset(
          lookupPath,
        );
      }
    }

    if (intensityConfig is ShaderRangeNumberParameter) {
      if (lookupPath == null) {
        intensityConfig.value = 0;
      } else {
        intensityConfig.value = 1;
      }
    }

    ///
    // final lookUpImageConfig = _getConfig(configuration, );
    // final intensityConfig = _getConfig(configuration, 'intensity');
    // if (lookUpImageConfig is ShaderTextureParameter) {
    //   previousValue ??= lookUpImageConfig.file?.path;
    //   newValue = value;
    //   lookUpImageConfig.file = File(value);
    //   // lookUpImageConfig.textureSource = null;
    //   // if (value == null) {
    //   //   lookUpImageConfig.textureSource = null;
    //   // }
    //   if (intensityConfig is ShaderRangeNumberParameter) {
    //     if (previousIntensityValue == 1.0) {
    //       previousIntensityValue = (Platform.isIOS ? 0 : 1);
    //       // previousIntensityValue = 0;
    //     }
    //     // newIntensityValue = noPreset ? 0 : 0.99;
    //     newIntensityValue = noPreset ? (Platform.isIOS ? 0 : 0.01) : 0.99;
    //     // intensityConfig.value = noPreset ? 0 : 0.99;
    //     intensityConfig.value = noPreset ? (Platform.isIOS ? 0 : 0.01) : 0.99;
    //     print(
    //       'previous value 5: ${intensityConfig.value} ${lookUpImageConfig.file?.path} ${previousIntensityValue} ${newIntensityValue}',
    //     );
    ///
    await lookUpImageConfig.update(configuration);
    await intensityConfig.update(configuration);
  }

  Future<void> pickFile() async {
    final file = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (file != null && file.paths.isNotEmpty) {
      filePath = file.paths.first;
      prepare();
    }
  }

  Future<void> save() async {
    showDialog(
      context: context,
      builder:
          (context) =>
              Dialog(child: Center(child: CircularProgressIndicator())),
    );
    final image = await configuration.export(textureSource, textureSource.size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // final fileName = '${timestamp}_thumbnail.png';
    final fileName = '${timestamp}_thumbnail.jpg';
    final tempDir = await getTemporaryDirectory();
    final filePathTemp = '${tempDir.path}/${fileName}';
    final file = File(filePathTemp);
    // await file.writeAsBytes(pngBytes);
    ///
    final img.Image? imageBytes = img.decodeImage(pngBytes);
    if (imageBytes != null) {
      final List<int> jpgBytes = img.encodeJpg(imageBytes);
      // Create a new File for the JPG image
      final File jpgFile = File(filePathTemp);

      // Write the JPG bytes to the new file
      await jpgFile.writeAsBytes(jpgBytes);
      await Gal.putImage(filePathTemp);
      Navigator.of(context).pop();
      SavedFilePreviewDialog(filePath: filePathTemp).show(context);
      // await Gal.putImageBytes(jpgBytes, name: fileName);

      // jpgFile;
    }

    ///
    // final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    // final fileName = '${timestamp}_thumbnail.png';
    // final tempDir = await getTemporaryDirectory();
    // final filePathTemp = '${tempDir.path}/${fileName}';
    // final file = File(filePathTemp);
    // await file.writeAsBytes(pngBytes);

    // SavedFilePreviewDialog(filePath: filePathTemp).show(context);
    // await Gal.putImageBytes(pngBytes, name: fileName);
  }

  // Future<File?> convertPngToJpg(Uint8List pngBytes) async {
  //   try {
  //     // Read the PNG image bytes
  //     // final List<int> pngBytes = await pngFile.readAsBytes();
  //
  //     // Decode the image
  //     final img.Image? image = img.decodeImage(pngBytes);
  //
  //     if (image != null) {
  //       // Encode the image as JPG
  //       final List<int> jpgBytes = img.encodeJpg(image);
  //
  //       // Create a new File for the JPG image
  //       final String jpgPath = pngFile.path.replaceAll('.png', '.jpg');
  //       final File jpgFile = File(jpgPath);
  //
  //       // Write the JPG bytes to the new file
  //       await jpgFile.writeAsBytes(jpgBytes);
  //
  //       return jpgFile;
  //     } else {
  //       print('Failed to decode PNG image.');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error converting PNG to JPG: $e');
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        if (isLoading) return Center(child: CircularProgressIndicator());
        if (filePath?.isNotEmpty ?? false){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ElevatedButton(
                      //   onPressed: pickFile,
                      //   child: Text('Pick Image'),
                      // ),
                      SizedBox(
                        width: 100,
                        child: ResolutionDropDownWidget(
                          onChange: (v) {
                            filter = v;
                            applyLut(v?.path);
                          },
                          filter: filter,
                        ),
                      ),
                      ElevatedButton(child: Text('Save'), onPressed: save),
                    ],
                  ),
                  SizedBox(height: 30),
                  if (filePath?.isNotEmpty ?? false) ...[
                    Text('Simple Image preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                    SizedBox(height: 350,
                      child: Image.asset(filePath!),
                    ),
                    SizedBox(height: 20),
                    Text('Image Shader Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),),
                    SizedBox(
                      height: 350,
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
                ],
              ),
            ),
          );
        }else{
          return Center(
            child: ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick Image'),
            ),
          );
        }
      }(),
    );
  }
}

class BrightnessContrastShaderConfiguration extends BunchShaderConfiguration {
  BrightnessContrastShaderConfiguration()
    : super([
        ExposureShaderConfiguration(),
        ContrastShaderConfiguration(),
        SaturationShaderConfiguration(),
        WhiteBalanceShaderConfiguration()
          ..tint = 50
          ..temperature = 6500,
        HALDLookupTableShaderConfiguration(),
      ]);
}
