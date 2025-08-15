import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gpu_filters_interface/flutter_gpu_filters_interface.dart';

extension ParametersContainer on FilterConfiguration {
  Iterable<Widget> children(void Function(ConfigurationParameter) onChanged) {
    // for (final p in parameters) {
    //   print(
    //     'RUNTIMETYPE :${p.runtimeType} ${p is NumberParameter} ${p.hidden} ${p is RangeNumberParameter}',
    //   );
    // }

    final numbers = parameters
        .whereNot((e) => e.hidden)
        .whereType<NumberParameter>()
        .whereNot((e) => e is RangeNumberParameter)
        .map(
          (e) => NumberParameterWidget(
            parameter: e,
            onChanged: () {
              onChanged.call(e);
            },
          ),
        );
    // final datas = parameters.whereType<DataParameter>().map(
    //   (e) => BlocProvider(
    //     create: (context) => DataBlocCubit(e, this, onChanged: onChanged),
    //     child: DataDropdownButtonWidget(parameter: e),
    //   ),
    // );
    // final variations = parameters.whereType<OptionStringParameter>().map(
    //   (e) => BlocProvider(
    //     create: (context) => StringOptionCubit(e, this),
    //     child: StringOptionDropdownButtonWidget(parameter: e),
    //   ),
    // );
    // final colors = parameters.whereType<ColorParameter>().map(
    //   (e) => ColorParameterWidget(
    //     parameter: e,
    //     onChanged: () {
    //       onChanged.call(e);
    //     },
    //   ),
    // );
    // parameters.forEach((e) {
    //   dev.log('PARAMETER TYPE :${e.runtimeType}');
    // });
    final params = parameters
        .whereNot((e) => e.hidden)
        .whereNot((e) => e is NumberParameter && e is! RangeNumberParameter)
        .whereNot((e) => e is DataParameter)
        .whereNot((e) => e is ColorParameter)
        .whereNot((e) => e is OptionStringParameter)
        .map((e) {
          if (e is RangeNumberParameter) {
            return SliderNumberParameterWidget(
              parameter: e,
              onChanged: () {
                onChanged.call(e);
              },
            );
          } else if (e is PointParameter) {
            // return PointParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is SizeParameter) {
            // return SizeParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          }
          if (e is RectParameter) {
            // return RectParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is Mat7Parameter) {
            // return Mat7ParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is Mat5Parameter) {
            // return Mat5ParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is Mat3Parameter) {
            // return Mat3ParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is Mat4Parameter) {
            // return Mat4ParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is BoolParameter) {
            // return BoolParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          } else if (e is ListParameter) {
            // return ListParameterWidget(
            //   parameter: e,
            //   onChanged: () {
            //     onChanged.call(e);
            //   },
            // );
          }
          return Text('Unknown: ${e.displayName}');
        });

    return [
      // if (numbers.isNotEmpty ||
      //     datas.isNotEmpty ||
      //     colors.isNotEmpty ||
      //     variations.isNotEmpty)
      //   Wrap(
      //     spacing: 8,
      //     runSpacing: 12,
      //     children: [...numbers, ...datas, ...colors, ...variations],
      //   ),
      ...numbers,
      ...params,
    ];
  }
}

class SliderNumberParameterWidget extends StatelessWidget {
  final RangeNumberParameter parameter;
  final VoidCallback onChanged;

  const SliderNumberParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 3,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              parameter.displayName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Slider(
            label: parameter.value.toDouble().toStringAsFixed(3),
            value: parameter.value.toDouble(),
            max: parameter.max?.toDouble() ?? double.infinity,
            min: parameter.min?.toDouble() ?? double.minPositive,
            onChanged: (value) {
              parameter.value = value;
              onChanged.call();
            },
          ),
        ),
        Text(
          parameter.value.toStringAsFixed(1),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NumberParameterWidget extends StatelessWidget {
  final NumberParameter parameter;
  final VoidCallback onChanged;
  const NumberParameterWidget({
    super.key,
    required this.parameter,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: max(MediaQuery.of(context).size.width / 2 - 16, 170),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: parameter.displayName,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: InkWell(
            onTap: () {
              parameter.value -= 0.05;
              onChanged.call();
            },
            child: const Icon(Icons.arrow_downward),
          ),
          contentPadding: EdgeInsets.zero,
          prefixIconColor: Theme.of(context).primaryColor,
          suffixIconColor: Theme.of(context).primaryColor,
          suffixIcon: InkWell(
            onTap: () {
              parameter.value += 0.05;
              onChanged.call();
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),
        onSubmitted: (inputValue) {
          final value = double.tryParse(inputValue);
          if (value != null) {
            parameter.value = value;
            onChanged.call();
          }
        },
        keyboardType: TextInputType.number,
        controller: TextEditingController(
          text: parameter.value.toStringAsFixed(3),
        ),
      ),
    );
  }
}
