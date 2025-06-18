import React from 'react';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/MaterialIcons';

import HomeScreen from '../screens/HomeScreen';
import TransactionsScreen from '../screens/TransactionsScreen';
import ProfileScreen from '../screens/ProfileScreen';
import AddTransactionScreen from '../screens/AddTransactionScreen';
import EditTransactionScreen from '../screens/EditTransactionScreen';
import {theme} from '../theme';

export type MainTabParamList = {
  Dashboard: undefined;
  Transactions: undefined;
  Profile: undefined;
};

export type MainStackParamList = {
  MainTabs: undefined;
  AddTransaction: {type?: 'income' | 'expense'};
  EditTransaction: {transactionId: string};
};

const Tab = createBottomTabNavigator<MainTabParamList>();
const Stack = createNativeStackNavigator<MainStackParamList>();

const MainTabs: React.FC = () => {
  return (
    <Tab.Navigator
      screenOptions={({route}) => ({
        tabBarIcon: ({focused, color, size}) => {
          let iconName: string;

          switch (route.name) {
            case 'Dashboard':
              iconName = 'dashboard';
              break;
            case 'Transactions':
              iconName = 'receipt-long';
              break;
            case 'Profile':
              iconName = 'person';
              break;
            default:
              iconName = 'circle';
          }

          return <Icon name={iconName} size={size} color={color} />;
        },
        tabBarActiveTintColor: theme.colors.primary,
        tabBarInactiveTintColor: 'gray',
        tabBarStyle: {
          backgroundColor: 'white',
          borderTopWidth: 1,
          borderTopColor: theme.colors.outline,
          paddingBottom: 5,
          height: 60,
        },
        headerShown: false,
      })}>
      <Tab.Screen
        name="Dashboard"
        component={HomeScreen}
        options={{tabBarLabel: 'Início'}}
      />
      <Tab.Screen
        name="Transactions"
        component={TransactionsScreen}
        options={{tabBarLabel: 'Transações'}}
      />
      <Tab.Screen
        name="Profile"
        component={ProfileScreen}
        options={{tabBarLabel: 'Perfil'}}
      />
    </Tab.Navigator>
  );
};

const MainNavigator: React.FC = () => {
  return (
    <Stack.Navigator>
      <Stack.Screen
        name="MainTabs"
        component={MainTabs}
        options={{headerShown: false}}
      />
      <Stack.Screen
        name="AddTransaction"
        component={AddTransactionScreen}
        options={{
          title: 'Nova Transação',
          headerStyle: {backgroundColor: theme.colors.primary},
          headerTintColor: 'white',
          presentation: 'modal',
        }}
      />
      <Stack.Screen
        name="EditTransaction"
        component={EditTransactionScreen}
        options={{
          title: 'Editar Transação',
          headerStyle: {backgroundColor: theme.colors.primary},
          headerTintColor: 'white',
          presentation: 'modal',
        }}
      />
    </Stack.Navigator>
  );
};

export default MainNavigator;