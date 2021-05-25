import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceOut);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FoldingCell(
              animation: _animation,
              controller: _controller,
              cellSize: Size(200, 200),
              innerTopWidget: Container(
                color: Colors.purpleAccent,
                child: IconButton(
                  icon: const Icon(Icons.accessible_forward,
                      color: Colors.black, size: 120),
                  onPressed: null,
                ),
              ),
              innerBottomWidget: Container(
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                        child: Text('Press Me'),
                        onPressed: () {
                          print('Pressed');
                        }),
                    IconButton(
                      icon: const Icon(Icons.fastfood),
                      onPressed: () {
                        print('Icon pressed');
                      },
                    )
                  ],
                ),
              ),
              frontWidget: Container(
                color: Colors.purple,
                child: const Icon(Icons.assistant_photo,
                    color: Colors.black, size: 120),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    child: Text('Unfold'),
                    onPressed: () {
                      _controller.reset();
                      _controller.forward();
                    }),
                SizedBox(width: 20),
                ElevatedButton(
                    child: Text('Collapse'),
                    onPressed: () {
                      _controller.reverse();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPressed() {
    print('Pressed');
  }
}

class FoldingCell extends AnimatedWidget {
  final Widget frontWidget;
  final Widget innerTopWidget;
  final Widget innerBottomWidget;
  final Size cellSize;
  final AnimationController controller;

  const FoldingCell(
      {Key key,
      @required Animation animation,
      @required this.controller,
      @required this.frontWidget,
      @required this.innerTopWidget,
      @required this.innerBottomWidget,
      this.cellSize = const Size(100, 100)})
      : super(key: key, listenable: animation);

  Animation get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    final angle = _animation.value * math.pi;

    return Stack(
      children: [
        GestureDetector(
            onTap: onTapped,
            child: Container(
              color: Colors.transparent,
              height: cellSize.height + (cellSize.height * _animation.value),
              width: cellSize.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: cellSize.height,
                    width: cellSize.width,
                    child: innerTopWidget,
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(angle)),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(math.pi),
                      child: Container(
                        height: cellSize.height,
                        width: cellSize.width,
                        child: innerBottomWidget,
                      ),
                    ),
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: (Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(angle)),
                    child: Opacity(
                      opacity: angle >= 1.5708 ? 0.0 : 1.0,
                      child: Container(
                        height: angle >= 1.5708 ? 0.0 : cellSize.height,
                        width: angle >= 1.5708 ? 0.0 : cellSize.width,
                        child: frontWidget,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  void onTapped() {
    if (_animation.isCompleted)
      controller.reverse();
    else
      controller.forward();
  }
}
