import {createSlice, createAsyncThunk} from '@reduxjs/toolkit';
import {supabase} from '../../services/supabase';
import {Transaction} from '../../types';

interface DashboardData {
  totalBalance: number;
  monthlyIncome: number;
  monthlyExpenses: number;
  recentTransactions: Transaction[];
  categoryExpenses: Record<string, number>;
  incomeTransactionCount: number;
  expenseTransactionCount: number;
  topIncomeCategories: string[];
  topExpenseCategories: string[];
}

interface DashboardState {
  data: DashboardData | null;
  isLoading: boolean;
  error: string | null;
}

const initialState: DashboardState = {
  data: null,
  isLoading: false,
  error: null,
};

export const fetchDashboardData = createAsyncThunk(
  'dashboard/fetchData',
  async (_, {getState}) => {
    const {auth} = getState() as any;
    if (!auth.user) throw new Error('User not authenticated');

    // Get current month's data
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

    // Fetch all user transactions
    const {data: allTransactions, error} = await supabase
      .from('registros')
      .select('*')
      .eq('user_id', auth.user.id)
      .order('created_at', {ascending: false});

    if (error) throw error;

    // Filter current month transactions
    const monthlyTransactions = allTransactions.filter(transaction => {
      const transactionDate = new Date(transaction.created_at);
      return transactionDate >= startOfMonth && transactionDate <= endOfMonth;
    });

    // Calculate totals
    let totalIncome = 0;
    let totalExpenses = 0;
    const categoryExpenses: Record<string, number> = {};

    allTransactions.forEach(transaction => {
      if (transaction.tipo === 'Entrada') {
        totalIncome += transaction.valor || 0;
      } else {
        totalExpenses += transaction.valor || 0;
        const category = transaction.categoria || 'Outros';
        categoryExpenses[category] =
          (categoryExpenses[category] || 0) + (transaction.valor || 0);
      }
    });

    // Calculate monthly totals
    let monthlyIncome = 0;
    let monthlyExpenses = 0;
    let incomeTransactionCount = 0;
    let expenseTransactionCount = 0;

    monthlyTransactions.forEach(transaction => {
      if (transaction.tipo === 'Entrada') {
        monthlyIncome += transaction.valor || 0;
        incomeTransactionCount++;
      } else {
        monthlyExpenses += transaction.valor || 0;
        expenseTransactionCount++;
      }
    });

    // Get top categories
    const topIncomeCategories = getTopCategories(
      allTransactions.filter(t => t.tipo === 'Entrada'),
    );
    const topExpenseCategories = getTopCategories(
      allTransactions.filter(t => t.tipo === 'Saída'),
    );

    return {
      totalBalance: totalIncome - totalExpenses,
      monthlyIncome,
      monthlyExpenses,
      recentTransactions: allTransactions.slice(0, 10),
      categoryExpenses,
      incomeTransactionCount,
      expenseTransactionCount,
      topIncomeCategories,
      topExpenseCategories,
    };
  },
);

const getTopCategories = (transactions: any[]): string[] => {
  const categoryTotals: Record<string, number> = {};

  transactions.forEach(transaction => {
    if (transaction.categoria) {
      categoryTotals[transaction.categoria] =
        (categoryTotals[transaction.categoria] || 0) +
        (transaction.valor || 0);
    }
  });

  return Object.entries(categoryTotals)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 3)
    .map(([category]) => category);
};

const dashboardSlice = createSlice({
  name: 'dashboard',
  initialState,
  reducers: {},
  extraReducers: builder => {
    builder
      .addCase(fetchDashboardData.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchDashboardData.fulfilled, (state, action) => {
        state.data = action.payload;
        state.isLoading = false;
        state.error = null;
      })
      .addCase(fetchDashboardData.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Erro ao carregar dados';
      });
  },
});

export default dashboardSlice.reducer;