#include <flutter/runtime_effect.glsl>
precision mediump float;

out vec4 fragColor;

uniform sampler2D inputImageTexture;
uniform mediump sampler2D inputTextureCubeData;

layout(location = 0) uniform highp float inputExposure;
layout(location = 1) uniform lowp float inputContrast;
layout(location = 2) uniform float inputSaturation;
layout(location = 3) uniform float inputTemperature;
layout(location = 4) uniform float inputTint;
layout(location = 5) uniform lowp float inputIntensity;
layout(location = 6) uniform vec2 screenSize;

// Values from \Graphics Shaders: Theory and Practice\ by Bailey and Cunningham
const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);
const lowp vec3 warmFilter = vec3(0.93, 0.54, 0.0);
const mediump mat3 RGBtoYIQ = mat3(0.299, 0.587, 0.114, 0.596, -0.274, -0.322, 0.212, -0.523, 0.311);
const mediump mat3 YIQtoRGB = mat3(1.0, 0.956, 0.621, 1.0, -0.272, -0.647, 1.0, -1.105, 1.702);
float newColor(float v1, float v2) {
    float lr = 2.0 * v1 * v2;
    float gr = 1.0 - 2.0 * (1.0 - v1) * (1.0 - v2);
    return v1 < 0.5 ? lr : gr;
}
const float cubeSize = 8.0;
const float cubeRows = 64.0;
const float cubeColumns = 8.0;
const vec2 sliceSize = vec2(1.0 / 8.0, 1.0 / 64.0);
vec2 computeSliceOffset(float slice, vec2 sliceSize) {
  return sliceSize * vec2(mod(slice, cubeColumns),
                          floor(slice / cubeColumns));
}
vec4 sampleAs3DTexture(vec3 textureColor) {
  float slice = textureColor.b * 511.0;
  float zOffset = fract(slice);                         // dist between slices
  vec2 slice0Offset = computeSliceOffset(floor(slice), sliceSize);
  vec2 slice1Offset = computeSliceOffset(ceil(slice), sliceSize);
  vec2 slicePixelSize = sliceSize / cubeSize;               // space of 1 pixel
  vec2 sliceInnerSize = slicePixelSize * (cubeSize - 1.0);  // space of size pixels
  vec2 uv = slicePixelSize * 0.5 + textureColor.xy * sliceInnerSize;
  vec2 texPos1 = slice0Offset + uv;
  vec2 texPos2 = slice1Offset + uv;
  vec4 slice0Color = texture(inputTextureCubeData, texPos1);
  vec4 slice1Color = texture(inputTextureCubeData, texPos2);
  return mix(slice0Color, slice1Color, zOffset);
}

vec4 processColor0(vec4 sourceColor){
    return vec4(sourceColor.rgb * pow(2.0, inputExposure), sourceColor.w);
}
vec4 processColor1(vec4 sourceColor){
    return vec4(((sourceColor.rgb - vec3(0.5)) * inputContrast + vec3(0.5)), sourceColor.w);
}
vec4 processColor2(vec4 sourceColor){
   lowp float luminance = dot(sourceColor.rgb, luminanceWeighting);
   lowp vec3 greyScaleColor = vec3(luminance);
   return vec4(mix(greyScaleColor, sourceColor.rgb, inputSaturation), sourceColor.w);
}
vec4 processColor3(vec4 sourceColor){
   mediump vec3 yiq = RGBtoYIQ * sourceColor.rgb; //adjusting inputTint
   yiq.b = clamp(yiq.b + inputTint*0.5226*0.1, -0.5226, 0.5226);
   lowp vec3 rgb = YIQtoRGB * yiq;
   lowp vec3 processed = vec3(
    newColor(rgb.r, warmFilter.r),
    newColor(rgb.g, warmFilter.g),
    newColor(rgb.b, warmFilter.b));
   return vec4(mix(rgb, processed, inputTemperature), sourceColor.a);
}
vec4 processColor4(vec4 sourceColor){
   vec2 textSize = textureSize(inputTextureCubeData, 0);
   if (textSize.x == 1.0 || textSize.y == 1.0) {
       return sourceColor;
   }
   vec4 newColor = sampleAs3DTexture(clamp(sourceColor.rgb, 0.0, 1.0));
   return mix(sourceColor, vec4(newColor.rgb, sourceColor.w), inputIntensity);
}

void main(){
	vec2 textureCoordinate = FlutterFragCoord().xy / screenSize;
	vec4 textureColor = texture(inputImageTexture, textureCoordinate);
	vec4 processedColor0 = processColor0(textureColor);
	vec4 processedColor1 = processColor1(processedColor0);
	vec4 processedColor2 = processColor2(processedColor1);
	vec4 processedColor3 = processColor3(processedColor2);
	vec4 processedColor4 = processColor4(processedColor3);
	fragColor = processedColor4;
}