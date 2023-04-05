import 'package:achievement_view/achievement_widget.dart';
import 'package:flutter/material.dart';

class AchievementView {
  final BuildContext _context;
  final AlignmentGeometry alignment;
  final Duration duration;
  final GestureTapCallback? onTap;
  final Function(AchievementState)? listener;
  final bool isCircle;
  final Widget icon;
  final AnimationTypeAchievement typeAnimationContent;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? iconBorderRadius;
  final Color color;
  final Color? iconBackgroundColor;
  final TextStyle? textStyleTitle;
  final TextStyle? textStyleSubTitle;
  final String title;
  final String subTitle;
  final double elevation;
  final OverlayState? overlay;
  final Widget? customContent;
  OverlayEntry? _overlayEntry;

  AchievementView(this._context,
      {this.elevation = 2,
      this.onTap,
      this.listener,
      this.overlay,
      this.isCircle = false,
      this.icon = const Icon(
        Icons.insert_emoticon,
        color: Colors.white,
      ),
      this.typeAnimationContent = AnimationTypeAchievement.fadeSlideToUp,
      this.borderRadius,
      this.iconBorderRadius,
      this.color = Colors.blueGrey,
      this.iconBackgroundColor,
      this.textStyleTitle,
      this.textStyleSubTitle,
      this.alignment = Alignment.topCenter,
      this.duration = const Duration(seconds: 3),
      this.title = "My Title",
      this.subTitle = "My subtitle with max 1 line",
      this.customContent});

  OverlayEntry _buildOverlay() {
    return OverlayEntry(builder: (context) {
      return Align(
        alignment: alignment,
        child: AchievementWidget(
          title: title,
          subTitle: subTitle,
          customContent: customContent,
          duration: duration,
          listener: listener,
          onTap: onTap,
          isCircle: isCircle,
          elevation: elevation,
          textStyleSubTitle: textStyleSubTitle,
          textStyleTitle: textStyleTitle,
          icon: icon,
          typeAnimationContent: typeAnimationContent,
          borderRadius: borderRadius,
          iconBorderRadius: iconBorderRadius,
          color: color,
          iconBackgroundColor: iconBackgroundColor,
          finish: _hide,
        ),
      );
    });
  }

  void show() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlay();
      (overlay ?? Overlay.of(_context))?.insert(_overlayEntry!);
    }
  }

  void _hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
