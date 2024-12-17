import 'package:Notes/constants.dart';
import 'package:Notes/helper/responsive.dart';
import 'package:flutter/material.dart';

class BuildHighlightedText {
  BuildHighlightedText(this.pattern);
  final String? pattern;
  Widget highlightedText(
    String text,
    String type,
  ) {
    TextStyle buildTextStyle({Color? color}) {
      return TextStyle(
          fontSize: type == 'title'
              ? ResponsiveSpacing.fontSize(26)
              : ResponsiveSpacing.fontSize(14),
          fontWeight: FontWeight.w600,
          color: color);
    }

    Text buildTextWidget() {
      return Text(
        text,
        maxLines: type == 'title' ? 1 : 9,
        overflow: TextOverflow.ellipsis,
        style: buildTextStyle(),
      );
    }

    if (pattern!.isEmpty) {
      return buildTextWidget();
    }
    final regExp = RegExp(RegExp.escape(pattern!), caseSensitive: false);
    final matches = regExp.allMatches(text);
    if (matches.isEmpty) {
      return buildTextWidget();
    }

    List<TextSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start != lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: buildTextStyle(),
        ));
      }
      spans.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: buildTextStyle(color: kPrimaryColor),
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd != text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: buildTextStyle(),
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}