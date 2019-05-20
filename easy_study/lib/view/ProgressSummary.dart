import 'package:easy_study/model/Subject.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'tween.dart';

class ProgressSummary extends StatefulWidget {
  final List<Subject> _subjects;
  ProgressSummary(this._subjects);
  State<StatefulWidget> createState() => ProgressSummaryState(_subjects);

}
class ProgressSummaryState extends State<ProgressSummary>{
  final List<Subject> _subjects;
  ProgressSummaryState(this._subjects);

  Widget build(BuildContext context) {
    return Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Text(
                _total(_subjects),
                style: new TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              ChartPage(_subjects),
            ],),
          new Row(
            ),
        ],
      ),
    );
  }

  static List<int> timeSpentMin(List<Subject>subjects) {
    final min = <int>[];
    for (int i = 0; i < subjects.length; i++) {
      min.add(subjects[i].timeSpent - (subjects[i].timeSpent % 60) * 60);
    }
    return min;
  }


  static List<int> timeSpentHr(List<Subject>subjects) {
    final hr = <int>[];
    for (int i = 0; i < subjects.length; i++) {
      hr.add(subjects[i].timeSpent % 60);
    }
    return hr;
  }

  static String _total(List<Subject> subjects) {
    int total = 0;
    int totalh=0;
    int totalmn=0;
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < subjects.length; i++) {
      total += subjects[i].timeSpent;
    }
    totalh=total%60;
    totalmn=total-total%60;
    debugPrint(totalh.toString());
    sb.writeAll([totalh,"h ",totalmn,"mn"]);
    return sb.toString();
  }
}

class ChartPage extends StatefulWidget {
  List<Subject> _subjects;
  ChartPage(this._subjects);
  ChartPageState createState() => ChartPageState(_subjects);
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {

  ChartPageState(this.subjects);
  static const size = const Size(200, 100.0);
  final random = Random();

  List<Subject> subjects;
  AnimationController animation;
  BarChartTween tween;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    tween = BarChartTween(
      BarChart.empty(size),
      BarChart.random(size, subjects),
    );
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 400.0,
       child: CustomPaint(
          size: size,
          painter: BarChartPainter(tween.animate(animation)),
    ),
      ),
    );
  }
}

class BarChart {
  BarChart(this.stacks);

  final List<BarStack> stacks;

  factory BarChart.empty(Size size) {
    return BarChart(<BarStack>[]);
  }

  factory BarChart.random(Size size, List<Subject> subjects) {
    const stackWidthFraction = 0.75;
    final stackRanks = [0];
    final stackCount = stackRanks.length;
    final stackDistance = size.width;
    final stackWidth = stackDistance * stackWidthFraction;
    final startX =  stackWidth;
    final list = _selectSize(subjects);
    final stacks = List.generate(
      stackCount,
      (i) {
        final barRanks = _selectRanks(subjects);
        final bars = List.generate(
          barRanks.length,
          (j) => Bar(
                barRanks[j],
                1.9*list[j]* size.width,
                subjects[j].color,
              ),

        );
        debugPrint((list[0]* size.width).toString());
        return BarStack(
          stackRanks[i],
          startX,
          10,
          bars,
        );
      },
    );
    return BarChart(stacks);
  }

  static List<int> _selectRanks(List<Subject> subjects) {
    final ranks = <int>[];
    var rank = 0;
    for (int i =0; i<subjects.length ;i++){
      ranks.add(rank);
      rank++;
    }
    return ranks;
  }
  static List<double> _selectSize(List<Subject> subjects){
    int total=0;
    final size= <double>[];
    for (int i =0; i<subjects.length ;i++){
      total+= subjects[i].timeSpent;
    }

    for (int i =0; i<subjects.length ;i++){
      size.add(subjects[i].timeSpent/total);
    }
    debugPrint(size.toString());
    return size;
  }

}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end)
      : _stacksTween = MergeTween<BarStack>(begin.stacks, end.stacks),
        super(begin: begin, end: end);

  final MergeTween<BarStack> _stacksTween;

  @override
  BarChart lerp(double t) => BarChart(_stacksTween.lerp(t));
}

class BarStack implements MergeTweenable<BarStack> {
  BarStack(this.rank, this.x, this.width, this.bars);

  final int rank;
  final double x;
  final double width;
  final List<Bar> bars;

  @override
  BarStack get empty => BarStack(rank, x, 0.0, <Bar>[]);

  @override
  bool operator <(BarStack other) => rank < other.rank;

  @override
  Tween<BarStack> tweenTo(BarStack other) => BarStackTween(this, other);
}

class BarStackTween extends Tween<BarStack> {
  BarStackTween(BarStack begin, BarStack end)
      : _barsTween = MergeTween<Bar>(begin.bars, end.bars),
        super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  final MergeTween<Bar> _barsTween;

  @override
  BarStack lerp(double t) => BarStack(
        begin.rank,
        lerpDouble(begin.x, end.x, t),
        lerpDouble(begin.width, end.width, t),
        _barsTween.lerp(t),
      );
}

class Bar extends MergeTweenable<Bar> {
  Bar(this.rank, this.height, this.color);

  final int rank;
  final double height;
  final Color color;

  @override
  Bar get empty => Bar(rank, 0.0, color);

  @override
  bool operator <(Bar other) => rank < other.rank;

  @override
  Tween<Bar> tweenTo(Bar other) => BarTween(this, other);

  static Bar lerp(Bar begin, Bar end, double t) {
    assert(begin.rank == end.rank);
    return Bar(
      begin.rank,
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end) {
    assert(begin.rank == end.rank);
  }

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  BarChartPainter(Animation<BarChart> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<BarChart> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.0;
    final linePath = Path();
    final chart = animation.value;
    for (final stack in chart.stacks) {
      var x = size.width;
      for (final bar in stack.bars) {
        barPaint.color = bar.color;
        canvas.drawRect(
          Rect.fromLTWH(
            x-bar.height,
            0,
            bar.height,
            stack.width,
          ),
          barPaint,
        );
        if (x < size.width) {
          linePath.moveTo(x, 0);
          linePath.lineTo(x, 10);
        }
        x -= bar.height;
      }
      canvas.drawPath(linePath, linePaint);
      linePath.reset();
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}