import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomPieChart extends StatefulWidget {
  final Map<String, double> data;

  const CustomPieChart({super.key, required this.data});

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  int? _touchedIndex;

  final List<Color> baseColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.lime,
    Colors.yellow,
    Colors.blueGrey,
    Colors.grey,
    Colors.black,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.redAccent,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.cyanAccent,
    Colors.indigoAccent,
    Colors.amberAccent,
    Colors.brown.shade300,
    Colors.blue.shade900,
    Colors.pink.shade300,
    Colors.grey.shade600,
  ];

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final total = data.values.fold(0.0, (double a, double b) => a + b);
    final keys = data.keys.toList();
    final values = data.values.toList();

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex =
                        response?.touchedSection?.touchedSectionIndex;
                  });
                },
              ),
              sections: List.generate(data.length, (i) {
                final percent = (values[i] / total) * 100;
                final isTouched = i == _touchedIndex;
                final color = baseColors[i % baseColors.length];

                return PieChartSectionData(
                  value: values[i],
                  title: "${percent.toStringAsFixed(1)}%",
                  radius: isTouched ? 90 : 80,
                  titleStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  color: color,
                );
              }),
              sectionsSpace: 0.5,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_touchedIndex != null &&
            _touchedIndex! >= 0 &&
            _touchedIndex! < keys.length)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${keys[_touchedIndex!]}: ${NumberFormat('#,##0').format(values[_touchedIndex!])}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        else
          const Text(
            "Tap a section to see details",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }
}
