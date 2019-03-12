import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Name',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          GenericList(
            List<int>.generate(40, (i) => i),
            (c, i) => FlatButton(
                onPressed: () => doTransition(
                    context,
                    (c) => CardViewer(
                        AssetImage('assets/cards/units/10101f.jpg'))),
                child: Text(
                  'Button $i',
                )),
          ),
        ],
      ),
    );
  }
}

typedef Widget GenericBuilder<T>(BuildContext context, T item);

class GenericList<T> extends StatelessWidget {
  final List<T> list;
  final GenericBuilder<T> builder;
  final double height;

  GenericList(this.list, this.builder, {this.height = 49});

  Widget build(BuildContext context) {
    var offset = 2.0;
    List<Widget> children = [];

    for (var i = 0; i < list.length; ++i) {
      children.add(Positioned(
          top: i * (height + offset) + offset + 1,
          left: 0.0,
          right: 0.0,
          child: Container(
            padding: EdgeInsets.only(bottom: offset),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/graphics/BGContent.jpg'),
                  fit: BoxFit.cover),
            ),
            child: builder(context, list[i]),
          )));
    }

    for (var i = 0; i <= list.length; ++i) {
      children.add(Positioned(
        top: i * (height + offset),
        left: 0.0,
        right: 0.0,
        child: Image(
            image: AssetImage('assets/graphics/Bar.png'),
            repeat: ImageRepeat.repeatX,
            height: 5.0),
      ));
    }

    return SizedBox(
      height: list.length * (height + offset) + offset * 2.0,
      child: Stack(children: children),
    );
  }
}

class PageRoute<T> extends MaterialPageRoute<T> {
  PageRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return SlideTransition(
      position:
          Tween(begin: Offset(1.0, 0.0), end: Offset.zero).animate(animation),
      child: child,
    );
  }
}

doTransition<T extends Widget>(
    BuildContext context, T builder(BuildContext ctx)) {
  Navigator.push(context, PageRoute(builder: builder));
}

class CardViewer extends StatelessWidget {
  final AssetImage front;
  CardViewer(this.front);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        color: const Color(0xff000000),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Image(image: front),
            ),
          ),
        ),
      ),
    );
  }
}