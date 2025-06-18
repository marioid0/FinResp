import 'package:flutter/material.dart';

class TransactionCategoryIcon extends StatelessWidget {
  final String category;
  final double size;
  final Color? color;

  const TransactionCategoryIcon({
    super.key,
    required this.category,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getCategoryIcon(category),
      size: size,
      color: color ?? Theme.of(context).colorScheme.primary,
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'aluguel':
        return Icons.home;
      case 'supermercado':
        return Icons.shopping_cart;
      case 'delivery':
        return Icons.delivery_dining;
      case 'farmácia':
        return Icons.local_pharmacy;
      case 'academia':
        return Icons.fitness_center;
      case 'salário':
        return Icons.work;
      case 'rendimento extra':
        return Icons.trending_up;
      case 'gasolina':
        return Icons.local_gas_station;
      case 'lazer':
        return Icons.entertainment_outlined;
      case 'estudos':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}