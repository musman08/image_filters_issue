import 'package:image_filters/src/const/constants.dart';

enum ImageFilter {
  drama('Drama', AppImages.drama),
  warm('Warm', AppImages.warm),
  cool('Cool', AppImages.cool),
  waves('Waves', AppImages.waves);

  final String name;
  final String path;
  const ImageFilter(this.name, this.path);
}

enum ExampleImage {
  example3('Color Issue after export', AppExampleImages.example3),
  example2('Unwanted sharpness', AppExampleImages.example2),
  example('Sample Image', AppExampleImages.example);

  final String name;
  final String path;
  const ExampleImage(this.name, this.path);
}
