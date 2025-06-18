import {createClient} from '@supabase/supabase-js';

const supabaseUrl = 'https://cnvtnmwvdvjxknsxgfkb.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNudnRubXd2ZHZqeGtuc3hnZmtiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NTM2MDYsImV4cCI6MjA2MzMyOTYwNn0.zgteKdobgStb5gbpntZadba9XYoGx-RuDKLnC9ETWOI';

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
  },
});