import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../Utils/utils.dart';

class ResolutionDropDownWidget extends StatefulWidget {
  const ResolutionDropDownWidget({
    super.key,
    required this.filter,
    required this.onChange,
  });

  // final ResolutionValue value;

  final ImageFilter? filter;
  final void Function(ImageFilter? filter) onChange;

  @override
  State<ResolutionDropDownWidget> createState() =>
      _ResolutionDropDownWidgetState();
}

class _ResolutionDropDownWidgetState extends State<ResolutionDropDownWidget> {
  ImageFilter? _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ImageFilter>(
        isExpanded: true,
        hint: Row(children: [Expanded(child: Text('Lookup Image'))]),
        items: [
          DropdownMenuItem(value: null, child: Text('select')),
          ...ImageFilter.values.map(
            (ImageFilter item) => DropdownMenuItem<ImageFilter>(
              value: item,
              child: Text(item.name.toString()),
            ),
          ),
        ],
        value: _filter,
        onChanged: (v) {
          _filter = v;
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
          width: 90,
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
