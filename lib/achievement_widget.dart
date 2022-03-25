import 'package:flutter/material.dart';

enum AchievementState {
  opening,
  open,
  closing,
  closed,
}

enum AnimationTypeAchievement {
  fadeSlideToUp,
  fadeSlideToLeft,
  fade,
}

class AchievementWidget extends StatefulWidget {
  final VoidCallback? finish;
  final GestureTapCallback? onTap;
  final ValueChanged<AchievementState>? listener;
  final Duration duration;
  final bool isCircle;
  final Widget icon;
  final AnimationTypeAchievement typeAnimationContent;
  final BorderRadiusGeometry? borderRadius;
  final double elevation;
  final Color color;
  final Color? iconBackgroundColor;
  final BorderRadiusGeometry? iconBorderRadius;
  final TextStyle? textStyleTitle;
  final TextStyle? textStyleSubTitle;
  final String title;
  final String subTitle;

  const AchievementWidget({
    Key? key,
    this.finish,
    this.duration = const Duration(seconds: 3),
    this.listener,
    this.isCircle = false,
    this.elevation = 2,
    this.icon = const Icon(
      Icons.insert_emoticon,
      color: Colors.white,
    ),
    this.onTap,
    this.typeAnimationContent = AnimationTypeAchievement.fadeSlideToUp,
    this.borderRadius,
    this.color = Colors.blueGrey,
    this.iconBackgroundColor,
    this.iconBorderRadius,
    this.textStyleTitle,
    this.textStyleSubTitle,
    this.title = "",
    this.subTitle = "",
  }) : super(key: key);

  @override
  AchievementWidgetState createState() => AchievementWidgetState();
}

class AchievementWidgetState extends State<AchievementWidget>
    with TickerProviderStateMixin {
  static const heightCard = 60.0;
  static const marginCard = 20.0;

  late AnimationController _controllerScale;
  late CurvedAnimation _curvedAnimationScale;

  late AnimationController _controllerSize;
  late CurvedAnimation _curvedAnimationSize;

  late AnimationController _controllerTitle;
  late Animation<Offset> _titleSlideUp;

  late AnimationController _controllerSubTitle;
  late Animation<Offset> _subTitleSlideUp;

  @override
  void initState() {
    _controllerScale = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _curvedAnimationScale =
        CurvedAnimation(parent: _controllerScale, curve: Curves.easeInOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controllerSize.forward();
            }
            if (status == AnimationStatus.dismissed) {
              _notifyListener(AchievementState.closed);
              widget.finish?.call();
            }
          });

    _controllerSize = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllerTitle.forward();
        }
        if (status == AnimationStatus.dismissed) {
          _controllerScale.reverse();
        }
      });
    _curvedAnimationSize =
        CurvedAnimation(parent: _controllerSize, curve: Curves.ease);

    _controllerTitle = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllerSubTitle.forward();
        }
        if (status == AnimationStatus.dismissed) {
          _controllerSize.reverse();
        }
      });

    _titleSlideUp = _buildAnimatedContent(_controllerTitle);

    _controllerSubTitle = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _notifyListener(AchievementState.open);
          _startTime();
        }
        if (status == AnimationStatus.dismissed) {
          _controllerTitle.reverse();
        }
      });

    _subTitleSlideUp = _buildAnimatedContent(_controllerSubTitle);
    super.initState();
    show();
  }

  void show() {
    _notifyListener(AchievementState.opening);
    _controllerScale.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(minHeight: heightCard),
        margin: const EdgeInsets.all(marginCard),
        child: ScaleTransition(
          scale: _curvedAnimationScale,
          child: _buildAchievement(),
        ),
      ),
    );
  }

  Widget _buildAchievement() {
    return Material(
      elevation: widget.elevation,
      borderRadius: _buildBorderCard(),
      color: widget.color,
      child: InkWell(
        onTap: () => widget.onTap?.call(),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIcon(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: widget.iconBorderRadius,
        color: widget.iconBackgroundColor,
      ),
      width: heightCard,
      alignment: Alignment.center,
      child: widget.icon,
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: AnimatedBuilder(
        animation: _curvedAnimationSize,
        builder: (context, child) {
          return Align(
            widthFactor: _curvedAnimationSize.value,
            heightFactor: 1,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: _buildPaddingContent(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTitle(),
                  const SizedBox(height: 2),
                  _buildSubTitle(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _controllerTitle,
      builder: (_, child) {
        return SlideTransition(
          position: _titleSlideUp,
          child: FadeTransition(
            opacity: _controllerTitle,
            child: child,
          ),
        );
      },
      child: Text(
        widget.title,
        softWrap: true,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            .merge(widget.textStyleTitle),
      ),
    );
  }

  Widget _buildSubTitle() {
    return AnimatedBuilder(
        animation: _controllerSubTitle,
        builder: (_, child) {
          return SlideTransition(
            position: _subTitleSlideUp,
            child: FadeTransition(
              opacity: _controllerSubTitle,
              child: child,
            ),
          );
        },
        child: Text(
          widget.subTitle,
          style: const TextStyle(color: Colors.white)
              .merge(widget.textStyleSubTitle),
        ));
  }

  BorderRadiusGeometry _buildBorderCard() {
    if (widget.isCircle) {
      return const BorderRadius.all(Radius.circular(heightCard / 2));
    }
    return widget.borderRadius ?? const BorderRadius.all(Radius.circular(5));
  }

  EdgeInsets _buildPaddingContent() => EdgeInsets.fromLTRB(
      widget.iconBackgroundColor != null ? 15 : 0,
      15,
      widget.isCircle ? 25 : 15,
      15);

  Animation<Offset> _buildAnimatedContent(AnimationController controller) {
    double dx = 0.0;
    double dy = 0.0;
    switch (widget.typeAnimationContent) {
      case AnimationTypeAchievement.fadeSlideToUp:
        {
          dy = 2.0;
        }
        break;
      case AnimationTypeAchievement.fadeSlideToLeft:
        {
          dx = 2.0;
        }
        break;
      case AnimationTypeAchievement.fade:
        {}
        break;
    }
    return Tween(begin: Offset(dx, dy), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.decelerate));
  }

  void _notifyListener(AchievementState state) {
    widget.listener?.call(state);
  }

  void _startTime() {
    Future.delayed(widget.duration, () {
      _notifyListener(AchievementState.closing);
      _controllerSubTitle.reverse();
    });
  }

  @override
  void dispose() {
    _controllerScale.dispose();
    _controllerSize.dispose();
    _controllerTitle.dispose();
    _controllerSubTitle.dispose();
    super.dispose();
  }
}
