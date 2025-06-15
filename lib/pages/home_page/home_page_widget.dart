import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fl_chart/fl_chart.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/adicionar_registro_widget.dart';
import '/components/editar_registro_widget.dart';
import '/components/meu_perfil_widget.dart';
import '/core/theme/app_theme.dart';
import '/core/widgets/animated_counter.dart';
import '/core/widgets/shimmer_loading.dart';
import '/core/widgets/custom_error_widget.dart';
import '/core/widgets/chart_widgets.dart';
import '/core/providers/dashboard_provider.dart';
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
    final dashboardData = ref.watch(dashboardProvider);

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
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá! 👋',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seu saldo atual',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      AnimatedCounter(
                        value: data.totalBalance,
                        prefix: 'R\$ ',
                        textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => const Dialog(
                  child: MeuPerfilWidget(),
                ),
              ),
              icon: const Icon(Icons.account_circle, color: Colors.white),
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildMonthlyOverview(data),
              const SizedBox(height: 16),
              _buildExpenseChart(data),
              const SizedBox(height: 16),
              _buildRecentTransactions(data),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(DashboardData data) {
    return AnimationLimiter(
      child: Row(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            Expanded(
              child: _buildOverviewCard(
                title: 'Receitas',
                value: data.monthlyIncome,
                icon: Icons.trending_up,
                color: AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                title: 'Gastos',
                value: data.monthlyExpenses,
                icon: Icons.trending_down,
                color: AppTheme.errorColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard({
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedCounter(
              value: value,
              prefix: 'R\$ ',
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(DashboardData data) {
    if (data.categoryExpenses.isEmpty) {
      return const SizedBox.shrink();
    }

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
            ExpensePieChart(
              data: data.categoryExpenses,
              colors: const [
                AppTheme.primaryColor,
                AppTheme.secondaryColor,
                AppTheme.errorColor,
                AppTheme.warningColor,
                Colors.purple,
                Colors.orange,
                Colors.teal,
              ],
            ),
            const SizedBox(height: 16),
            _buildChartLegend(data.categoryExpenses),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(Map<String, double> data) {
    const colors = [
      AppTheme.primaryColor,
      AppTheme.secondaryColor,
      AppTheme.errorColor,
      AppTheme.warningColor,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final mapEntry = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              mapEntry.key,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );
      }).toList(),
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
    final icon = isIncome ? Icons.add : Icons.remove;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(transaction.descricao ?? ''),
      subtitle: Text(transaction.categoria ?? ''),
      trailing: Text(
        '${isIncome ? '+' : '-'}R\$ ${transaction.valor?.toStringAsFixed(2) ?? '0.00'}',
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
      ),
    );
  }

  Widget _buildDashboardLoading() {
    return const CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          backgroundColor: Colors.transparent,
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ShimmerList(itemCount: 3),
            ]),
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
    final icon = isIncome ? Icons.trending_up : Icons.trending_down;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
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
              dateTimeFormat('dd/MM/yyyy', transaction.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'}R\$ ${transaction.valor?.toStringAsFixed(2) ?? '0.00'}',
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
        ),
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
}