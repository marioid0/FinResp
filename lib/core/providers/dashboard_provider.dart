import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finresp/backend/supabase/supabase.dart';
import 'package:finresp/auth/supabase_auth/auth_util.dart';

class DashboardData {
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpenses;
  final List<RegistrosRow> recentTransactions;
  final Map<String, double> categoryExpenses;

  const DashboardData({
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.recentTransactions,
    required this.categoryExpenses,
  });
}

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      state = const AsyncValue.loading();

      // Get current month's data
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      // Fetch all user transactions
      final allTransactions = await RegistrosTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            .order('created_at', ascending: false),
      );

      // Filter current month transactions
      final monthlyTransactions = allTransactions.where((transaction) {
        return transaction.createdAt.isAfter(startOfMonth) &&
            transaction.createdAt.isBefore(endOfMonth.add(const Duration(days: 1)));
      }).toList();

      // Calculate totals
      double totalIncome = 0;
      double totalExpenses = 0;
      final Map<String, double> categoryExpenses = {};

      for (final transaction in allTransactions) {
        if (transaction.tipo == 'Entrada') {
          totalIncome += transaction.valor ?? 0;
        } else {
          totalExpenses += transaction.valor ?? 0;
          final category = transaction.categoria ?? 'Outros';
          categoryExpenses[category] = (categoryExpenses[category] ?? 0) + (transaction.valor ?? 0);
        }
      }

      // Calculate monthly totals
      double monthlyIncome = 0;
      double monthlyExpenses = 0;

      for (final transaction in monthlyTransactions) {
        if (transaction.tipo == 'Entrada') {
          monthlyIncome += transaction.valor ?? 0;
        } else {
          monthlyExpenses += transaction.valor ?? 0;
        }
      }

      final dashboardData = DashboardData(
        totalBalance: totalIncome - totalExpenses,
        monthlyIncome: monthlyIncome,
        monthlyExpenses: monthlyExpenses,
        recentTransactions: allTransactions.take(10).toList(),
        categoryExpenses: categoryExpenses,
      );

      state = AsyncValue.data(dashboardData);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadDashboardData();
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  return DashboardNotifier();
});