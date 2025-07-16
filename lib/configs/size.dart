import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide Condition;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:velocity_x/velocity_x.dart';

double get appBarHeight => 70.hh;

// Nếu true thì sử dụng FixedWidth, ngược lại thì sử dụng ResponsiveWidth
bool get isFixedWidth => false;
// Chiều rộng tối đa khi sử dụng FixedWidth
double get maxFixedWidth => 450;

class HTextSize {
  static double _getResponsiveSize(double baseSize) {
    return ResponsiveValue<double>(
      Get.context!,
      defaultValue: baseSize,
      conditionalValues: [
        Condition.equals(name: 'MOBILE_SMALL', value: baseSize * 0.85),
        Condition.equals(name: MOBILE, value: baseSize * 0.8),
        Condition.equals(name: TABLET, value: baseSize * 1.15),
        Condition.equals(name: DESKTOP, value: baseSize * 1.55),
        Condition.equals(name: '4K', value: baseSize * 1.5),
      ],
    ).value;
  }

  static double get xSmall => _getResponsiveSize(15);
  static double get small => _getResponsiveSize(16);
  static double get sNormal => _getResponsiveSize(18);
  static double get normal => _getResponsiveSize(20);
  static double get xnormal => _getResponsiveSize(23);
  static double get medium => _getResponsiveSize(25);
  static double get large => _getResponsiveSize(30);
  static double get xLarge => _getResponsiveSize(35);
  static double get xxLarge => _getResponsiveSize(45);
}

class ResponsiveExtension {
  final num value;

  ResponsiveExtension(this.value);

  double get responsive => ResponsiveValue<double>(
    Get.context!,
    defaultValue: value.toDouble(),
    conditionalValues: [
      Condition.equals(
          name: 'MOBILE_SMALL', value: value.toDouble() * 0.85),
      Condition.equals(name: MOBILE, value: value.toDouble() * 0.8),
      Condition.equals(name: TABLET, value: value.toDouble() * 1.15),
      Condition.equals(name: DESKTOP, value: value.toDouble() * 1.55),
      Condition.equals(name: '4K', value: value.toDouble() * 1.5),
    ],
  ).value;
}

extension NumExt on num {
  ResponsiveExtension get resp => ResponsiveExtension(this);

  Widget get hHeightBox => resp.responsive.heightBox;
  Widget get hWidthBox => resp.responsive.widthBox;

  double get hh => resp.responsive;
  double get hw => resp.responsive;
  double get hr => resp.responsive;
  double get sw =>
      Get.context != null ? MediaQuery.of(Get.context!).size.width : Get.width;
  double get sh => Get.context != null
      ? MediaQuery.of(Get.context!).size.height
      : Get.height;

  EdgeInsets get hPadHor => EdgeInsets.symmetric(horizontal: hw);
  EdgeInsets get hPadVer => EdgeInsets.symmetric(vertical: hh);
  EdgeInsets get hPadAll => EdgeInsets.all(hw);
  EdgeInsets get hPadSym => EdgeInsets.symmetric(horizontal: hw, vertical: hh);
  EdgeInsets get hPadLeft => EdgeInsets.only(left: hw);
  EdgeInsets get hPadRight => EdgeInsets.only(right: hw);
  EdgeInsets get hPadTop => EdgeInsets.only(top: hh);
  EdgeInsets get hPadBottom => EdgeInsets.only(bottom: hh);

  BorderRadius get hRadius => BorderRadius.circular(hr);
}

extension TextSizeExt on VxTextBuilder {
  VxTextBuilder get hXSmall => size(HTextSize.xSmall);
  VxTextBuilder get hSmall => size(HTextSize.small);
  VxTextBuilder get hSNormal => size(HTextSize.sNormal);
  VxTextBuilder get hNormal => size(HTextSize.normal);
  VxTextBuilder get hMedium => size(HTextSize.medium);
  VxTextBuilder get hXNormal => size(HTextSize.xnormal);
  VxTextBuilder get hLarge => size(HTextSize.large);
  VxTextBuilder get hXLarge => size(HTextSize.xLarge);
  VxTextBuilder get hXXLarge => size(HTextSize.xxLarge);
}

extension WidgetExt on Widget {
  Widget hPadHor(double value) => Padding(padding: value.hPadHor, child: this);
  Widget hPadVer(double value) => Padding(padding: value.hPadVer, child: this);
  Widget hPadAll(double value) => Padding(padding: value.hPadAll, child: this);
  Widget hPadSym(double value) => Padding(padding: value.hPadSym, child: this);
  Widget hPadLeft(double value) =>
      Padding(padding: value.hPadLeft, child: this);
  Widget hPadRight(double value) =>
      Padding(padding: value.hPadRight, child: this);
  Widget hPadTop(double value) => Padding(padding: value.hPadTop, child: this);
  Widget hPadBottom(double value) =>
      Padding(padding: value.hPadBottom, child: this);
}
