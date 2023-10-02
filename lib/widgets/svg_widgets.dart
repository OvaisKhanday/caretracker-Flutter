import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget svgHeadlineWidget(
    {required BuildContext context,
    required String assetName,
    required double height}) {
  return SvgPicture.asset(
    //todo: try to add size parameter as well,
    // it would be handy to change the size of all svg in the app,
    // in just a one click.
    height: height,
    assetName,
    colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
  );
}
