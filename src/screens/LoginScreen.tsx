import React, {useState} from 'react';
import {
  View,
  StyleSheet,
  Dimensions,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import {
  Text,
  TextInput,
  Button,
  Card,
  SegmentedButtons,
} from 'react-native-paper';
import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';
import LinearGradient from 'react-native-linear-gradient';
import * as Animatable from 'react-native-animatable';
import Icon from 'react-native-vector-icons/MaterialIcons';

import {useAppDispatch} from '../hooks/redux';
import {signIn, signUp} from '../store/slices/authSlice';
import {theme} from '../theme';
import LoadingOverlay from '../components/LoadingOverlay';

const {width, height} = Dimensions.get('window');

const LoginScreen: React.FC = () => {
  const dispatch = useAppDispatch();
  const [mode, setMode] = useState<'login' | 'register'>('login');
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
  });
  const [isLoading, setIsLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleSubmit = async () => {
    if (mode === 'register' && formData.password !== formData.confirmPassword) {
      alert('As senhas não coincidem');
      return;
    }

    setIsLoading(true);
    try {
      if (mode === 'login') {
        await dispatch(
          signIn({email: formData.email, password: formData.password}),
        ).unwrap();
      } else {
        await dispatch(
          signUp({
            email: formData.email,
            password: formData.password,
            name: formData.name,
          }),
        ).unwrap();
      }
    } catch (error: any) {
      alert(error.message || 'Erro ao fazer login');
    } finally {
      setIsLoading(false);
    }
  };

  const updateFormData = (field: string, value: string) => {
    setFormData(prev => ({...prev, [field]: value}));
  };

  return (
    <LinearGradient
      colors={[theme.colors.primary, theme.colors.secondary]}
      style={styles.container}>
      <KeyboardAwareScrollView
        contentContainerStyle={styles.scrollContainer}
        enableOnAndroid
        extraScrollHeight={100}>
        <Animatable.View animation="fadeInDown" duration={1000}>
          <View style={styles.header}>
            <View style={styles.logoContainer}>
              <Icon
                name="account-balance-wallet"
                size={60}
                color="white"
                style={styles.logo}
              />
            </View>
            <Text style={styles.title}>FinResp</Text>
            <Text style={styles.subtitle}>
              Gerencie suas finanças com inteligência
            </Text>
          </View>
        </Animatable.View>

        <Animatable.View animation="fadeInUp" duration={1000} delay={300}>
          <Card style={styles.card}>
            <Card.Content style={styles.cardContent}>
              <SegmentedButtons
                value={mode}
                onValueChange={value => setMode(value as 'login' | 'register')}
                buttons={[
                  {value: 'login', label: 'Entrar'},
                  {value: 'register', label: 'Cadastrar'},
                ]}
                style={styles.segmentedButtons}
              />

              <View style={styles.form}>
                {mode === 'register' && (
                  <TextInput
                    label="Nome"
                    value={formData.name}
                    onChangeText={value => updateFormData('name', value)}
                    mode="outlined"
                    style={styles.input}
                    left={<TextInput.Icon icon="person" />}
                  />
                )}

                <TextInput
                  label="Email"
                  value={formData.email}
                  onChangeText={value => updateFormData('email', value)}
                  mode="outlined"
                  keyboardType="email-address"
                  autoCapitalize="none"
                  style={styles.input}
                  left={<TextInput.Icon icon="email" />}
                />

                <TextInput
                  label="Senha"
                  value={formData.password}
                  onChangeText={value => updateFormData('password', value)}
                  mode="outlined"
                  secureTextEntry={!showPassword}
                  style={styles.input}
                  left={<TextInput.Icon icon="lock" />}
                  right={
                    <TextInput.Icon
                      icon={showPassword ? 'visibility-off' : 'visibility'}
                      onPress={() => setShowPassword(!showPassword)}
                    />
                  }
                />

                {mode === 'register' && (
                  <TextInput
                    label="Confirmar Senha"
                    value={formData.confirmPassword}
                    onChangeText={value =>
                      updateFormData('confirmPassword', value)
                    }
                    mode="outlined"
                    secureTextEntry={!showConfirmPassword}
                    style={styles.input}
                    left={<TextInput.Icon icon="lock" />}
                    right={
                      <TextInput.Icon
                        icon={
                          showConfirmPassword ? 'visibility-off' : 'visibility'
                        }
                        onPress={() =>
                          setShowConfirmPassword(!showConfirmPassword)
                        }
                      />
                    }
                  />
                )}

                <Button
                  mode="contained"
                  onPress={handleSubmit}
                  style={styles.submitButton}
                  contentStyle={styles.submitButtonContent}
                  disabled={isLoading}>
                  {mode === 'login' ? 'Entrar' : 'Criar Conta'}
                </Button>
              </View>
            </Card.Content>
          </Card>
        </Animatable.View>
      </KeyboardAwareScrollView>

      {isLoading && <LoadingOverlay />}
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  scrollContainer: {
    flexGrow: 1,
    justifyContent: 'center',
    padding: 20,
  },
  header: {
    alignItems: 'center',
    marginBottom: 40,
  },
  logoContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 20,
  },
  logo: {
    textShadowColor: 'rgba(0, 0, 0, 0.3)',
    textShadowOffset: {width: 0, height: 2},
    textShadowRadius: 4,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
    textShadowColor: 'rgba(0, 0, 0, 0.3)',
    textShadowOffset: {width: 0, height: 2},
    textShadowRadius: 4,
  },
  subtitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.9)',
    textAlign: 'center',
    textShadowColor: 'rgba(0, 0, 0, 0.3)',
    textShadowOffset: {width: 0, height: 1},
    textShadowRadius: 2,
  },
  card: {
    borderRadius: 20,
    elevation: 8,
  },
  cardContent: {
    padding: 24,
  },
  segmentedButtons: {
    marginBottom: 24,
  },
  form: {
    gap: 16,
  },
  input: {
    backgroundColor: 'transparent',
  },
  submitButton: {
    marginTop: 8,
    borderRadius: 12,
  },
  submitButtonContent: {
    paddingVertical: 8,
  },
});

export default LoginScreen;