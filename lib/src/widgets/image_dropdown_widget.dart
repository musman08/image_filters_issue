import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class ImageDropDownWidget extends StatefulWidget {
  const ImageDropDownWidget({
    super.key,
    required this.exampleImage,
    required this.onChange,
  });

  // final ResolutionValue value;

  final ExampleImage? exampleImage;
  final void Function(ExampleImage? v) onChange;

  @override
  State<ImageDropDownWidget> createState() =>
      _ImageDropDownWidgetState();
}

class _ImageDropDownWidgetState extends State<ImageDropDownWidget> {
  ExampleImage? image;

  @override
  void initState() {
    super.initState();
    image = widget.exampleImage;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ExampleImage>(
        isExpanded: true,
        hint: Row(children: [Expanded(child: Text('Lookup Image'))]),
        items: [
          DropdownMenuItem(
              value: null, child: Text('select'),
          ),
          ...ExampleImage.values.map(
                (ExampleImage item) => DropdownMenuItem<ExampleImage>(
              value: item,
              child: Text(item.name.toString()),
            ),
          ),
        ],
        value: image,
        onChanged: (v) {
          image = v;
          widget.onChange(v);
          setState(() {});
        },
        buttonStyleData: ButtonStyleData(
          height: 36,
          width: 90,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              // color: AppColors.whiteColor.withAlpha(4),
              width: 1,
            ),
            // color: AppColors.dropDownBg,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 14,
          // iconEnabledColor: AppColors.whiteColor,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: AppColors.dropDownBg,
            border: Border.all(
              // color: AppColors.whiteColor.withAlpha(300),
              width: 1,
            ),
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(8),
            thickness: WidgetStateProperty.all<double>(6),
            thumbVisibility: WidgetStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
