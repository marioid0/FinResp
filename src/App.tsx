import React, {useEffect} from 'react';
import {StatusBar, Platform} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {Provider as PaperProvider} from 'react-native-paper';
import {Provider as ReduxProvider} from 'react-redux';
import {PersistGate} from 'redux-persist/integration/react';
import SplashScreen from 'react-native-splash-screen';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import 'react-native-url-polyfill/auto';

import {store, persistor} from './store';
import {theme} from './theme';
import AppNavigator from './navigation/AppNavigator';
import LoadingScreen from './components/LoadingScreen';
import {supabase} from './services/supabase';
import {useAppDispatch} from './hooks/redux';
import {setUser, clearUser} from './store/slices/authSlice';

const AppContent: React.FC = () => {
  const dispatch = useAppDispatch();

  useEffect(() => {
    // Hide splash screen
    if (Platform.OS === 'android') {
      SplashScreen.hide();
    }

    // Listen for auth changes
    const {
      data: {subscription},
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (session?.user) {
        dispatch(setUser(session.user));
      } else {
        dispatch(clearUser());
      }
    });

    return () => subscription.unsubscribe();
  }, [dispatch]);

  return (
    <SafeAreaProvider>
      <StatusBar
        barStyle="light-content"
        backgroundColor={theme.colors.primary}
        translucent
      />
      <NavigationContainer>
        <AppNavigator />
      </NavigationContainer>
    </SafeAreaProvider>
  );
};

const App: React.FC = () => {
  return (
    <ReduxProvider store={store}>
      <PersistGate loading={<LoadingScreen />} persistor={persistor}>
        <PaperProvider theme={theme}>
          <AppContent />
        </PaperProvider>
      </PersistGate>
    </ReduxProvider>
  );
};

export default App;