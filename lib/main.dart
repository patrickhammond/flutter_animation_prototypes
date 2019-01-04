import 'package:expanding_page_prototype/features/diagnosis_categories.dart';
import 'package:expanding_page_prototype/widgets/layout.dart';
import 'package:expanding_page_prototype/widgets/legend.dart';
import 'package:flutter/material.dart';

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
  State<StatefulWidget> createState() => _LegendDetailScreenState(title: title, color: color);
}

class _LegendDetailScreenState extends State<LegendDetailScreen> with TickerProviderStateMixin {
  final String title;
  final Color color;

  AnimationController controller;
  Animation<double> animation;

  _LegendDetailScreenState({Key key, @required this.title, @required this.color});

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
                        tooltip: MaterialLocalizations.of(context).closeButtonLabel,
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

class DiagnosisCategoriesGrid extends StatefulWidget {
  _DiagnosisCategoriesGridState createState() => _DiagnosisCategoriesGridState();
}

class _DiagnosisCategoryHolder {
  final DiagnosisCategory diagnosisCategory;

  final AnimationController controller;
  final Animation<double> scaleAnimation;

  _DiagnosisCategoryHolder({this.diagnosisCategory, this.controller, this.scaleAnimation});
}

class _DiagnosisCategoriesGridState extends State<DiagnosisCategoriesGrid> with TickerProviderStateMixin {
  List<_DiagnosisCategoryHolder> diagnosisCategoryHolders;

  @override
  void initState() {
    super.initState();
    diagnosisCategoryHolders = DiagnosisCategories.diagnosisCategories.map((category) {
      AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      );
      Animation<double> scaleAnimation = controller.drive(Tween(begin: 1.0, end: 1.1));

      return _DiagnosisCategoryHolder(
        diagnosisCategory: category,
        controller: controller,
        scaleAnimation: scaleAnimation,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FixedGridLayout(
      columns: 2,
      childHeight: LegendItem.DEFAULT_HEIGHT,
      horizontalPadding: 10.0,
      verticalPadding: 10.0,
      children: diagnosisCategoryHolders.map((categoryHolder) {
        return LayoutId(
          id: categoryHolder.diagnosisCategory.title,
          child: ScaleTransition(
            scale: categoryHolder.scaleAnimation,
            child: LegendItem(
              text: categoryHolder.diagnosisCategory.title,
              color: categoryHolder.diagnosisCategory.color,
              onTap: () {
                bounce(context, categoryHolder);
              },
            ),
          ),
        );
      }).toList(growable: false),
    );
  }

  void bounce(BuildContext context, _DiagnosisCategoryHolder holder) async {
    await holder.controller.forward();
    await holder.controller.reverse();
    navigateToDetails(context, holder.diagnosisCategory);
  }

  void navigateToDetails(BuildContext context, DiagnosisCategory category) {
    Navigator.push(
      context,
      CustomMaterialPageRoute(
        builder: (_) {
          return LegendDetailScreen(
            title: category.title,
            color: category.color,
          );
        },
      ),
    );
  }
}

class CustomMaterialPageRoute extends MaterialPageRoute {
  CustomMaterialPageRoute({Key key, WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(milliseconds: 750);
}
