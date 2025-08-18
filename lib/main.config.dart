// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// BunchShaderConfigurationsGenerator
// **************************************************************************

import 'dart:ui';

import 'package:flutter_image_filters/flutter_image_filters.dart';

class ExposureContrastSaturationWhiteBalanceHALDLookupShaderConfiguration
    extends BunchShaderConfiguration {
  ExposureContrastSaturationWhiteBalanceHALDLookupShaderConfiguration()
    : super([
        ExposureShaderConfiguration()..exposure = 0,
        ContrastShaderConfiguration()..contrast = 1,
        SaturationShaderConfiguration(),
        WhiteBalanceShaderConfiguration(),
        HALDLookupTableShaderConfiguration(),
      ]);

  ExposureShaderConfiguration get exposureShader => configuration(at: 0);

  ContrastShaderConfiguration get contrastShader => configuration(at: 1);

  SaturationShaderConfiguration get saturationShader => configuration(at: 2);

  WhiteBalanceShaderConfiguration get whiteBalanceShader =>
      configuration(at: 3);

  HALDLookupTableShaderConfiguration get hALDLookupTableShader =>
      configuration(at: 4);
}

void registerBunchShaders() {
  FlutterImageFilters.register<
    ExposureContrastSaturationWhiteBalanceHALDLookupShaderConfiguration
  >(
    () => FragmentProgram.fromAsset(
      'shaders/exposure_contrast_saturation_white_balance_hald_lookup.frag',
    ),
  );
}
