import 'package:flutter/material.dart';
import 'package:finresp/components/adicionar_registro_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onTransactionAdded;

  const QuickActionsWidget({
    super.key,
    this.onTransactionAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    title: 'Adicionar Receita',
                    icon: Icons.add_circle,
                    color: Colors.green,
                    onTap: () => _showAddTransactionDialog(context, 'Entrada'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    title: 'Adicionar Gasto',
                    icon: Icons.remove_circle,
                    color: Colors.red,
                    onTap: () => _showAddTransactionDialog(context, 'Saída'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    title: 'Ver Relatórios',
                    icon: Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => _showReportsDialog(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context: context,
                    title: 'Metas',
                    icon: Icons.flag,
                    color: Colors.orange,
                    onTap: () => _showGoalsDialog(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AdicionarRegistroWidget(),
      ),
    ).then((_) {
      onTransactionAdded?.call();
    });
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Relatórios'),
        content: const Text('Funcionalidade de relatórios em desenvolvimento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showGoalsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Metas Financeiras'),
        content: const Text('Funcionalidade de metas em desenvolvimento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}