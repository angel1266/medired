import 'package:flutter/material.dart';

class EnumeratedListItem extends StatelessWidget {
  final String text;
  final Color textColor;
  final int number;
  final double textsize;

  final double botton;

  const EnumeratedListItem({
    required this.text,
    required this.textColor,
    required this.number,
    required this.botton,
    required this.textsize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: botton),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textsize,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textsize,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
