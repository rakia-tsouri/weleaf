import 'package:flutter/material.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

import '../constants/colors.dart';
import '../constants/dimens.dart';

class AppCheckBox extends StatefulWidget {
  bool isChecked;
  final String? label;
  final Function(bool?) onChanged;
  final bool isRequired;

  AppCheckBox({
    super.key,
    required this.isChecked,
    this.label,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  @override
  void initState() {
    if (widget.isRequired) {
      widget.isChecked = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isRequired) {
          return;
        }
        setState(() {
          widget.isChecked = !widget.isChecked;
        });
        widget.onChanged(widget.isChecked);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: PADDING_20.widthResponsive(),
            height: PADDING_20.widthResponsive(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BORDER_RADIUS_6),
              border: Border.all(
                color:
                    widget.isChecked ? Colors.transparent : PRIMARY_BLUE_COLOR,
              ),
              color: widget.isChecked
                  ? PRIMARY_BLUE_COLOR
                  : CHECKBOX_BACKGROUND_COLOR,
            ),
            child: widget.isChecked
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: CHECKBOX_ICON_SIZE,
                  )
                : Container(),
          ),
          if (widget.label != null)
            TextView(
              text: widget.label,
              textSize: LABEL_TEXT_SIZE,
              textColor: RED_COLOR,
              textAlign: TextAlign.start,
            ),
        ],
      ),
    );
  }
}
