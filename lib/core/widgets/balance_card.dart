import 'package:flutter/material.dart';
import 'package:finresp/core/utils/currency_formatter.dart';
import 'package:finresp/core/widgets/animated_counter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final bool isLoading;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final balanceColor = totalBalance >= 0 
        ? Colors.green 
        : Colors.red;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saldo Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Balance Amount
            if (isLoading)
              Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            else
              AnimatedCounter(
                value: totalBalance,
                prefix: 'R\$ ',
                textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Income and Expenses Row
            Row(
              children: [
                Expanded(
                  child: _buildMetricItem(
                    context: context,
                    title: 'Receitas',
                    value: monthlyIncome,
                    icon: Icons.trending_up,
                    color: Colors.greenAccent,
                    isLoading: isLoading,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMetricItem(
                    context: context,
                    title: 'Gastos',
                    value: monthlyExpenses,
                    icon: Icons.trending_down,
                    color: Colors.redAccent,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Balance Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: balanceColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: balanceColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    totalBalance >= 0 ? Icons.check_circle : Icons.warning,
                    color: balanceColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    totalBalance >= 0 ? 'Saldo Positivo' : 'Saldo Negativo',
                    style: TextStyle(
                      color: balanceColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required String title,
    required double value,
    required IconData icon,
    required Color color,
    required bool isLoading,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (isLoading)
            Container(
              height: 20,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else
            Text(
              CurrencyFormatter.formatCompact(value),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}