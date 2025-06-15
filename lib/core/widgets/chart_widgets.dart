import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const ExpensePieChart({
    super.key,
    required this.data,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(
        child: Text('Nenhum dado disponível'),
      );
    }

    final total = data.values.fold(0.0, (sum, value) => sum + value);
    
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: _buildSections(total),
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Handle touch events if needed
            },
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    final entries = data.entries.toList();
    
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final mapEntry = entry.value;
      final percentage = (mapEntry.value / total) * 100;
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: mapEntry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

class MonthlySpendingChart extends StatelessWidget {
  final List<FlSpot> spots;
  final Color lineColor;

  const MonthlySpendingChart({
    super.key,
    required this.spots,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  );
                  Widget text;
                  switch (value.toInt()) {
                    case 1:
                      text = const Text('Jan', style: style);
                      break;
                    case 2:
                      text = const Text('Fev', style: style);
                      break;
                    case 3:
                      text = const Text('Mar', style: style);
                      break;
                    case 4:
                      text = const Text('Abr', style: style);
                      break;
                    case 5:
                      text = const Text('Mai', style: style);
                      break;
                    case 6:
                      text = const Text('Jun', style: style);
                      break;
                    default:
                      text = const Text('', style: style);
                      break;
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    'R\$${value.toInt()}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
                reservedSize: 42,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: spots.isNotEmpty 
              ? spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.2
              : 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  lineColor,
                  lineColor.withOpacity(0.3),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    lineColor.withOpacity(0.3),
                    lineColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}