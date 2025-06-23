import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_comb/ui/page/summary_chart_screen.dart';
import 'package:money_comb/util/dialog_helper.dart';
import 'package:money_comb/util/stringUtil.dart';

class SummaryCard extends StatelessWidget {
  final double thisMonth;
  final double ytd;
  final String ytdInfo;

  final double lastYear;
  final String lastYearInfo;

  final double lastMonth;
  final String lastMonthInfo;

  final double last2Month;
  final String last2MonthInfo;

  final double avgLast3Month;
  final String avgLast3MonthInfo;

  final bool isExpense;

  const SummaryCard({
    super.key,
    required this.thisMonth,
    required this.ytd,
    required this.lastYear,
    required this.lastMonth,
    required this.last2Month,
    required this.avgLast3Month,
    required this.isExpense,
    required this.ytdInfo,
    required this.lastYearInfo,
    required this.lastMonthInfo,
    required this.last2MonthInfo,
    required this.avgLast3MonthInfo,
  });

  String formatCurrency(num value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }

  Widget buildComparisonTilePercentage(
    BuildContext context,
    String title,
    String info,
    double value,
    double percent,
    String differenceLabel, {
    VoidCallback? onInfo,
  }) {
    final currencyText =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(value);
    final percentText = "${percent.toStringAsFixed(0)}%";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: title + info icon
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.info_outline,
                      size: 18, color: Colors.yellow),
                  onPressed: onInfo ??
                      () {
                        DialogHelper.showInfoDialog(context, title, info);
                      },
                  tooltip: "More info about $title",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Currency value
          Text(
            currencyText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),

          // Percentage and label
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                percentText,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.yellow,
                ),
              ),
              Text(
                differenceLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: (differenceLabel == "↑")
                      ? Colors.green[900]
                      : Colors.red[900],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildComparisonTile(BuildContext context, String title, String info,
      num amount, num percentage,
      {VoidCallback? onInfo}) {
    final percentText = "${percentage.toStringAsFixed(0)}%";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: Colors.yellow,
                  ),
                  onPressed: onInfo ??
                      () {
                        DialogHelper.showInfoDialog(context, title, info);
                      },
                  tooltip: "More info about $title",
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Text(
            formatCurrency(amount),
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(
            percentText,
            style: const TextStyle(fontSize: 11, color: Colors.yellow),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = isExpense ? Colors.red[400] : Colors.green[400];
    final cardType = isExpense ? "Expense" : "Income";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("This Month $cardType",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 8),
              Text(
                formatCurrency(thisMonth),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Divider(height: 32),

              buildComparisonTile(
                  context, "YTD", ytdInfo, ytd, (ytd / thisMonth) * 100),
              buildComparisonTile(context, "Last Year", lastYearInfo, lastYear,
                  (lastYear / ytd) * 100),

              const SizedBox(height: 16), // ← Added spacing

              buildComparisonTilePercentage(
                  context,
                  "Last Month",
                  lastMonthInfo,
                  lastMonth,
                  StringUtil.calculateDifferencePercentage(
                      lastMonth, thisMonth),
                  StringUtil.differenceLabel(thisMonth, lastMonth)),
              buildComparisonTilePercentage(
                  context,
                  "Last 2 Month",
                  last2MonthInfo,
                  last2Month,
                  StringUtil.calculateDifferencePercentage(
                      last2Month, thisMonth),
                  StringUtil.differenceLabel(thisMonth, last2Month)),

              const SizedBox(height: 16),
              Text("Your Avg Last 3 Month",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
              const SizedBox(height: 4),
              Text(
                formatCurrency(avgLast3Month),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SummaryChartScreen(isExpense: isExpense ),
                    ),
                  );
                },
                icon: const Icon(Icons.show_chart, color: Colors.white),
                label: const Text(
                  'Show Chart',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
