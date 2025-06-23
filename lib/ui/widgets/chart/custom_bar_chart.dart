import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Mock data and dynamic month labels
    final List<double> expenses = [750000, 1200000, 950000, 12000000, 56500000];
    final List<String> monthLabels = List.generate(3, (i) {
      final date = DateTime(now.year, now.month - 2 + i);
      return DateFormat.MMM().format(date); // Example: Apr, May, Jun
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: AspectRatio(
        aspectRatio: 2.0, // Wider chart
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (expenses.reduce((a, b) => a > b ? a : b)) * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.blueGrey,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${NumberFormat('#,##0').format(rod.toY)}',
                    const TextStyle(color: Colors.white, fontSize: 10),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    final index = value.toInt();
                    if (index < 0 || index >= monthLabels.length) return const SizedBox();
                    return Text(
                      monthLabels[index],
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                  reservedSize: 24,
                  interval: 1,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, _) {
                    return Text(
                      NumberFormat.compactCurrency(symbol: '', decimalDigits: 0).format(value),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(expenses.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: expenses[i],
                    width: 40,
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.teal,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
