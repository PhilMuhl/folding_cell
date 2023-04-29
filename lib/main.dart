import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

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
              listenable: _animation,
              controller: _controller,
              cellSize: const Size(200, 200),
              innerTopWidget: Container(
                color: Colors.purpleAccent,
                child: const IconButton(
                  icon: Icon(Icons.accessible_forward,
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
                        child: const Text('Press Me'),
                        onPressed: () {
                        }),
                    IconButton(
                      icon: const Icon(Icons.fastfood),
                      onPressed: () {                        },
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
                    child: const Text('Unfold'),
                    onPressed: () {
                      _controller.reset();
                      _controller.forward();
                    }),
                const SizedBox(width: 20),
                ElevatedButton(
                    child: const Text('Collapse'),
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

  void onPressed() {}
}

class FoldingCell extends AnimatedWidget {
  final Widget frontWidget;
  final Widget innerTopWidget;
  final Widget innerBottomWidget;
  final Size cellSize;
  final AnimationController controller;

  const FoldingCell(
      {super.key,
      required this.controller,
      required this.frontWidget,
      required this.innerTopWidget,
      required this.innerBottomWidget,
      this.cellSize = const Size(100, 100), required super.listenable});

  Animation get _animation => listenable as Animation;

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
                  SizedBox(
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
                      child: SizedBox(
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
                      child: SizedBox(
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
    if (_animation.isCompleted) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
}
