import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

void main() {
  timeDilation = 4.0;
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

class DiagnosisCategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Heart Disease",
              color: Color(0xFFf56166),
              sharedElementTag: "dc_heart",
              padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
            ),
            DiagnosisCategoriesButton(
              text: "Liver Disease",
              color: Color(0xFFf7cf7c),
              sharedElementTag: "dc_liver",
              padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "ALS",
              color: Color(0xFF68e4c8),
              sharedElementTag: "dc_als",
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            ),
            DiagnosisCategoriesButton(
              text: "Lung Disease",
              color: Color(0xFFED825A),
              sharedElementTag: "dc_lung",
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Alzheimer's",
              color: Color(0xFF30b4d6),
              sharedElementTag: "dc_alz",
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            ),
            DiagnosisCategoriesButton(
              text: "Renal Disease",
              color: Color(0xFF766ec9),
              sharedElementTag: "dc_renal",
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "HIV",
              color: Color(0xFFe84558),
              sharedElementTag: "dc_hiv",
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            ),
            DiagnosisCategoriesButton(
              text: "Sepsis",
              color: Color(0xFF30a5fe),
              sharedElementTag: "dc_sep",
              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            ),
          ],
        ),
        TableRow(
          children: [
            DiagnosisCategoriesButton(
              text: "Cancer",
              color: Color(0xFF6ab0b0),
              sharedElementTag: "dc_can",
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
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

  String _colorTag;
  String _frameTag;

  DiagnosisCategoriesButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.padding,
    @required String sharedElementTag,
  }) {
    _colorTag = sharedElementTag + "_colorTag";
    _frameTag = sharedElementTag + "_frameTag";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: LegendButton(
        text: text,
        color: color,
        colorTag: _colorTag,
        frameTag: _frameTag,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LegendDetailScreen(
                    title: text,
                    colorTag: _colorTag,
                    frameTag: _frameTag,
                    color: color,
                  ),
            ),
          );
        },
      ),
      padding: padding,
    );
  }
}

class LegendButton extends StatelessWidget {
  final String text;
  final Color color;
  final String frameTag;
  final String colorTag;
  final GestureTapCallback onTap;

  LegendButton({
    Key key,
    @required this.text,
    @required this.color,
    @required this.frameTag,
    @required this.colorTag,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: frameTag,
        child: SizedBox(
          height: 52.0,
          child: Material(
            color: const Color(0xFFFFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: colorTag,
                    child: ClipOval(
                      child: Container(
                        color: color,
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                  Padding(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.button,
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                  ),
                ],
              ),
            ),
            elevation: 2.0,
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadiusDirectional.horizontal(
                start: const Radius.circular(24.0),
                end: const Radius.circular(24.0),
              ),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class LegendDetailScreen extends StatelessWidget {
  final String colorTag;
  final String frameTag;
  final String title;
  final Color color;

  LegendDetailScreen({
    Key key,
    @required this.colorTag,
    @required this.frameTag,
    @required this.title,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: frameTag,
        child: Material(
          child: Container(
            height: double.infinity,
            child: Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: colorTag,
                child: ClipOval(
                  child: Container(
                    color: color,
                    width: double.infinity,
                    height: 300.0,
                  ),
                ),
              ),
            ),
          ),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.horizontal(
              start: Radius.circular(0.0),
              end: Radius.circular(0.0),
            ),
          ),
        ),
      ),
    );
  }
}
