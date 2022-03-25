# achievement_view_demo

``` dart
import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isCircle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  value: isCircle,
                  onChanged: (change) => setState(() => isCircle = change!),
                ),
                const Text("isCircle")
              ],
            ),
            ElevatedButton(
              child: const Text("Show"),
              onPressed: () => show(context),
            )
          ],
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
      listener: print,
    ).show();
  }
}
```
