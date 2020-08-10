[![pub package](https://img.shields.io/pub/v/achievement_view.svg)](https://pub.dartlang.org/packages/achievement_view)
[![buymeacoffee](https://i.imgur.com/aV6DDA7.png)](https://www.buymeacoffee.com/rafaelbarbosa)

# AchievementView

Beautiful toast to show Achievements in your application

![Usage of the achievement_view on an android device](https://github.com/RafaelBarbosatec/achievement_view_flutter/blob/master/img/example.gif)

## Usage
To use this plugin, add `achieviment_view` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';

void showAchievementView(BuildContext context){
    AchievementView(
        context,
        title: "Yeaaah!",
        subTitle: "Training completed successfully",
        //onTab: _onTabAchievement,
        //icon: Icon(Icons.insert_emoticon, color: Colors.white,),
        //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
        //borderRadius: 5.0,
        //color: Colors.blueGrey,
        //textStyleTitle: TextStyle(),
        //textStyleSubTitle: TextStyle(),
        //alignment: Alignment.topCenter,
        //duration: Duration(seconds: 3),
        //isCircle: false,
        listener: (status){
          print(status);
          //AchievementState.opening
          //AchievementState.open
          //AchievementState.closing
          //AchievementState.closed
        }
    )..show();
  }
```
