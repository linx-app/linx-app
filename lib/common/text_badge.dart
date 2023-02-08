import 'package:flutter/material.dart';
import 'package:linx/constants/text.dart';

class LinxTextBadge extends StatelessWidget {
    final String badge_text;
    final Color font_color;
    final Color background_color;
    final FontWeight? font_weight;
    final double? font_size;
    final double? border_radius;

    const LinxTextBadge({
        super.key,
        required this.font_color,
        required this.background_color,
        this.font_weight,
        this.font_size,
        this.border_radius,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(border_radius))
            ),
            color: background_color,
            padding: EdgeInsets.all(24)
            child: Text(
              badge_text, 
              style: TextStyle(
                color: font_color,
                fontWeight: font_weight ?? FontWeight.w400,
                fontSize: font_size ?? 12.0, //?? means specifying the null value
              ),
            ),
        ); 
  }

}