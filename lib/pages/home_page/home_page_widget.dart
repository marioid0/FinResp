import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/adicionar_registro_widget.dart';
import '/components/editar_registro_widget.dart';
import '/components/meu_perfil_widget.dart';
import '/core/theme/app_theme.dart';
import '/core/widgets/balance_card.dart';
import '/core/widgets/enhanced_pie_chart.dart';
import '/core/widgets/quick_actions_widget.dart';
import '/core/widgets/transaction_summary_card.dart';
import '/core/widgets/shimmer_loading.dart';
import '/core/widgets/custom_error_widget.dart';
import '/core/widgets/transaction_category_icon.dart';
import '/core/providers/dashboard_provider.dart';
import '/core/utils/currency_formatter.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'HomePage';
  static const String routePath = '/homePage';

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;
  late TabController _tabController;
  int _currentIndex = 0;

  final GlobalKey<LiquidPullToRefreshState> _refreshKey =
      GlobalKey<LiquidPullToRefreshState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _tabController = TabController(length: 3, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).loadDashboardData();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await ref.read(dashboardProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LiquidPullToRefresh(
        key: _refreshKey,
        onRefresh: _handleRefresh,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        _buildDashboard(),
        _buildTransactions(),
        _buildProfile(),
      ],
    );
  }

  Widget _buildDashboard() {
    final dashboardData = ref.watch(dashboardProvider);

    return dashboardData.when(
      data: (data) => _buildDashboardContent(data),
      loading: () => _buildDashboardLoading(),
      error: (error, stack) => CustomErrorWidget(
        message: 'Erro ao carregar dados do dashboard',
        onRetry: () => ref.read(dashboardProvider.notifier).refresh(),
      ),
    );
  }

  Widget _buildDashboardContent(DashboardData data) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Balance Card
              BalanceCard(
                totalBalance: data.totalBalance,
                monthlyIncome: data.monthlyIncome,
                monthlyExpenses: data.monthlyExpenses,
              ),
              
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QuickActionsWidget(
                  onTransactionAdded: () => ref.read(dashboardProvider.notifier).refresh(),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TransactionSummaryCard(
                        title: 'Receitas do Mês',
                        amount: data.monthlyIncome,
                        transactionCount: _getIncomeTransactionCount(data),
                        icon: Icons.trending_up,
                        color: AppTheme.successColor,
                        topCategories: _getTopIncomeCategories(data),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TransactionSummaryCard(
                        title: 'Gastos do Mês',
                        amount: data.monthlyExpenses,
                        transactionCount: _getExpenseTransactionCount(data),
                        icon: Icons.trending_down,
                        color: AppTheme.errorColor,
                        topCategories: _getTopExpenseCategories(data),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Expense Chart
              if (data.categoryExpenses.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildExpenseChart(data),
                ),
              
              const SizedBox(height: 16),
              
              // Recent Transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildRecentTransactions(data),
              ),
              
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseChart(DashboardData data) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gastos por Categoria',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            EnhancedPieChart(
              data: data.categoryExpenses,
              colors: const [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
                AppTheme.errorColor,
                AppTheme.warningColor,
                Colors.purple,
                Colors.orange,
                Colors.teal,
                Colors.indigo,
                Colors.pink,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(DashboardData data) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transações Recentes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () => setState(() => _currentIndex = 1),
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data.recentTransactions.isEmpty)
              const EmptyStateWidget(
                title: 'Nenhuma transação',
                message: 'Adicione sua primeira transação para começar',
                icon: Icons.receipt_long,
              )
            else
              ...data.recentTransactions.take(5).map((transaction) =>
                _buildTransactionTile(transaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(RegistrosRow transaction) {
    final isIncome = transaction.tipo == 'Entrada';
    final color = isIncome ? AppTheme.successColor : AppTheme.errorColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: TransactionCategoryIcon(
            category: transaction.categoria ?? '',
            color: color,
          ),
        ),
        title: Text(transaction.descricao ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.categoria ?? ''),
            Text(
              dateTimeFormat('dd/MM/yyyy HH:mm', transaction.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.valor)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: EditarRegistroWidget(registroRow: transaction),
          ),
        ).then((_) => ref.read(dashboardProvider.notifier).refresh()),
      ),
    );
  }

  Widget _buildDashboardLoading() {
    return const CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 16),
              ShimmerList(itemCount: 3),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactions() {
    return FutureBuilder<List<RegistrosRow>>(
      future: RegistrosTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            .order('created_at', ascending: false),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerList();
        }

        if (snapshot.hasError) {
          return CustomErrorWidget(
            message: 'Erro ao carregar transações',
            onRetry: () => setState(() {}),
          );
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const EmptyStateWidget(
            title: 'Nenhuma transação',
            message: 'Adicione sua primeira transação para começar',
            icon: Icons.receipt_long,
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Transações'),
              floating: true,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO: Implement filter/search
                  },
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildTransactionCard(transactions[index]),
                        ),
                      ),
                    );
                  },
                  childCount: transactions.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(RegistrosRow transaction) {
    final isIncome = transaction.tipo == 'Entrada';
    final color = isIncome ? AppTheme.successColor : AppTheme.errorColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: TransactionCategoryIcon(
            category: transaction.categoria ?? '',
            color: color,
          ),
        ),
        title: Text(
          transaction.descricao ?? '',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.categoria ?? ''),
            Text(
              dateTimeFormat('dd/MM/yyyy HH:mm', transaction.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.valor)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: EditarRegistroWidget(registroRow: transaction),
          ),
        ).then((_) => ref.read(dashboardProvider.notifier).refresh()),
      ),
    );
  }

  Widget _buildProfile() {
    return const Center(
      child: MeuPerfilWidget(),
    );
  }

  Widget _buildBottomNavigation() {
    return CurvedNavigationBar(
      index: _currentIndex,
      height: 60,
      items: const [
        Icon(Icons.dashboard, size: 30, color: Colors.white),
        Icon(Icons.receipt_long, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      color: Theme.of(context).colorScheme.primary,
      buttonBackgroundColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => const Dialog(
          child: AdicionarRegistroWidget(),
        ),
      ).then((_) {
        // Refresh data after adding a transaction
        ref.read(dashboardProvider.notifier).refresh();
      }),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  // Helper methods
  int _getIncomeTransactionCount(DashboardData data) {
    return data.recentTransactions
        .where((t) => t.tipo == 'Entrada')
        .length;
  }

  int _getExpenseTransactionCount(DashboardData data) {
    return data.recentTransactions
        .where((t) => t.tipo == 'Saída')
        .length;
  }

  List<String> _getTopIncomeCategories(DashboardData data) {
    final incomeByCategory = <String, double>{};
    
    for (final transaction in data.recentTransactions) {
      if (transaction.tipo == 'Entrada' && transaction.categoria != null) {
        incomeByCategory[transaction.categoria!] = 
            (incomeByCategory[transaction.categoria!] ?? 0) + (transaction.valor ?? 0);
      }
    }
    
    final sortedCategories = incomeByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCategories.take(3).map((e) => e.key).toList();
  }

  List<String> _getTopExpenseCategories(DashboardData data) {
    final expenseByCategory = <String, double>{};
    
    for (final transaction in data.recentTransactions) {
      if (transaction.tipo == 'Saída' && transaction.categoria != null) {
        expenseByCategory[transaction.categoria!] = 
            (expenseByCategory[transaction.categoria!] ?? 0) + (transaction.valor ?? 0);
      }
    }
    
    final sortedCategories = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCategories.take(3).map((e) => e.key).toList();
  }
}