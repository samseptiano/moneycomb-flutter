import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_comb/util/stringUtil.dart';

class CustomLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const CustomLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Convert data to FlSpot
    final spots = data.map((entry) {
      print("monthhh "+entry.toString());
      return FlSpot(
        entry['month']?.toDouble() ?? 0.0,
        (entry['total'] is num) ? (entry['total'] as num).toDouble() : 0.0,
      );
    }).toList();


final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
final yInterval = (maxY / 4).ceilToDouble(); // dynamic interval

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              color: Colors.blue,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: yInterval,
                getTitlesWidget: (value, meta) {
                  return Text(
                    StringUtil.formatYAxisLabel(value, maxY),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  const months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Des"
                  ];
                  if (value < 1 || value > 12) return const SizedBox();
                  return Text(
                    months[value.toInt() - 1],
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
