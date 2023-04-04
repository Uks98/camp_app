import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarCharts extends StatefulWidget {
  BarCharts({Key? key}) : super(key: key);

  @override
  State<BarCharts> createState() => BarChartsState();
}

class BarChartsState extends State<BarCharts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '★';
        break;
      case 1:
        text = '★★';
        break;
      case 2:
        text = '★★';
        break;
      case 3:
        text = '★★';
        break;
      case 4:
        text = '★★';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 9,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.red,
      Colors.red,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 8,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    // BarChartGroupData(
    //   x: 1,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 8,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 2,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 8,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 3,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 8,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
    // BarChartGroupData(
    //   x: 4,
    //   barRods: [
    //     BarChartRodData(
    //       toY: 8,
    //       gradient: _barsGradient,
    //     )
    //   ],
    //   showingTooltipIndicators: [0],
    // ),
  ];
}

// class BarChartSample3 extends StatefulWidget {
//    double count1;
//    BarChartSample3({super.key,required this.count1});
//
//   @override
//   State<StatefulWidget> createState() => BarChartSample3State();
// }

// class BarChartSample3State extends State<BarChartSample3> {
//   double get count1 => count1;
//
//   @override
//   Widget build(BuildContext context) {
//     return  AspectRatio(
//       aspectRatio: 1.6,
//       child: BarCharts(),
//     );
//   }
// }