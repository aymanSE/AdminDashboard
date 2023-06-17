import 'package:flutter/material.dart';

class Sized_Box {
  SizedBox sizedBoxH(BuildContext context, height) {
    return SizedBox(height: double.parse(height.toString())  );
  }

  SizedBox sizedBoxW(BuildContext context, width) {
    return SizedBox(width: width);
  }
}
