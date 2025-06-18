import {createSlice, createAsyncThunk, PayloadAction} from '@reduxjs/toolkit';
import {User} from '@supabase/supabase-js';
import {supabase} from '../../services/supabase';

interface AuthState {
  user: User | null;
  isLoading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  user: null,
  isLoading: false,
  error: null,
};

export const signIn = createAsyncThunk(
  'auth/signIn',
  async ({email, password}: {email: string; password: string}) => {
    const {data, error} = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) throw error;
    return data.user;
  },
);

export const signUp = createAsyncThunk(
  'auth/signUp',
  async ({
    email,
    password,
    name,
  }: {
    email: string;
    password: string;
    name: string;
  }) => {
    const {data, error} = await supabase.auth.signUp({
      email,
      password,
    });

    if (error) throw error;

    // Create user profile
    if (data.user) {
      const {error: profileError} = await supabase.from('usuarios').insert({
        user_id: data.user.id,
        nome: name,
        email: email,
      });

      if (profileError) throw profileError;
    }

    return data.user;
  },
);

export const signOut = createAsyncThunk('auth/signOut', async () => {
  const {error} = await supabase.auth.signOut();
  if (error) throw error;
});

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<User>) => {
      state.user = action.payload;
      state.isLoading = false;
      state.error = null;
    },
    clearUser: state => {
      state.user = null;
      state.isLoading = false;
      state.error = null;
    },
    setLoading: (state, action: PayloadAction<boolean>) => {
      state.isLoading = action.payload;
    },
  },
  extraReducers: builder => {
    builder
      .addCase(signIn.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signIn.fulfilled, (state, action) => {
        state.user = action.payload;
        state.isLoading = false;
        state.error = null;
      })
      .addCase(signIn.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Erro ao fazer login';
      })
      .addCase(signUp.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(signUp.fulfilled, (state, action) => {
        state.user = action.payload;
        state.isLoading = false;
        state.error = null;
      })
      .addCase(signUp.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Erro ao criar conta';
      })
      .addCase(signOut.fulfilled, state => {
        state.user = null;
        state.isLoading = false;
        state.error = null;
      });
  },
});

export const {setUser, clearUser, setLoading} = authSlice.actions;
export default authSlice.reducer;