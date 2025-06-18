import React, {useEffect, useState} from 'react';
import {
  View,
  ScrollView,
  RefreshControl,
  StyleSheet,
  Dimensions,
} from 'react-native';
import {Text, FAB} from 'react-native-paper';
import {useNavigation} from '@react-navigation/native';
import {NativeStackNavigationProp} from '@react-navigation/native-stack';
import * as Animatable from 'react-native-animatable';

import {MainStackParamList} from '../navigation/MainNavigator';
import {useAppDispatch, useAppSelector} from '../hooks/redux';
import {fetchDashboardData} from '../store/slices/dashboardSlice';
import BalanceCard from '../components/BalanceCard';
import QuickActionsCard from '../components/QuickActionsCard';
import TransactionSummaryCard from '../components/TransactionSummaryCard';
import ExpenseChart from '../components/ExpenseChart';
import RecentTransactions from '../components/RecentTransactions';
import LoadingScreen from '../components/LoadingScreen';
import ErrorMessage from '../components/ErrorMessage';
import {theme} from '../theme';

type NavigationProp = NativeStackNavigationProp<MainStackParamList>;

const {width} = Dimensions.get('window');

const HomeScreen: React.FC = () => {
  const navigation = useNavigation<NavigationProp>();
  const dispatch = useAppDispatch();
  const {data, isLoading, error} = useAppSelector(state => state.dashboard);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    dispatch(fetchDashboardData());
  }, [dispatch]);

  const handleRefresh = async () => {
    setRefreshing(true);
    await dispatch(fetchDashboardData());
    setRefreshing(false);
  };

  const handleAddTransaction = () => {
    navigation.navigate('AddTransaction', {});
  };

  if (isLoading && !data) {
    return <LoadingScreen />;
  }

  if (error) {
    return (
      <ErrorMessage
        message="Erro ao carregar dados do dashboard"
        onRetry={() => dispatch(fetchDashboardData())}
      />
    );
  }

  return (
    <View style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={handleRefresh} />
        }
        showsVerticalScrollIndicator={false}>
        <Animatable.View animation="fadeInUp" duration={800} delay={100}>
          <BalanceCard
            totalBalance={data?.totalBalance || 0}
            monthlyIncome={data?.monthlyIncome || 0}
            monthlyExpenses={data?.monthlyExpenses || 0}
            isLoading={isLoading}
          />
        </Animatable.View>

        <Animatable.View animation="fadeInUp" duration={800} delay={200}>
          <QuickActionsCard onTransactionAdded={handleRefresh} />
        </Animatable.View>

        <View style={styles.summaryRow}>
          <Animatable.View
            animation="fadeInLeft"
            duration={800}
            delay={300}
            style={styles.summaryCard}>
            <TransactionSummaryCard
              title="Receitas do Mês"
              amount={data?.monthlyIncome || 0}
              transactionCount={data?.incomeTransactionCount || 0}
              icon="trending-up"
              color={theme.colors.success}
              topCategories={data?.topIncomeCategories || []}
              isLoading={isLoading}
            />
          </Animatable.View>

          <Animatable.View
            animation="fadeInRight"
            duration={800}
            delay={300}
            style={styles.summaryCard}>
            <TransactionSummaryCard
              title="Gastos do Mês"
              amount={data?.monthlyExpenses || 0}
              transactionCount={data?.expenseTransactionCount || 0}
              icon="trending-down"
              color={theme.colors.error}
              topCategories={data?.topExpenseCategories || []}
              isLoading={isLoading}
            />
          </Animatable.View>
        </View>

        {data?.categoryExpenses &&
          Object.keys(data.categoryExpenses).length > 0 && (
            <Animatable.View animation="fadeInUp" duration={800} delay={400}>
              <ExpenseChart data={data.categoryExpenses} />
            </Animatable.View>
          )}

        <Animatable.View animation="fadeInUp" duration={800} delay={500}>
          <RecentTransactions
            transactions={data?.recentTransactions || []}
            onTransactionPress={transactionId =>
              navigation.navigate('EditTransaction', {transactionId})
            }
            onViewAll={() => navigation.navigate('MainTabs')}
          />
        </Animatable.View>

        <View style={styles.bottomSpacing} />
      </ScrollView>

      <FAB
        style={styles.fab}
        icon="plus"
        onPress={handleAddTransaction}
        color="white"
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
  },
  scrollView: {
    flex: 1,
  },
  summaryRow: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    marginBottom: 16,
  },
  summaryCard: {
    flex: 1,
    marginHorizontal: 6,
  },
  fab: {
    position: 'absolute',
    margin: 16,
    right: 0,
    bottom: 0,
    backgroundColor: theme.colors.secondary,
  },
  bottomSpacing: {
    height: 100,
  },
});

export default HomeScreen;