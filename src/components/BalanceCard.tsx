import React from 'react';
import {View, StyleSheet, Dimensions} from 'react-native';
import {Text, Card} from 'react-native-paper';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';
import Icon from 'react-native-vector-icons/MaterialIcons';

import {theme} from '../theme';
import {formatCurrency} from '../utils/currency';
import AnimatedCounter from './AnimatedCounter';

interface BalanceCardProps {
  totalBalance: number;
  monthlyIncome: number;
  monthlyExpenses: number;
  isLoading?: boolean;
}

const {width} = Dimensions.get('window');

const BalanceCard: React.FC<BalanceCardProps> = ({
  totalBalance,
  monthlyIncome,
  monthlyExpenses,
  isLoading = false,
}) => {
  const balanceColor = totalBalance >= 0 ? theme.colors.success : theme.colors.error;

  return (
    <Card style={styles.card}>
      <LinearGradient
        colors={[theme.colors.primary, theme.colors.secondary]}
        style={styles.gradient}
        start={{x: 0, y: 0}}
        end={{x: 1, y: 1}}>
        <View style={styles.content}>
          {/* Header */}
          <View style={styles.header}>
            <Text style={styles.headerText}>Saldo Total</Text>
            <Icon name="account-balance-wallet" size={24} color="rgba(255, 255, 255, 0.8)" />
          </View>

          {/* Balance Amount */}
          <View style={styles.balanceContainer}>
            {isLoading ? (
              <View style={styles.loadingBalance} />
            ) : (
              <AnimatedCounter
                value={totalBalance}
                style={styles.balanceText}
                prefix="R$ "
              />
            )}
          </View>

          {/* Income and Expenses */}
          <View style={styles.metricsRow}>
            <MetricItem
              title="Receitas"
              value={monthlyIncome}
              icon="trending-up"
              color={theme.colors.success}
              isLoading={isLoading}
            />
            <MetricItem
              title="Gastos"
              value={monthlyExpenses}
              icon="trending-down"
              color={theme.colors.error}
              isLoading={isLoading}
            />
          </View>

          {/* Balance Indicator */}
          <View style={[styles.indicator, {backgroundColor: `${balanceColor}20`}]}>
            <Icon
              name={totalBalance >= 0 ? 'check-circle' : 'warning'}
              size={16}
              color={balanceColor}
            />
            <Text style={[styles.indicatorText, {color: balanceColor}]}>
              {totalBalance >= 0 ? 'Saldo Positivo' : 'Saldo Negativo'}
            </Text>
          </View>
        </View>
      </LinearGradient>
    </Card>
  );
};

interface MetricItemProps {
  title: string;
  value: number;
  icon: string;
  color: string;
  isLoading: boolean;
}

const MetricItem: React.FC<MetricItemProps> = ({
  title,
  value,
  icon,
  color,
  isLoading,
}) => (
  <View style={styles.metricItem}>
    <View style={styles.metricHeader}>
      <Icon name={icon} size={16} color={color} />
      <Text style={styles.metricTitle}>{title}</Text>
    </View>
    {isLoading ? (
      <View style={styles.loadingMetric} />
    ) : (
      <Text style={styles.metricValue}>{formatCurrency(value, true)}</Text>
    )}
  </View>
);

const styles = StyleSheet.create({
  card: {
    margin: 16,
    borderRadius: 20,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 4},
    shadowOpacity: 0.3,
    shadowRadius: 8,
  },
  gradient: {
    borderRadius: 20,
    padding: 24,
  },
  content: {
    gap: 16,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  headerText: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
    fontWeight: '500',
  },
  balanceContainer: {
    alignItems: 'flex-start',
  },
  balanceText: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
  },
  loadingBalance: {
    height: 40,
    width: 200,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 8,
  },
  metricsRow: {
    flexDirection: 'row',
    gap: 16,
  },
  metricItem: {
    flex: 1,
    backgroundColor: 'rgba(255, 255, 255, 0.1)',
    borderRadius: 12,
    padding: 12,
  },
  metricHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginBottom: 4,
  },
  metricTitle: {
    fontSize: 12,
    color: 'rgba(255, 255, 255, 0.8)',
    flex: 1,
  },
  metricValue: {
    fontSize: 16,
    fontWeight: 'bold',
    color: 'white',
  },
  loadingMetric: {
    height: 20,
    width: 80,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 4,
  },
  indicator: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    alignSelf: 'flex-start',
  },
  indicatorText: {
    fontSize: 12,
    fontWeight: '500',
  },
});

export default BalanceCard;