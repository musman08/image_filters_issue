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
