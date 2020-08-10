import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isCircle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Checkbox(
                    value: isCircle,
                    onChanged: (change) {
                      setState(() {
                        isCircle = change;
                      });
                    },
                  ),
                  Text("isCircle")
                ],
              ),
              RaisedButton(
                  child: Text("Show"),
                  onPressed: () {
                    show(context);
                  })
            ],
          ),
        ),
      ),
    );
  }

  void show(BuildContext context) {
    AchievementView(
      context,
      title: "Yeaaah!",
      subTitle: "Training completed successfully! ",
      isCircle: isCircle,
      listener: (status) {
        print(status);
      },
    )..show();
  }
}
