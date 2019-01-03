import 'dart:ui';

import 'package:meta/meta.dart';

class DiagnosisCategory {
  final String title;
  final Color color;

  const DiagnosisCategory({@required this.title, @required this.color});
}

class DiagnosisCategories {
  static const diagnosisCategories = <DiagnosisCategory>[
    DiagnosisCategory(
      title: "Red",
      color: Color(0xFFf56166),
    ),
    DiagnosisCategory(
      title: "Yellow",
      color: Color(0xFFf7cf7c),
    ),
    DiagnosisCategory(
      title: "Sea",
      color: Color(0xFF68e4c8),
    ),
    DiagnosisCategory(
      title: "Orange",
      color: Color(0xFFED825A),
    ),
    DiagnosisCategory(
      title: "Teal",
      color: Color(0xFF30b4d6),
    ),
    DiagnosisCategory(
      title: "Purple",
      color: Color(0xFF766ec9),
    ),
    DiagnosisCategory(
      title: "Red2",
      color: Color(0xFFe84558),
    ),
    DiagnosisCategory(
      title: "Blue",
      color: Color(0xFF30a5fe),
    ),
    DiagnosisCategory(
      title: "Moss",
      color: Color(0xFF6ab0b0),
    ),
  ];
}
