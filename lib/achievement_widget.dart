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

  final Function() finish;
  final GestureTapCallback onTab;
  final Function(AchievementState) listener;
  final Duration duration;
  final bool isCircle;
  final Widget icon;
  final AnimationTypeAchievement typeAnimationContent;
  final double borderRadius;
  final Color color;
  final TextStyle textStyleTitle;
  final TextStyle textStyleSubTitle;
  final String title;
  final String subTitle;

  const AchievementWidget({
    Key key,
    this.finish,
    this.duration = const Duration(seconds: 3),
    this.listener,
    this.isCircle = false,
    this.icon = const Icon(Icons.insert_emoticon, color: Colors.white,),
    this.onTab,
    this.typeAnimationContent = AnimationTypeAchievement.fadeSlideToUp,
    this.borderRadius = 5.0,
    this.color = Colors.blueGrey,
    this.textStyleTitle,
    this.textStyleSubTitle,
    this.title = "",
    this.subTitle = ""
  }) : super(key: key);

  @override
  AchievementWidgetState createState() => AchievementWidgetState();
}

class AchievementWidgetState extends State<AchievementWidget> with TickerProviderStateMixin{

  AnimationController _controllerScale;
  CurvedAnimation _curvedAnimationScale;

  AnimationController _controllerSize;
  CurvedAnimation _curvedAnimationSize;

  AnimationController _controllerTitle;
  Animation<Offset> _titleSlideUp;

  AnimationController _controllerSubTitle;
  Animation<Offset> _subTitleSlideUp;

  @override
  void initState() {
    _controllerScale = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
    _curvedAnimationScale = CurvedAnimation(parent: _controllerScale, curve: Curves.easeInOut)
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _controllerSize.forward();
      }
      if(status == AnimationStatus.dismissed){
        _notifyListener(AchievementState.closed);
        widget.finish();
      }
    });

    _controllerSize = AnimationController(vsync: this,duration: Duration(milliseconds: 500))
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _controllerTitle.forward();
      }
      if(status == AnimationStatus.dismissed){
        _controllerScale.reverse();
      }
    });
    _curvedAnimationSize = CurvedAnimation(parent: _controllerSize, curve: Curves.ease);

    _controllerTitle = AnimationController(vsync: this,duration: Duration(milliseconds: 250))
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _controllerSubTitle.forward();
      }
      if(status == AnimationStatus.dismissed){
        _controllerSize.reverse();
      }
    });

    _titleSlideUp = _buildAnimatedContent(_controllerTitle);

    _controllerSubTitle = AnimationController(vsync: this,duration: Duration(milliseconds: 250))
    ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _notifyListener(AchievementState.open);
       _startTime();
      }
      if(status == AnimationStatus.dismissed){
        _controllerTitle.reverse();
      }
    });

    _subTitleSlideUp = _buildAnimatedContent(_controllerSubTitle);
    super.initState();
    show();
  }

  void show(){
    _notifyListener(AchievementState.opening);
    _controllerScale.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 50.0,
        margin: EdgeInsets.all(20.0),
        child: ScaleTransition(
          scale: _curvedAnimationScale,
          child: _buildAchievement(),
        ),
      ),
    );
  }

  Widget _buildAchievement() {
    return Material(
      elevation: 2.0,
      borderRadius: _buildBorderCard(),
      color: widget.color,
      child: InkWell(
        onTap: (){
          if(widget.onTab != null){
            widget?.onTab();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildIcon(),
            _buildContent()
          ],
        ),
      ),
    );
  }

  _buildIcon() {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: _buildBorderIcon()
      ),
      child: widget.icon,
    );
  }

  _buildContent() {
    return Flexible(
      child: SizeTransition(
        sizeFactor: _curvedAnimationSize,
        axis: Axis.horizontal,
        child: Padding(
          padding: _buildPaddingContent(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitle(),
              _buildSubTitle(),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return AnimatedBuilder(
      animation: _controllerTitle,
      builder: (_,child){
        return SlideTransition(
          position: _titleSlideUp,
          child: FadeTransition(
              opacity: _controllerTitle,
            child: child,
          ),
        );
      },
      child:  Text(
        widget.title,
        softWrap: true,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
        ).merge(
          widget.textStyleTitle
        ),
      ),
    );
  }

  _buildSubTitle() {
    return AnimatedBuilder(
        animation: _controllerSubTitle,
        builder: (_,child){
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
        maxLines: 1,
        style: TextStyle(
          color: Colors.white
        ).merge(
          widget.textStyleSubTitle
        ),
      )
    );
  }

  void _startTime() {
    Future.delayed(widget.duration,(){
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

  BorderRadiusGeometry _buildBorderIcon() {
    if(widget.isCircle){
      return BorderRadius.all(Radius.circular(25.0));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(widget.borderRadius),
      bottomLeft: Radius.circular(widget.borderRadius),
    );
  }

  BorderRadiusGeometry _buildBorderCard() {
    if(widget.isCircle){
      return BorderRadius.all(Radius.circular(25.0));
    }
    return BorderRadius.all(Radius.circular(widget.borderRadius));
  }

  EdgeInsets _buildPaddingContent() {
    if(widget.isCircle){
      return EdgeInsets.only(left:15.0,right: 25.0);
    }
    return EdgeInsets.only(left:15.0,right: 15.0);
  }

  Animation<Offset> _buildAnimatedContent(AnimationController controller) {
    double dx = 0.0;
    double dy = 0.0;
    switch(widget.typeAnimationContent){
      case AnimationTypeAchievement.fadeSlideToUp:{
        dy = 2.0;
      }break;
      case AnimationTypeAchievement.fadeSlideToLeft:{
        dx = 2.0;
      }break;
      case AnimationTypeAchievement.fade:{
      }break;

    }
    return new Tween(
        begin: Offset(dx,dy)
        , end: Offset(0.0,0.0)
    ).animate(
        CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate
        )
    );
  }

  void _notifyListener(AchievementState state) {
    if(widget.listener != null){
      widget.listener(state);
    }
  }
}

