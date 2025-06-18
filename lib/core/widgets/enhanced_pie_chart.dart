import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finresp/core/utils/currency_formatter.dart';

class EnhancedPieChart extends StatefulWidget {
  final Map<String, double> data;
  final List<Color> colors;

  const EnhancedPieChart({
    super.key,
    required this.data,
    required this.colors,
  });

  @override
  State<EnhancedPieChart> createState() => _EnhancedPieChartState();
}

class _EnhancedPieChartState extends State<EnhancedPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
        child: Text('Nenhum dado disponível'),
      );
    }

    final total = widget.data.values.fold(0.0, (sum, value) => sum + value);
    
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
              sections: _buildSections(total),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _buildSections(double total) {
    final entries = widget.data.entries.toList();
    
    return entries.asMap().entries.map((entry) {
      final index = entry.key;
      final mapEntry = entry.value;
      final percentage = (mapEntry.value / total) * 100;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 70.0 : 60.0;
      final fontSize = isTouched ? 16.0 : 12.0;
      
      return PieChartSectionData(
        color: widget.colors[index % widget.colors.length],
        value: mapEntry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final entries = widget.data.entries.toList();
    final total = widget.data.values.fold(0.0, (sum, value) => sum + value);

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: entries.asMap().entries.map((entry) {
        final index = entry.key;
        final mapEntry = entry.value;
        final percentage = (mapEntry.value / total) * 100;
        final color = widget.colors[index % widget.colors.length];

        return GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: index == touchedIndex 
                  ? color.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: index == touchedIndex 
                    ? color
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mapEntry.key,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${CurrencyFormatter.formatCompact(mapEntry.value)} (${percentage.toStringAsFixed(1)}%)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}