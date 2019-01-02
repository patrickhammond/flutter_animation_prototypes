import 'package:expanding_page_prototype/widgets/legend.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

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
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFDFF),
      body: Center(
        child: DiagnosisCategoriesGrid(),
      ),
    );
  }
}

class LegendDetailScreen extends StatefulWidget {
  final String title;
  final Color color;

  LegendDetailScreen({Key key, @required this.title, @required this.color});

  @override
  State<StatefulWidget> createState() =>
      _LegendDetailScreenState(title: title, color: color);
}

class _LegendDetailScreenState extends State<LegendDetailScreen>
    with TickerProviderStateMixin {
  final String title;
  final Color color;

  AnimationController controller;
  Animation<double> animation;

  _LegendDetailScreenState(
      {Key key, @required this.title, @required this.color});

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          Stack(
            children: [
              LegendItem(
                text: title,
                color: color,
                transitionPercent: 1.0,
                onSharedElementAnimationComplete: () {
                  controller.forward();
                },
              ),
              FadeTransition(
                opacity: animation,
                child: AppBar(
                  title: Text(title),
                  centerTitle: true,
                  backgroundColor: const Color(0x00000000),
                  elevation: 0.0,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.reverse();
                          Navigator.of(context).pop();
                        },
                        tooltip:
                            MaterialLocalizations.of(context).closeButtonLabel,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 116.0, 16.0, 16.0),
            child: Text("Hello!"),
          ),
        ],
      ),
    );
  }
}

class DiagnosisCategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Red",
              color: Color(0xFFf56166),
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 10.0),
            ),
            DiagnosisCategoriesButton(
              text: "Yellow",
              color: Color(0xFFf7cf7c),
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 20.0, 10.0),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Sea",
              color: Color(0xFF68e4c8),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
            ),
            DiagnosisCategoriesButton(
              text: "Orange",
              color: Color(0xFFED825A),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Teal",
              color: Color(0xFF30b4d6),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
            ),
            DiagnosisCategoriesButton(
              text: "Purple",
              color: Color(0xFF766ec9),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Red2",
              color: Color(0xFFe84558),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
            ),
            DiagnosisCategoriesButton(
              text: "Blue",
              color: Color(0xFF30a5fe),
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Moss",
              color: Color(0xFF6ab0b0),
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
            ),
            Text("")
          ],
        ),
      ],
    );
  }
}

class DiagnosisCategoriesButton extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsets padding;

  DiagnosisCategoriesButton(
      {Key key,
      @required this.text,
      @required this.color,
      @required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SizedBox(
        child: LegendItem(
          text: text,
          color: color,
          onTap: () {
            navigateToDetails(context);
          },
        ),
        height: 52.0,
      ),
      padding: padding,
    );
  }

  void navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      CustomMaterialPageRoute(
        builder: (_) {
          return LegendDetailScreen(
            title: text,
            color: color,
          );
        },
      ),
    );
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({Key key, WidgetBuilder builder})
      : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 750);
}
